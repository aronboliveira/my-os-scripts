import { describe, it, expect, beforeEach } from "vitest";
import { buildTestDOM, resetBindings } from "./setup.js";
import { initTocTracking } from "../src/js/toc.js";

describe("TOC tracking", () => {
  beforeEach(() => {
    buildTestDOM();
    resetBindings();
  });

  it("binds TOC tracking to body", () => {
    initTocTracking();
    expect(document.body.dataset.boundToc).toBe("1");
  });

  it("does not double-bind", () => {
    initTocTracking();
    initTocTracking();
    expect(document.body.dataset.boundToc).toBe("1");
  });

  it("marks active link based on scroll position", () => {
    // Set up article positions
    const sectionA = document.getElementById("sectionA");
    const sectionB = document.getElementById("sectionB");
    Object.defineProperty(sectionA, "offsetTop", { value: 100, configurable: true });
    Object.defineProperty(sectionA, "offsetHeight", { value: 500, configurable: true });
    Object.defineProperty(sectionB, "offsetTop", { value: 600, configurable: true });
    Object.defineProperty(sectionB, "offsetHeight", { value: 400, configurable: true });

    initTocTracking();

    // Scroll to section A
    Object.defineProperty(window, "scrollY", { value: 100, writable: true, configurable: true });
    window.dispatchEvent(new Event("scroll"));

    const links = document.querySelectorAll("#tocSidebar .nav-link");
    expect(links[0].classList.contains("active")).toBe(true);
    expect(links[1].classList.contains("active")).toBe(false);
  });

  it("handles missing sections gracefully", () => {
    // Remove section targets
    document.getElementById("sectionA")?.remove();
    document.getElementById("sectionB")?.remove();
    expect(() => initTocTracking()).not.toThrow();
  });
});
