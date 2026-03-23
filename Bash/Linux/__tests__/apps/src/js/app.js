/**
 * Main entry point — initializes all modules and optionally mounts Vue.
 */
import { onError } from "./error.js";
import { initThemeToggle } from "./theme.js";
import { initSearch } from "./search.js";
import { initScroll } from "./scroll.js";
import { initNavAutoHide } from "./header.js";
import { initSidebarToggle } from "./sidebar.js";
import { initTocTracking } from "./toc.js";
import { initDemoButtons, initDemoVisibility } from "./demo.js";

/**
 * @param {Object} [options]
 * @param {string} [options.themeStorageKey] - localStorage key for theme persistence
 * @param {string} [options.mountId] - Vue mount target ID (default: "aliasApp")
 */
export function init(options = {}) {
  const { themeStorageKey, mountId = "aliasApp" } = options;

  window.addEventListener("error", onError);
  window.addEventListener("unhandledrejection", onError);
  initThemeToggle(themeStorageKey);
  initSearch();
  initScroll();
  initNavAutoHide();
  initSidebarToggle();
  initTocTracking();
  initDemoButtons();
  initDemoVisibility();
  initVueApp(mountId);
}

function initVueApp(mountId) {
  if (typeof Vue === "undefined") {
    console.warn("Vue.js not loaded — fallback mode.");
    return;
  }
  const appEl = document.getElementById(mountId);
  if (!appEl) return;
  try {
    Vue.createApp({
      data: () => ({ searchQuery: "" }),
      mounted() {
        this.$nextTick(() => {
          // Vue re-renders DOM, preserving data-bound attrs from the compiled
          // template but destroying event listeners. Clear binding flags so
          // init functions re-bind on the new DOM elements.
          const mount = document.getElementById(mountId);
          if (mount)
            for (const el of mount.querySelectorAll("[data-bound]"))
              delete el.dataset.bound;
          initSearch();
          initThemeToggle();
          initDemoButtons();
          initDemoVisibility();
        });
      },
      updated() {
        this.$nextTick(() => {
          initDemoButtons();
        });
      },
    }).mount(`#${mountId}`);
  } catch (e) {
    console.error("Vue init error:", e);
  }
}

/** Auto-init when used as a script tag. */
if (typeof window !== "undefined" && !window.__ALIASES_REF_TEST__) {
  document.readyState === "loading"
    ? document.addEventListener("DOMContentLoaded", () => init())
    : init();
}
