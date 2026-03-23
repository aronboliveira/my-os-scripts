import { describe, it, expect, beforeEach } from "vitest";
import { buildTestDOM, resetBindings } from "./setup.js";
import { initSidebarToggle } from "../src/js/sidebar.js";

describe("sidebar toggle", () => {
  beforeEach(() => {
    buildTestDOM();
    resetBindings();
    initSidebarToggle();
  });

  it("binds to sidebar elements", () => {
    const sidebar = document.getElementById("tocSidebar");
    expect(sidebar.dataset.boundSb).toBe("1");
  });

  it("hides sidebar on close button click", () => {
    const closeBtn = document.getElementById("sidebarCloseBtn");
    closeBtn.click();
    const sidebar = document.getElementById("tocSidebar");
    expect(sidebar.classList.contains("sidebar-hidden")).toBe(true);
  });

  it("shows toggle button when sidebar is hidden", () => {
    const closeBtn = document.getElementById("sidebarCloseBtn");
    closeBtn.click();
    const toggleBtn = document.getElementById("sidebarToggleBtn");
    expect(toggleBtn.style.display).toBe("flex");
  });

  it("shows sidebar on toggle button click", () => {
    const closeBtn = document.getElementById("sidebarCloseBtn");
    closeBtn.click(); // hide first
    const toggleBtn = document.getElementById("sidebarToggleBtn");
    toggleBtn.click(); // show
    const sidebar = document.getElementById("tocSidebar");
    expect(sidebar.classList.contains("sidebar-hidden")).toBe(false);
  });

  it("hides toggle button when sidebar is shown", () => {
    const closeBtn = document.getElementById("sidebarCloseBtn");
    closeBtn.click();
    const toggleBtn = document.getElementById("sidebarToggleBtn");
    toggleBtn.click();
    expect(toggleBtn.style.display).toBe("none");
  });

  it("expands section to full width when sidebar hidden", () => {
    const closeBtn = document.getElementById("sidebarCloseBtn");
    closeBtn.click();
    const sec = document.querySelector("section");
    expect(sec.classList.contains("col-lg-12")).toBe(true);
    expect(sec.classList.contains("col-xl-12")).toBe(true);
  });

  it("restores section columns when sidebar shown", () => {
    const closeBtn = document.getElementById("sidebarCloseBtn");
    closeBtn.click();
    const toggleBtn = document.getElementById("sidebarToggleBtn");
    toggleBtn.click();
    const sec = document.querySelector("section");
    expect(sec.classList.contains("col-lg-9")).toBe(true);
    expect(sec.classList.contains("col-xl-10")).toBe(true);
  });

  it("does not double-bind", () => {
    initSidebarToggle(); // second call
    const sidebar = document.getElementById("tocSidebar");
    expect(sidebar.dataset.boundSb).toBe("1");
  });

  it("handles missing sidebar gracefully", () => {
    document.getElementById("tocSidebar")?.remove();
    resetBindings();
    expect(() => initSidebarToggle()).not.toThrow();
  });
});
