import { describe, it, expect, beforeEach } from "@jest/globals";
import { buildBashDOM, resetBashBindings } from "../../src/fixtures/bash-dom";
import BashApp from "../../src/iife/bash-app";

describe("Bash — Error Handling", () => {
  beforeEach(() => {
    buildBashDOM();
    resetBashBindings();
  });

  it("creates fatal-alert banner on error event", () => {
    const ev = new ErrorEvent("error", { message: "Test error" });
    BashApp.onError(ev);

    const banner = document.getElementById("fatal-alert");
    expect(banner).not.toBeNull();
    expect(banner?.textContent).toContain("Test error");
  });

  it("creates fatal-alert banner on unhandled rejection", () => {
    const ev = {
      type: "unhandledrejection",
      reason: "Rejected!",
    } as unknown as PromiseRejectionEvent;
    BashApp.onError(ev);

    const banner = document.getElementById("fatal-alert");
    expect(banner).not.toBeNull();
  });

  it("appends to existing fatal-alert", () => {
    const first = new ErrorEvent("error", { message: "First" });
    const second = new ErrorEvent("error", { message: "Second" });
    BashApp.onError(first);
    BashApp.onError(second);

    const banner = document.getElementById("fatal-alert")!;
    const children = banner.querySelectorAll("div");
    expect(children.length).toBe(2);
  });
});

describe("Bash — Error Banner on Init", () => {
  beforeEach(() => {
    buildBashDOM();
    resetBashBindings();
  });

  it("registers error event listeners on init", () => {
    const addEventListenerSpy = jest.spyOn(window, "addEventListener");
    BashApp.init();

    // Error listener + unhandledrejection listener
    expect(addEventListenerSpy).toHaveBeenCalledWith(
      "error",
      expect.any(Function),
    );
    expect(addEventListenerSpy).toHaveBeenCalledWith(
      "unhandledrejection",
      expect.any(Function),
    );

    addEventListenerSpy.mockRestore();
  });
});
