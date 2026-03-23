/**
 * Typing animation engine.
 * startDemo, stopDemo, toggleDemo — character-by-character typing with cursor blink.
 */
import { TYPING_SPEED, OUTPUT_DELAY, RESTART_DELAY } from "./constants.js";
import { decodeEntities } from "./utils.js";

/** @type {Map<string, {playing: boolean, tid: number|null, ci: number}>} */
export const demoStates = new Map();

/**
 * Start the typing animation for a given example block.
 * @param {string} id - The example id (data-example-id value)
 */
export function startDemo(id) {
  const block = document.querySelector(`[data-example-id="${id}"]`);
  if (!block) return;
  const cmd = decodeEntities(block.dataset.cmd || "");
  const output = decodeEntities(block.dataset.output || "");
  const typed = document.getElementById(`typed_${id}`);
  const cursor = document.getElementById(`cursor_${id}`);
  const outEl = document.getElementById(`output_${id}`);
  if (!typed || !cursor || !outEl) return;

  typed.textContent = "";
  outEl.textContent = "";
  outEl.classList.remove("visible");
  cursor.style.display = "inline-block";

  const state = { playing: true, tid: null, ci: 0 };
  demoStates.set(id, state);

  (function tick() {
    if (!demoStates.get(id)?.playing) return;
    if (state.ci < cmd.length) {
      typed.textContent += cmd[state.ci++];
      state.tid = setTimeout(tick, TYPING_SPEED);
    } else {
      state.tid = setTimeout(() => {
        if (!demoStates.get(id)?.playing) return;
        cursor.style.display = "none";
        outEl.textContent = output;
        outEl.classList.add("visible");
        state.tid = setTimeout(() => {
          if (demoStates.get(id)?.playing) startDemo(id);
        }, RESTART_DELAY);
      }, OUTPUT_DELAY);
    }
  })();
}

/**
 * Stop the typing animation for a given example block.
 * @param {string} id
 */
export function stopDemo(id) {
  const s = demoStates.get(id);
  if (s) {
    s.playing = false;
    if (s.tid) clearTimeout(s.tid);
  }
  const c = document.getElementById(`cursor_${id}`);
  if (c) c.style.display = "none";
}

/**
 * Toggle a demo button (start/stop).
 * @param {HTMLButtonElement} btn
 */
export function toggleDemo(btn) {
  const id = btn.dataset.demoTarget;
  if (!id) return;
  const playing = demoStates.get(id)?.playing;
  if (playing) {
    stopDemo(id);
    btn.classList.remove("playing");
    const icon = btn.querySelector("i");
    const label = btn.querySelector("span");
    if (icon) icon.className = "bi bi-play-fill";
    if (label) label.textContent = "Start demo";
  } else {
    startDemo(id);
    btn.classList.add("playing");
    const icon = btn.querySelector("i");
    const label = btn.querySelector("span");
    if (icon) icon.className = "bi bi-pause-fill";
    if (label) label.textContent = "Stop demo";
  }
}
