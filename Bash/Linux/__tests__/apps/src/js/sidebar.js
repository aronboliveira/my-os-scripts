/** Sidebar toggle — hide/show with responsive grid adjustment. */
import { S } from "./constants.js";
import { qs } from "./utils.js";

export function initSidebarToggle() {
  const sidebar = qs(S.sidebar);
  const closeBtn = qs(S.sidebarClose);
  const toggleBtn = qs(S.sidebarToggle);
  if (!sidebar || !closeBtn || !toggleBtn || sidebar.dataset.boundSb) return;
  sidebar.dataset.boundSb = "1";

  function hide() {
    sidebar.classList.add("sidebar-hidden");
    toggleBtn.style.display = "flex";
    const sec = sidebar.parentElement?.querySelector("section");
    if (sec) {
      sec.classList.remove("col-lg-9", "col-xl-10");
      sec.classList.add("col-lg-12", "col-xl-12");
    }
  }

  function show() {
    sidebar.classList.remove("sidebar-hidden");
    toggleBtn.style.display = "none";
    const sec = sidebar.parentElement?.querySelector("section");
    if (sec) {
      sec.classList.remove("col-lg-12", "col-xl-12");
      sec.classList.add("col-lg-9", "col-xl-10");
    }
  }

  closeBtn.addEventListener("click", hide);
  toggleBtn.addEventListener("click", show);
}
