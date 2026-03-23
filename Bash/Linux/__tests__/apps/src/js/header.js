/** Header auto-hide on scroll with hover-to-reveal. */
import { S, NAV_HIDE_DELAY, PASSIVE } from "./constants.js";
import { qs } from "./utils.js";

export function initNavAutoHide() {
  const nav = qs(S.mainNav);
  const zone = qs(S.navHoverZone);
  if (!nav || nav.dataset.boundHide) return;
  nav.dataset.boundHide = "1";

  let hideId = null;
  let lastY = 0;
  const navH = nav.offsetHeight || 72;

  function show() {
    nav.classList.remove("nav-hidden");
    nav.classList.add("nav-peek");
    if (hideId) clearTimeout(hideId);
  }

  function schedHide() {
    if (window.scrollY <= 0) return;
    hideId = setTimeout(() => {
      if (window.scrollY > 0) {
        nav.classList.add("nav-hidden");
        nav.classList.remove("nav-peek");
      }
    }, NAV_HIDE_DELAY);
  }

  window.addEventListener(
    "scroll",
    () => {
      const y = window.scrollY;
      if (y <= 0) {
        show();
        lastY = y;
        return;
      }
      if (y > lastY && y > navH) {
        nav.classList.add("nav-hidden");
        nav.classList.remove("nav-peek");
      }
      lastY = y;
    },
    PASSIVE
  );

  if (zone) zone.addEventListener("mouseenter", show);
  nav.addEventListener("mouseenter", show);
  nav.addEventListener("mouseleave", () => {
    if (window.scrollY > 0) schedHide();
  });
}
