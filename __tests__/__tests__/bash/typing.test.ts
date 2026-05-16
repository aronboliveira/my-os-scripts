import { describe, it, expect, beforeEach, jest } from "@jest/globals";
import { buildBashDOM, resetBashBindings } from "../../src/fixtures/bash-dom";
import BashApp from "../../src/iife/bash-app";

describe("Bash — Typing Animation", () => {
  beforeEach(() => {
    buildBashDOM();
    resetBashBindings();
    jest.useFakeTimers();
  });

  afterEach(() => {
    jest.useRealTimers();
  });

  it("starts typing the demo command", () => {
    BashApp.startDemo("ex_show_user_0");

    jest.advanceTimersByTime(45 * 9); // "show-user" is 9 chars
    const typed = document.getElementById("typed_ex_show_user_0");
    expect(typed?.textContent).toBe("show-user");
  });

  it("shows output after typing completes", () => {
    BashApp.startDemo("ex_show_user_0");

    // Type all chars + output delay
    jest.advanceTimersByTime(45 * 9 + 400);
    const outEl = document.getElementById("output_ex_show_user_0");
    expect(outEl?.classList.contains("visible")).toBe(true);
    expect(outEl?.textContent).toBe("aronboliveira");
  });

  it("stops demo and hides cursor", () => {
    BashApp.startDemo("ex_show_user_0");
    expect(BashApp.isDemoPlaying("ex_show_user_0")).toBe(true);

    BashApp.stopDemo("ex_show_user_0");
    expect(BashApp.isDemoPlaying("ex_show_user_0")).toBe(false);

    const cursor = document.getElementById("cursor_ex_show_user_0");
    expect(cursor?.style.display).toBe("none");
  });

  it("does not throw when demo block is missing", () => {
    document.querySelector('[data-example-id="ex_show_user_0"]')?.remove();
    expect(() => BashApp.startDemo("ex_show_user_0")).not.toThrow();
  });
});

describe("Bash — Demo Button Binding", () => {
  beforeEach(() => {
    buildBashDOM();
    resetBashBindings();
  });

  it("binds click handlers to demo buttons", () => {
    BashApp.initDemoButtons();
    const btn = document.querySelector(
      ".demo-btn",
    ) as HTMLElement;
    expect(btn.dataset.bound).toBe("1");
  });

  it("does not double-bind demo buttons", () => {
    BashApp.initDemoButtons();
    BashApp.initDemoButtons();
    const btn = document.querySelector(
      ".demo-btn",
    ) as HTMLElement;
    expect(btn.dataset.bound).toBe("1");
  });
});
