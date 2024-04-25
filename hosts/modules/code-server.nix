{...}: {
  services.code-server = {
    enable = false;
    # userDataDir = "";
    user = "mat";
    group = "mat";
    proxyDomain = "code-server.nyx.matmoa.xyz";
    host = "0.0.0.0";
    port = 8080;
    hashedPassword = "$argon2id$v=19$m=65536,t=5,p=2$MTIzcjgxZmR2YnNjMTk$gWTeCBO17s7GmIBYKTSxHzUZb53EOp1BrSWwZgmbKHE";
    # extraPackages = ["git"];
    extensionsDir = "/home/mat/.vscode/extensions";
    disableWorkspaceTrust = true;
    disableUpdateCheck = true;
    disableTelemetry = true;
    disableGettingStartedOverride = true;
    disableFileDownloads = false;
    auth = "password";
  };
}
