/** Search — real-time alias card filtering. */
import { S } from "./constants.js";
import { qs, qsa } from "./utils.js";

export function initSearch() {
  const input = qs(S.aliasSearch);
  if (!input || input.dataset.bound) return;
  input.dataset.bound = "1";
  input.addEventListener("input", (e) => {
    const q = (e.target.value || "").toLowerCase().trim();
    for (const card of qsa(S.aliasCard)) {
      card.style.display =
        !q ||
        (card.dataset.alias || "").includes(q) ||
        card.textContent.toLowerCase().includes(q)
          ? ""
          : "none";
    }
  });
}
