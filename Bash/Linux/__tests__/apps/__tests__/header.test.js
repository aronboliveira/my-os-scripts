import { describe, it, expect, beforeEach, vi } from "vitest";
import { buildTestDOM, resetBindings } from "./setup.js";
import { initNavAutoHide } from "../src/js/header.js";

describe("header auto-hide", () => {
  beforeEach(() => {
    buildTestDOM();
    resetBindings();
    // Give nav a measurable height
    const nav = document.getElementById("mainNav");
    Object.defineProperty(nav, "offsetHeight", { value: 72, configurable: true });
    initNavAutoHide();
  });

  it("binds to #mainNav", () => {
    const nav = document.getElementById("mainNav");
    expect(nav.dataset.boundHide).toBe("1");
  });

  it("hides nav when scrolling down past nav height", () => {
    const nav = document.getElementById("mainNav");
    // Simulate being at top first
    Object.defineProperty(window, "scrollY", { value: 0, writable: true, configurable: true });
    window.dispatchEvent(new Event("scroll"));
    // Now scroll down
    Object.defineProperty(window, "scrollY", { value: 200, writable: true, configurable: true });
    window.dispatchEvent(new Event("scroll"));
    expect(nav.classList.contains("nav-hidden")).toBe(true);
  });

  it("shows nav when at top of page", () => {
    const nav = document.getElementById("mainNav");
    // Scroll down first
    Object.defineProperty(window, "scrollY", { value: 200, writable: true, configurable: true });
    window.dispatchEvent(new Event("scroll"));
    // Now scroll back to top
    Object.defineProperty(window, "scrollY", { value: 0, writable: true, configurable: true });
    window.dispatchEvent(new Event("scroll"));
    expect(nav.classList.contains("nav-hidden")).toBe(false);
    expect(nav.classList.contains("nav-peek")).toBe(true);
  });

  it("shows nav on mouseenter", () => {
    const nav = document.getElementById("mainNav");
    // Hide it first
    Object.defineProperty(window, "scrollY", { value: 0, writable: true, configurable: true });
    window.dispatchEvent(new Event("scroll"));
    Object.defineProperty(window, "scrollY", { value: 200, writable: true, configurable: true });
    window.dispatchEvent(new Event("scroll"));
    // Hover over nav
    nav.dispatchEvent(new Event("mouseenter"));
    expect(nav.classList.contains("nav-hidden")).toBe(false);
    expect(nav.classList.contains("nav-peek")).toBe(true);
  });

  it("shows nav on hover zone mouseenter", () => {
    const nav = document.getElementById("mainNav");
    const zone = document.getElementById("navHoverZone");
    // Hide nav
    Object.defineProperty(window, "scrollY", { value: 0, writable: true, configurable: true });
    window.dispatchEvent(new Event("scroll"));
    Object.defineProperty(window, "scrollY", { value: 200, writable: true, configurable: true });
    window.dispatchEvent(new Event("scroll"));
    // Hover over zone
    zone.dispatchEvent(new Event("mouseenter"));
    expect(nav.classList.contains("nav-peek")).toBe(true);
  });

  it("schedules hide on mouseleave when scrolled", () => {
    vi.useFakeTimers();
    const nav = document.getElementById("mainNav");
    Object.defineProperty(window, "scrollY", { value: 200, writable: true, configurable: true });
    // Show
    nav.dispatchEvent(new Event("mouseenter"));
    expect(nav.classList.contains("nav-peek")).toBe(true);
    // Leave
    nav.dispatchEvent(new Event("mouseleave"));
    vi.advanceTimersByTime(2500); // NAV_HIDE_DELAY
    expect(nav.classList.contains("nav-hidden")).toBe(true);
    vi.useRealTimers();
  });

  it("does not hide on mouseleave when at top", () => {
    vi.useFakeTimers();
    const nav = document.getElementById("mainNav");
    Object.defineProperty(window, "scrollY", { value: 0, writable: true, configurable: true });
    nav.dispatchEvent(new Event("mouseenter"));
    nav.dispatchEvent(new Event("mouseleave"));
    vi.advanceTimersByTime(3000);
    expect(nav.classList.contains("nav-hidden")).toBe(false);
    vi.useRealTimers();
  });

  it("handles missing hover zone gracefully", () => {
    document.getElementById("navHoverZone")?.remove();
    resetBindings();
    expect(() => initNavAutoHide()).not.toThrow();
  });
});
