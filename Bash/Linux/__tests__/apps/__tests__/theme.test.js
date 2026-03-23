import { describe, it, expect, beforeEach, vi } from "vitest";
import { buildTestDOM, resetBindings } from "./setup.js";
import { initThemeToggle } from "../src/js/theme.js";

describe("theme toggle", () => {
  beforeEach(() => {
    buildTestDOM();
    resetBindings();
  });

  it("binds to #themeBtn", () => {
    initThemeToggle();
    const btn = document.getElementById("themeBtn");
    expect(btn.dataset.bound).toBe("1");
  });

  it("toggles data-bs-theme from dark to light", () => {
    document.documentElement.setAttribute("data-bs-theme", "dark");
    initThemeToggle();
    const btn = document.getElementById("themeBtn");
    btn.click();
    expect(document.documentElement.getAttribute("data-bs-theme")).toBe("light");
  });

  it("toggles data-bs-theme from light to dark", () => {
    document.documentElement.setAttribute("data-bs-theme", "light");
    initThemeToggle();
    const btn = document.getElementById("themeBtn");
    btn.click();
    expect(document.documentElement.getAttribute("data-bs-theme")).toBe("dark");
  });

  it("updates button icon to sun for dark mode", () => {
    document.documentElement.setAttribute("data-bs-theme", "light");
    initThemeToggle();
    const btn = document.getElementById("themeBtn");
    btn.click();
    const icon = btn.querySelector("i");
    expect(icon.className).toBe("bi bi-sun-fill");
  });

  it("updates button icon to moon for light mode", () => {
    document.documentElement.setAttribute("data-bs-theme", "dark");
    initThemeToggle();
    const btn = document.getElementById("themeBtn");
    btn.click();
    const icon = btn.querySelector("i");
    expect(icon.className).toBe("bi bi-moon-stars-fill");
  });

  it("saves to localStorage when storageKey provided", () => {
    const spy = vi.spyOn(Storage.prototype, "setItem");
    document.documentElement.setAttribute("data-bs-theme", "dark");
    initThemeToggle("test-theme");
    const btn = document.getElementById("themeBtn");
    btn.click();
    expect(spy).toHaveBeenCalledWith("test-theme", "light");
    spy.mockRestore();
  });

  it("does not save to localStorage without storageKey", () => {
    const spy = vi.spyOn(Storage.prototype, "setItem");
    document.documentElement.setAttribute("data-bs-theme", "dark");
    initThemeToggle();
    const btn = document.getElementById("themeBtn");
    btn.click();
    expect(spy).not.toHaveBeenCalled();
    spy.mockRestore();
  });

  it("restores theme from localStorage on init", () => {
    vi.spyOn(Storage.prototype, "getItem").mockReturnValue("light");
    initThemeToggle("test-theme");
    expect(document.documentElement.getAttribute("data-bs-theme")).toBe("light");
    vi.restoreAllMocks();
  });

  it("handles missing #themeBtn gracefully", () => {
    document.getElementById("themeBtn")?.remove();
    expect(() => initThemeToggle()).not.toThrow();
  });
});
