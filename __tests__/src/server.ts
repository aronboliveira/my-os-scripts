/**
 * Express server for serving HTML test pages.
 * Serves Bash and PowerShell reference pages for Cypress E2E testing.
 */

import express from "express";
import path from "path";

const app = express();
const PORT = process.env.PORT || 5175;

const ROOT = path.resolve(__dirname, "../..");

app.use("/Bash", express.static(path.join(ROOT, "Bash")));
app.use("/PowerShell", express.static(path.join(ROOT, "PowerShell")));
app.use("/__tests__", express.static(path.join(ROOT, "__tests__")));

app.get("/", (_req, res) => {
  res.redirect("/Bash/Linux/aliases-references.html");
});

app.get("/bash", (_req, res) => {
  res.sendFile(path.join(ROOT, "Bash/Linux/aliases-references.html"));
});

app.get("/powershell", (_req, res) => {
  res.sendFile(path.join(ROOT, "PowerShell/ps1/aliases-references.html"));
});

app.get("/combined", (_req, res) => {
  res.sendFile(path.join(ROOT, "index.html"));
});

app.listen(PORT, () => {
  console.log(`Test server running at http://localhost:${PORT}`);
  console.log(`  Bash:       http://localhost:${PORT}/bash`);
  console.log(`  PowerShell: http://localhost:${PORT}/powershell`);
  console.log(`  Combined:   http://localhost:${PORT}/combined`);
});
