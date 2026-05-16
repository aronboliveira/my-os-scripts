import { describe, it, expect, beforeEach } from "@jest/globals";
import { buildBashDOM, resetBashBindings } from "../../src/fixtures/bash-dom";
import BashApp from "../../src/iife/bash-app";

describe("Bash — Theme Toggle", () => {
  beforeEach(() => {
    buildBashDOM();
    resetBashBindings();
  });

  it("binds click handler to theme button", () => {
    BashApp.initThemeToggle();
    const btn = document.getElementById("themeBtn");
    expect(btn?.dataset.bound).toBe("1");
  });

  it("does not double-bind", () => {
    BashApp.initThemeToggle();
    BashApp.initThemeToggle();
    const btn = document.getElementById("themeBtn");
    expect(btn?.dataset.bound).toBe("1");
  });

  it("toggles theme between light and dark", () => {
    BashApp.initThemeToggle();
    const html = document.documentElement;
    const btn = document.getElementById("themeBtn")!;

    expect(html.getAttribute("data-bs-theme")).toBeNull();

    btn.click();
    expect(html.getAttribute("data-bs-theme")).toBe("dark");

    btn.click();
    expect(html.getAttribute("data-bs-theme")).toBe("light");
  });

  it("changes icon on theme toggle", () => {
    BashApp.initThemeToggle();
    const btn = document.getElementById("themeBtn")!;
    const icon = btn.querySelector("i")!;

    btn.click();
    expect(icon.className).toBe("bi bi-sun-fill");

    btn.click();
    expect(icon.className).toBe("bi bi-moon-stars-fill");
  });

  it("does not throw when theme button is missing", () => {
    document.getElementById("themeBtn")?.remove();
    expect(() => BashApp.initThemeToggle()).not.toThrow();
  });
});
