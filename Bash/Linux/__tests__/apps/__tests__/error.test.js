import { describe, it, expect, beforeEach } from "vitest";
import { buildTestDOM, resetBindings } from "./setup.js";
import { onError } from "../src/js/error.js";

describe("error banner", () => {
  beforeEach(() => {
    buildTestDOM();
    resetBindings();
    // Remove any existing error banner
    document.getElementById("fatal-alert")?.remove();
  });

  it("creates a fatal-alert div on first error", () => {
    const ev = new ErrorEvent("error", { message: "Test error" });
    onError(ev);
    const alert = document.getElementById("fatal-alert");
    expect(alert).not.toBeNull();
    expect(alert.getAttribute("role")).toBe("alert");
  });

  it("displays the error message", () => {
    const ev = new ErrorEvent("error", { message: "Something broke" });
    onError(ev);
    const alert = document.getElementById("fatal-alert");
    expect(alert.textContent).toContain("Something broke");
  });

  it("appends multiple errors to the same banner", () => {
    onError(new ErrorEvent("error", { message: "Error 1" }));
    onError(new ErrorEvent("error", { message: "Error 2" }));
    const alert = document.getElementById("fatal-alert");
    expect(alert.children.length).toBe(2);
  });

  it("handles unhandled rejection events", () => {
    // PromiseRejectionEvent may not be fully available in jsdom,
    // so pass an object that mimics .reason
    onError({ reason: "Rejected promise" });
    const alert = document.getElementById("fatal-alert");
    expect(alert.textContent).toContain("Rejected promise");
  });

  it("handles empty error message", () => {
    const ev = new ErrorEvent("error", { message: "" });
    onError(ev);
    const alert = document.getElementById("fatal-alert");
    expect(alert).not.toBeNull();
  });
});
