import { describe, it, expect, beforeEach, vi } from "vitest";
import { buildTestDOM, resetBindings } from "./setup.js";
import { initScroll } from "../src/js/scroll.js";

describe("scroll & back-to-top", () => {
  beforeEach(() => {
    buildTestDOM();
    resetBindings();
  });

  it("binds click on #backToTop", () => {
    initScroll();
    const btn = document.getElementById("backToTop");
    expect(btn.dataset.bound).toBe("1");
  });

  it("calls scrollTo on click", () => {
    initScroll();
    const spy = vi.spyOn(window, "scrollTo").mockImplementation(() => {});
    const btn = document.getElementById("backToTop");
    btn.click();
    expect(spy).toHaveBeenCalledWith({ top: 0, behavior: "smooth" });
    spy.mockRestore();
  });

  it("adds scroll listener to body only once", () => {
    initScroll();
    initScroll(); // second call
    expect(document.body.dataset.boundScroll).toBe("1");
  });

  it("toggles .scrolled on nav when scrolled past threshold", () => {
    initScroll();
    const nav = document.getElementById("mainNav");

    Object.defineProperty(window, "scrollY", { value: 100, writable: true });
    window.dispatchEvent(new Event("scroll"));
    expect(nav.classList.contains("scrolled")).toBe(true);

    Object.defineProperty(window, "scrollY", { value: 10, writable: true });
    window.dispatchEvent(new Event("scroll"));
    expect(nav.classList.contains("scrolled")).toBe(false);
  });

  it("toggles .visible on backToTop when scrolled", () => {
    initScroll();
    const btn = document.getElementById("backToTop");

    Object.defineProperty(window, "scrollY", { value: 100, writable: true });
    window.dispatchEvent(new Event("scroll"));
    expect(btn.classList.contains("visible")).toBe(true);

    Object.defineProperty(window, "scrollY", { value: 10, writable: true });
    window.dispatchEvent(new Event("scroll"));
    expect(btn.classList.contains("visible")).toBe(false);
  });

  it("handles missing backToTop gracefully", () => {
    document.getElementById("backToTop")?.remove();
    expect(() => initScroll()).not.toThrow();
  });
});
