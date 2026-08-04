import os
from contextlib import closing
from typing import Any

import psycopg
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field


app = FastAPI(
    title="CloudIt Operations API",
    version="1.0.0",
    description="Backend API for storing CloudIt operational records.",
)

# Development convenience.
# In production, Nginx will proxy /api to this backend on the same domain.
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=False,
    allow_methods=["GET", "POST"],
    allow_headers=["*"],
)


class OperationCreate(BaseModel):
    service_name: str = Field(min_length=1, max_length=100)
    environment: str = Field(min_length=1, max_length=50)
    status: str = Field(min_length=1, max_length=50)
    note: str = Field(min_length=1, max_length=500)


def required_environment_variable(name: str) -> str:
    value = os.getenv(name)

    if not value:
        raise RuntimeError(f"{name} environment variable is not set")

    return value


def get_connection() -> psycopg.Connection[Any]:
    return psycopg.connect(
        host=os.getenv("POSTGRES_HOST", "postgres"),
        port=int(os.getenv("POSTGRES_PORT", "5432")),
        dbname=required_environment_variable("POSTGRES_DB"),
        user=required_environment_variable("POSTGRES_USER"),
        password=required_environment_variable("POSTGRES_PASSWORD"),
        connect_timeout=5,
    )


def initialize_database() -> None:
    """Create the operations table when the API starts."""

    with closing(get_connection()) as connection:
        with connection.cursor() as cursor:
            cursor.execute(
                """
                CREATE TABLE IF NOT EXISTS operations (
                    id SERIAL PRIMARY KEY,
                    service_name VARCHAR(100) NOT NULL,
                    environment VARCHAR(50) NOT NULL,
                    status VARCHAR(50) NOT NULL,
                    note VARCHAR(500) NOT NULL,
                    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
                );
                """
            )
        connection.commit()


@app.on_event("startup")
def startup_event() -> None:
    try:
        initialize_database()
    except Exception as exc:
        # Failing startup is preferable to silently running without a database.
        raise RuntimeError(f"Database initialization failed: {exc}") from exc


@app.get("/health")
def health() -> dict[str, str]:
    try:
        with closing(get_connection()) as connection:
            with connection.cursor() as cursor:
                cursor.execute("SELECT 1;")
                cursor.fetchone()

        return {
            "status": "healthy",
            "database": "connected",
        }

    except Exception as exc:
        raise HTTPException(
            status_code=503,
            detail=f"Database connection failed: {exc}",
        ) from exc


@app.get("/api/operations")
def list_operations() -> list[dict[str, Any]]:
    try:
        with closing(get_connection()) as connection:
            with connection.cursor() as cursor:
                cursor.execute(
                    """
                    SELECT
                        id,
                        service_name,
                        environment,
                        status,
                        note,
                        created_at
                    FROM operations
                    ORDER BY created_at DESC
                    LIMIT 100;
                    """
                )

                rows = cursor.fetchall()

        return [
            {
                "id": row[0],
                "service_name": row[1],
                "environment": row[2],
                "status": row[3],
                "note": row[4],
                "created_at": row[5],
            }
            for row in rows
        ]

    except Exception as exc:
        raise HTTPException(
            status_code=500,
            detail=f"Unable to read operations: {exc}",
        ) from exc


@app.post("/api/operations", status_code=201)
def create_operation(operation: OperationCreate) -> dict[str, Any]:
    try:
        with closing(get_connection()) as connection:
            with connection.cursor() as cursor:
                cursor.execute(
                    """
                    INSERT INTO operations (
                        service_name,
                        environment,
                        status,
                        note
                    )
                    VALUES (%s, %s, %s, %s)
                    RETURNING
                        id,
                        service_name,
                        environment,
                        status,
                        note,
                        created_at;
                    """,
                    (
                        operation.service_name,
                        operation.environment,
                        operation.status,
                        operation.note,
                    ),
                )

                row = cursor.fetchone()

            connection.commit()

        if row is None:
            raise RuntimeError("PostgreSQL did not return the inserted record")

        return {
            "id": row[0],
            "service_name": row[1],
            "environment": row[2],
            "status": row[3],
            "note": row[4],
            "created_at": row[5],
        }

    except Exception as exc:
        raise HTTPException(
            status_code=500,
            detail=f"Unable to save operation: {exc}",
        ) from exc