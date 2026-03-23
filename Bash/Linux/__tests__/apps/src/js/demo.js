/** Demo button binding + IntersectionObserver auto-stop. */
import { S } from "./constants.js";
import { qsa } from "./utils.js";
import { toggleDemo, stopDemo, demoStates } from "./typing.js";

/** Bind click handlers to all unbound demo buttons. */
export function initDemoButtons() {
  for (const btn of qsa(S.demoBtn)) {
    if (btn.dataset.bound) continue;
    btn.dataset.bound = "1";
    btn.addEventListener("click", () => toggleDemo(btn));
  }
}

/** Auto-stop demos when their blocks scroll out of view. */
export function initDemoVisibility() {
  if (!("IntersectionObserver" in window)) return;
  const obs = new IntersectionObserver(
    (entries) => {
      for (const e of entries) {
        if (!e.isIntersecting) {
          const id = e.target.dataset.exampleId;
          if (id && demoStates.get(id)?.playing) {
            stopDemo(id);
            const btn = e.target.querySelector(".demo-btn");
            if (btn) {
              btn.classList.remove("playing");
              const icon = btn.querySelector("i");
              const label = btn.querySelector("span");
              if (icon) icon.className = "bi bi-play-fill";
              if (label) label.textContent = "Start demo";
            }
          }
        }
      }
    },
    { threshold: 0 }
  );
  for (const block of qsa(".example-block[data-example-id]")) obs.observe(block);
}
