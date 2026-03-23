import { describe, it, expect, beforeEach, afterEach, vi } from "vitest";
import { buildTestDOM, resetBindings } from "./setup.js";
import { startDemo, stopDemo, toggleDemo, demoStates } from "../src/js/typing.js";

describe("typing animation", () => {
  beforeEach(() => {
    buildTestDOM();
    resetBindings();
    demoStates.clear();
    vi.useFakeTimers();
  });

  afterEach(() => {
    vi.useRealTimers();
  });

  describe("startDemo", () => {
    it("starts typing into the typed-cmd element", () => {
      startDemo("ex_test_a_0");
      // First char is typed immediately (synchronous tick), second after TYPING_SPEED
      const typed = document.getElementById("typed_ex_test_a_0");
      expect(typed.textContent).toBe("t");
      vi.advanceTimersByTime(45);
      expect(typed.textContent).toBe("te");
    });

    it("shows cursor when typing starts", () => {
      startDemo("ex_test_a_0");
      const cursor = document.getElementById("cursor_ex_test_a_0");
      expect(cursor.style.display).toBe("inline-block");
    });

    it("types the full command over time", () => {
      startDemo("ex_test_a_0");
      const cmd = "test-alias-a"; // 12 chars
      // Advance enough for all chars: 12 * 45ms = 540ms
      vi.advanceTimersByTime(cmd.length * 45);
      const typed = document.getElementById("typed_ex_test_a_0");
      expect(typed.textContent).toBe(cmd);
    });

    it("shows output after typing completes", () => {
      startDemo("ex_test_a_0");
      const cmd = "test-alias-a";
      const outEl = document.getElementById("output_ex_test_a_0");
      // Type all chars + OUTPUT_DELAY (400ms)
      vi.advanceTimersByTime(cmd.length * 45 + 400);
      expect(outEl.classList.contains("visible")).toBe(true);
      expect(outEl.textContent).toBeTruthy();
    });

    it("hides cursor after output is shown", () => {
      startDemo("ex_test_a_0");
      const cmd = "test-alias-a";
      vi.advanceTimersByTime(cmd.length * 45 + 400);
      const cursor = document.getElementById("cursor_ex_test_a_0");
      expect(cursor.style.display).toBe("none");
    });

    it("does nothing for non-existent id", () => {
      startDemo("nonexistent_id");
      expect(demoStates.has("nonexistent_id")).toBe(false);
    });

    it("sets playing state in demoStates map", () => {
      startDemo("ex_test_a_0");
      const state = demoStates.get("ex_test_a_0");
      expect(state).toBeDefined();
      expect(state.playing).toBe(true);
    });

    it("restarts after RESTART_DELAY", () => {
      startDemo("ex_test_a_0");
      const cmd = "test-alias-a";
      // Complete typing + output + restart delay
      vi.advanceTimersByTime(cmd.length * 45 + 400 + 3000);
      // After restart, typed should be cleared and re-typing
      const typed = document.getElementById("typed_ex_test_a_0");
      // It restarted, so it could be mid-typing again
      const state = demoStates.get("ex_test_a_0");
      expect(state.playing).toBe(true);
    });
  });

  describe("stopDemo", () => {
    it("stops a running demo", () => {
      startDemo("ex_test_a_0");
      vi.advanceTimersByTime(90); // 2 chars typed
      stopDemo("ex_test_a_0");
      const state = demoStates.get("ex_test_a_0");
      expect(state.playing).toBe(false);
    });

    it("hides the cursor", () => {
      startDemo("ex_test_a_0");
      vi.advanceTimersByTime(45);
      stopDemo("ex_test_a_0");
      const cursor = document.getElementById("cursor_ex_test_a_0");
      expect(cursor.style.display).toBe("none");
    });

    it("is safe to call on non-existent id", () => {
      expect(() => stopDemo("nope")).not.toThrow();
    });

    it("prevents further typing after stop", () => {
      startDemo("ex_test_a_0");
      vi.advanceTimersByTime(90); // 2 chars
      stopDemo("ex_test_a_0");
      const typed = document.getElementById("typed_ex_test_a_0");
      const textAfterStop = typed.textContent;
      vi.advanceTimersByTime(500);
      expect(typed.textContent).toBe(textAfterStop);
    });
  });

  describe("toggleDemo", () => {
    it("starts demo on first toggle", () => {
      const btn = document.querySelector(".demo-btn");
      toggleDemo(btn);
      expect(btn.classList.contains("playing")).toBe(true);
      const icon = btn.querySelector("i");
      expect(icon.className).toBe("bi bi-pause-fill");
      const label = btn.querySelector("span");
      expect(label.textContent).toBe("Stop demo");
    });

    it("stops demo on second toggle", () => {
      const btn = document.querySelector(".demo-btn");
      toggleDemo(btn); // start
      toggleDemo(btn); // stop
      expect(btn.classList.contains("playing")).toBe(false);
      const icon = btn.querySelector("i");
      expect(icon.className).toBe("bi bi-play-fill");
      const label = btn.querySelector("span");
      expect(label.textContent).toBe("Start demo");
    });

    it("does nothing when button has no data-demo-target", () => {
      const btn = document.createElement("button");
      expect(() => toggleDemo(btn)).not.toThrow();
    });
  });
});
