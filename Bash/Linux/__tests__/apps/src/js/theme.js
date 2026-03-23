/** Theme toggle — light/dark mode switching. */
import { S } from "./constants.js";
import { qs } from "./utils.js";

/**
 * @param {string} [storageKey] - localStorage key for persisting theme (e.g. "ps-ref-theme")
 */
export function initThemeToggle(storageKey) {
  const btn = qs(S.themeBtn);
  if (!btn || btn.dataset.bound) return;
  btn.dataset.bound = "1";

  btn.addEventListener("click", () => {
    const html = document.documentElement;
    const next =
      html.getAttribute("data-bs-theme") === "dark" ? "light" : "dark";
    html.setAttribute("data-bs-theme", next);
    if (storageKey) {
      try {
        localStorage.setItem(storageKey, next);
      } catch {
        /* storage unavailable */
      }
    }
    const i = btn.querySelector("i");
    if (i)
      i.className =
        next === "dark" ? "bi bi-sun-fill" : "bi bi-moon-stars-fill";
  });

  // Restore saved theme
  if (storageKey) {
    try {
      const saved = localStorage.getItem(storageKey);
      if (saved) {
        document.documentElement.setAttribute("data-bs-theme", saved);
        const i = btn.querySelector("i");
        if (i)
          i.className =
            saved === "dark" ? "bi bi-sun-fill" : "bi bi-moon-stars-fill";
      }
    } catch {
      /* storage unavailable */
    }
  }
}
