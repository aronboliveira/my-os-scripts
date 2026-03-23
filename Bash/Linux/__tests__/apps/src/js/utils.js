/** DOM query helpers and shared utilities. */

/** @param {string} s - CSS selector @returns {Element|null} */
export const qs = (s) => document.querySelector(s);

/** @param {string} s - CSS selector @returns {NodeListOf<Element>} */
export const qsa = (s) => document.querySelectorAll(s);

/**
 * Decode HTML entities from data attributes.
 * @param {string} str - HTML-encoded string
 * @returns {string} Decoded string
 */
export function decodeEntities(str) {
  const el = document.createElement("textarea");
  el.innerHTML = str;
  return el.value;
}
