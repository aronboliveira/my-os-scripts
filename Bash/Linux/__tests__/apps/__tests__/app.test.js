import { describe, it, expect, beforeEach, vi } from "vitest";
import { buildTestDOM, resetBindings } from "./setup.js";

describe("app initialization", () => {
  beforeEach(() => {
    buildTestDOM();
    resetBindings();
    // Set test flag to prevent auto-init on import
    window.__ALIASES_REF_TEST__ = true;
  });

  afterEach(() => {
    delete window.__ALIASES_REF_TEST__;
  });

  it("init() calls all sub-initializers without errors", async () => {
    const { init } = await import("../src/js/app.js");
    expect(() => init()).not.toThrow();
  });

  it("init() binds search, theme, scroll, sidebar, toc", async () => {
    const { init } = await import("../src/js/app.js");
    init();
    expect(document.getElementById("aliasSearch").dataset.bound).toBe("1");
    expect(document.getElementById("themeBtn").dataset.bound).toBe("1");
    expect(document.getElementById("backToTop").dataset.bound).toBe("1");
    expect(document.getElementById("tocSidebar").dataset.boundSb).toBe("1");
    expect(document.body.dataset.boundToc).toBe("1");
  });

  it("init() registers global error handlers", async () => {
    const spy = vi.spyOn(window, "addEventListener");
    const { init } = await import("../src/js/app.js");
    init();
    const calls = spy.mock.calls.map((c) => c[0]);
    expect(calls).toContain("error");
    expect(calls).toContain("unhandledrejection");
    spy.mockRestore();
  });

  it("init() works without Vue.js loaded", async () => {
    // Ensure Vue is not defined
    delete globalThis.Vue;
    const { init } = await import("../src/js/app.js");
    const warn = vi.spyOn(console, "warn").mockImplementation(() => {});
    expect(() => init()).not.toThrow();
    warn.mockRestore();
  });
});
