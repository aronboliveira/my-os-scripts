/** Global error banner. */
export function onError(ev) {
  const msg =
    ev instanceof ErrorEvent
      ? ev.message || "Unknown error"
      : String(ev.reason || ev);
  let b = document.getElementById("fatal-alert");
  if (!b) {
    b = document.createElement("div");
    b.id = "fatal-alert";
    b.setAttribute("role", "alert");
    b.style.cssText =
      "position:fixed;top:0;left:0;right:0;z-index:9999;" +
      "background:#dc3545;color:#fff;padding:12px 20px;font-family:monospace;font-size:14px;";
    (document.body || document.documentElement).prepend(b);
  }
  const d = document.createElement("div");
  d.textContent = "\u26A0\uFE0F " + msg;
  b.appendChild(d);
}
