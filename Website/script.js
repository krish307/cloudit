console.log('CloudIt');
const config = window.APP_CONFIG || {};

console.log("CloudIt runtime configuration:", config);

const runtimeConfig = document.createElement("section");
runtimeConfig.className = "runtime-config";

runtimeConfig.innerHTML = `
  <h2>${config.appName || "CloudIt"}</h2>
  <p>Version: ${config.appVersion || "unknown"}</p>
  <p>Environment: ${config.environment || "unknown"}</p>
  <p>Managed by: ${config.company || "unknown"}</p>
`;

document.body.appendChild(runtimeConfig);