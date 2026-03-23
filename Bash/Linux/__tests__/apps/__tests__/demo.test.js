import { describe, it, expect, beforeEach, vi } from "vitest";
import { buildTestDOM, resetBindings } from "./setup.js";
import { initDemoButtons, initDemoVisibility } from "../src/js/demo.js";
import { demoStates, startDemo } from "../src/js/typing.js";

describe("demo buttons", () => {
  beforeEach(() => {
    buildTestDOM();
    resetBindings();
    demoStates.clear();
  });

  it("binds click handlers to demo buttons", () => {
    initDemoButtons();
    const btns = document.querySelectorAll(".demo-btn");
    for (const btn of btns) {
      expect(btn.dataset.bound).toBe("1");
    }
  });

  it("does not double-bind buttons", () => {
    initDemoButtons();
    initDemoButtons();
    const btns = document.querySelectorAll(".demo-btn");
    for (const btn of btns) {
      expect(btn.dataset.bound).toBe("1");
    }
  });

  it("toggles demo on button click", () => {
    vi.useFakeTimers();
    initDemoButtons();
    const btn = document.querySelector(".demo-btn");
    btn.click(); // start
    expect(btn.classList.contains("playing")).toBe(true);
    btn.click(); // stop
    expect(btn.classList.contains("playing")).toBe(false);
    vi.useRealTimers();
  });
});

describe("demo visibility (IntersectionObserver)", () => {
  let observeSpy;
  let observerCallback;

  beforeEach(() => {
    buildTestDOM();
    resetBindings();
    demoStates.clear();

    // Mock IntersectionObserver
    observeSpy = vi.fn();
    vi.stubGlobal(
      "IntersectionObserver",
      vi.fn((cb) => {
        observerCallback = cb;
        return { observe: observeSpy, disconnect: vi.fn() };
      })
    );
  });

  it("creates an IntersectionObserver", () => {
    initDemoVisibility();
    expect(IntersectionObserver).toHaveBeenCalledOnce();
  });

  it("observes all example blocks", () => {
    initDemoVisibility();
    const blocks = document.querySelectorAll(".example-block[data-example-id]");
    expect(observeSpy).toHaveBeenCalledTimes(blocks.length);
  });

  it("stops demo when block scrolls out of view", () => {
    vi.useFakeTimers();
    initDemoVisibility();
    // Start a demo
    startDemo("ex_test_a_0");
    expect(demoStates.get("ex_test_a_0")?.playing).toBe(true);

    // Simulate block going out of view
    const block = document.querySelector('[data-example-id="ex_test_a_0"]');
    observerCallback([
      {
        isIntersecting: false,
        target: block,
      },
    ]);
    expect(demoStates.get("ex_test_a_0")?.playing).toBe(false);
    vi.useRealTimers();
  });

  it("resets button state when auto-stopped", () => {
    vi.useFakeTimers();
    initDemoButtons();
    initDemoVisibility();

    const btn = document.querySelector(".demo-btn");
    btn.click(); // start
    expect(btn.classList.contains("playing")).toBe(true);

    const block = document.querySelector('[data-example-id="ex_test_a_0"]');
    observerCallback([{ isIntersecting: false, target: block }]);
    expect(btn.classList.contains("playing")).toBe(false);
    expect(btn.querySelector("span").textContent).toBe("Start demo");
    vi.useRealTimers();
  });
});
