/** TOC active-section tracking. */
import { S, PASSIVE } from "./constants.js";
import { qs, qsa } from "./utils.js";

export function initTocTracking() {
  if (document.body.dataset.boundToc) return;
  document.body.dataset.boundToc = "1";
  const secs = [];
  for (const link of qsa(S.tocLinks)) {
    const href = link.getAttribute("href");
    if (!href?.startsWith("#")) continue;
    const sec = qs(href);
    if (sec) secs.push(Object.freeze({ link, sec }));
  }
  if (!secs.length) return;
  window.addEventListener(
    "scroll",
    () => {
      const sp = window.scrollY + 150;
      for (const { link, sec } of secs)
        link.classList.toggle(
          "active",
          sp >= sec.offsetTop && sp < sec.offsetTop + sec.offsetHeight
        );
    },
    PASSIVE
  );
}
