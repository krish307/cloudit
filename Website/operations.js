const API_BASE_URL = "";

const form = document.getElementById("operation-form");
const submitButton = document.getElementById("submit-button");
const refreshButton = document.getElementById("refresh-button");
const formMessage = document.getElementById("form-message");
const healthStatus = document.getElementById("health-status");
const operationsList = document.getElementById("operations-list");

function escapeHtml(value) {
  const element = document.createElement("div");
  element.textContent = String(value);
  return element.innerHTML;
}

function formatDate(value) {
  return new Intl.DateTimeFormat(undefined, {
    dateStyle: "medium",
    timeStyle: "short",
  }).format(new Date(value));
}

async function checkHealth() {
  try {
    const response = await fetch(`${API_BASE_URL}/health`);

    if (!response.ok) {
      throw new Error(`Health request failed: ${response.status}`);
    }

    const health = await response.json();

    healthStatus.textContent =
      `API ${health.status} · Database ${health.database}`;

    healthStatus.className = "health healthy";
  } catch (error) {
    healthStatus.textContent = "API unavailable";
    healthStatus.className = "health unhealthy";
    console.error(error);
  }
}

async function loadOperations() {
  operationsList.innerHTML = "<p>Loading operations…</p>";

  try {
    const response = await fetch(`${API_BASE_URL}/api/operations`);

    if (!response.ok) {
      throw new Error(`Unable to load operations: ${response.status}`);
    }

    const operations = await response.json();

    if (operations.length === 0) {
      operationsList.innerHTML =
        "<p>No operations have been recorded yet.</p>";
      return;
    }

    operationsList.innerHTML = operations
      .map(
        (operation) => `
          <article class="operation-card">
            <div class="operation-card-header">
              <div>
                <h3>${escapeHtml(operation.service_name)}</h3>
                <p>${escapeHtml(operation.environment)}</p>
              </div>

              <span class="status-badge">
                ${escapeHtml(operation.status)}
              </span>
            </div>

            <p class="operation-note">
              ${escapeHtml(operation.note)}
            </p>

            <time datetime="${escapeHtml(operation.created_at)}">
              ${escapeHtml(formatDate(operation.created_at))}
            </time>
          </article>
        `,
      )
      .join("");
  } catch (error) {
    operationsList.innerHTML =
      "<p class=\"error-message\">Unable to load operations.</p>";

    console.error(error);
  }
}

form.addEventListener("submit", async (event) => {
  event.preventDefault();

  submitButton.disabled = true;
  formMessage.textContent = "Saving…";
  formMessage.className = "";

  const payload = {
    service_name: document.getElementById("service-name").value.trim(),
    environment: document.getElementById("environment").value,
    status: document.getElementById("status").value,
    note: document.getElementById("note").value.trim(),
  };

  try {
    const response = await fetch(`${API_BASE_URL}/api/operations`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(payload),
    });

    if (!response.ok) {
      const errorBody = await response.text();
      throw new Error(
        `Save failed: ${response.status} ${errorBody}`,
      );
    }

    document.getElementById("note").value = "";

    formMessage.textContent = "Operation saved successfully.";
    formMessage.className = "success-message";

    await loadOperations();
  } catch (error) {
    formMessage.textContent = "Unable to save the operation.";
    formMessage.className = "error-message";

    console.error(error);
  } finally {
    submitButton.disabled = false;
  }
});

refreshButton.addEventListener("click", loadOperations);

checkHealth();
loadOperations();