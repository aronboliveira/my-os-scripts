import { describe, it, expect, beforeEach, jest } from "@jest/globals";
import { buildBashDOM, resetBashBindings } from "../../src/fixtures/bash-dom";
import BashApp from "../../src/iife/bash-app";

describe("Bash — Scroll / Back-to-Top", () => {
  beforeEach(() => {
    buildBashDOM();
    resetBashBindings();
    jest.useFakeTimers();
  });

  afterEach(() => {
    jest.useRealTimers();
  });

  it("binds back-to-top click handler", () => {
    BashApp.initScroll();
    const btn = document.getElementById("backToTop");
    expect(btn?.dataset.bound).toBe("1");
  });

  it("does not double-bind scroll listeners", () => {
    BashApp.initScroll();
    BashApp.initScroll();
    expect(document.body.dataset.boundScroll).toBe("1");
  });

  it("does not throw when backToTop is missing", () => {
    document.getElementById("backToTop")?.remove();
    expect(() => BashApp.initScroll()).not.toThrow();
  });
});

describe("Bash — Sidebar Toggle", () => {
  beforeEach(() => {
    buildBashDOM();
    resetBashBindings();
  });

  it("marks sidebar as bound", () => {
    BashApp.initSidebarToggle();
    const sidebar = document.getElementById("tocSidebar");
    expect(sidebar?.dataset.boundSb).toBe("1");
  });

  it("does not double-bind sidebar", () => {
    BashApp.initSidebarToggle();
    BashApp.initSidebarToggle();
    const sidebar = document.getElementById("tocSidebar");
    expect(sidebar?.dataset.boundSb).toBe("1");
  });

  it("hides sidebar on close button click", () => {
    BashApp.initSidebarToggle();
    const sidebar = document.getElementById("tocSidebar")!;
    const closeBtn = document.getElementById("sidebarCloseBtn")!;

    closeBtn.click();
    expect(sidebar.classList.contains("sidebar-hidden")).toBe(true);
  });

  it("shows sidebar on toggle button click", () => {
    BashApp.initSidebarToggle();
    const sidebar = document.getElementById("tocSidebar")!;
    const closeBtn = document.getElementById("sidebarCloseBtn")!;
    const toggleBtn = document.getElementById("sidebarToggleBtn") as HTMLElement;

    closeBtn.click(); // hide
    toggleBtn.click(); // show
    expect(sidebar.classList.contains("sidebar-hidden")).toBe(false);
  });

  it("does not throw when elements are missing", () => {
    document.getElementById("tocSidebar")?.remove();
    document.getElementById("sidebarCloseBtn")?.remove();
    document.getElementById("sidebarToggleBtn")?.remove();
    expect(() => BashApp.initSidebarToggle()).not.toThrow();
  });
});

describe("Bash — TOC Tracking", () => {
  beforeEach(() => {
    buildBashDOM();
    resetBashBindings();
  });

  it("marks body as bound for TOC", () => {
    BashApp.initTocTracking();
    expect(document.body.dataset.boundToc).toBe("1");
  });

  it("does not double-bind TOC", () => {
    BashApp.initTocTracking();
    BashApp.initTocTracking();
    expect(document.body.dataset.boundToc).toBe("1");
  });

  it("does not throw when TOC links are missing", () => {
    const sidebar = document.getElementById("tocSidebar")!;
    sidebar.querySelectorAll("a.nav-link").forEach((l) => l.remove());
    expect(() => BashApp.initTocTracking()).not.toThrow();
  });
});
