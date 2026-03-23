/** Scroll handling + back-to-top button. */
import { S, SCROLL_THRESHOLD, PASSIVE } from "./constants.js";
import { qs } from "./utils.js";

export function initScroll() {
  const backToTop = qs(S.backToTop);
  if (backToTop && !backToTop.dataset.bound) {
    backToTop.dataset.bound = "1";
    backToTop.addEventListener("click", () =>
      window.scrollTo({ top: 0, behavior: "smooth" })
    );
  }
  if (!document.body.dataset.boundScroll) {
    document.body.dataset.boundScroll = "1";
    const nav = qs(S.mainNav);
    window.addEventListener(
      "scroll",
      () => {
        const y = window.scrollY > SCROLL_THRESHOLD;
        if (nav) nav.classList.toggle("scrolled", y);
        if (backToTop) backToTop.classList.toggle("visible", y);
      },
      PASSIVE
    );
  }
}
