import { describe, it, expect, beforeEach } from "vitest";
import { buildTestDOM, resetBindings } from "./setup.js";
import { initSearch } from "../src/js/search.js";

describe("search", () => {
  beforeEach(() => {
    buildTestDOM();
    resetBindings();
    initSearch();
  });

  it("binds to #aliasSearch input", () => {
    const input = document.getElementById("aliasSearch");
    expect(input.dataset.bound).toBe("1");
  });

  it("does not double-bind", () => {
    initSearch(); // second call
    const input = document.getElementById("aliasSearch");
    expect(input.dataset.bound).toBe("1");
  });

  it("filters cards by alias name", () => {
    const input = document.getElementById("aliasSearch");
    input.value = "test-alias-a";
    input.dispatchEvent(new Event("input"));

    const cards = document.querySelectorAll(".alias-card");
    expect(cards[0].style.display).toBe(""); // test-alias-a — exact match
    expect(cards[1].style.display).toBe("none"); // test-alias-b — no match
    expect(cards[2].style.display).toBe("none"); // another-alias — no match
  });

  it("shows all cards when search is cleared", () => {
    const input = document.getElementById("aliasSearch");
    input.value = "test-alias-a";
    input.dispatchEvent(new Event("input"));
    input.value = "";
    input.dispatchEvent(new Event("input"));

    const cards = document.querySelectorAll(".alias-card");
    for (const card of cards) {
      expect(card.style.display).toBe("");
    }
  });

  it("case-insensitive match", () => {
    const input = document.getElementById("aliasSearch");
    input.value = "TEST-ALIAS";
    input.dispatchEvent(new Event("input"));

    const cards = document.querySelectorAll(".alias-card");
    // test-alias-a and test-alias-b match
    expect(cards[0].style.display).toBe("");
    expect(cards[1].style.display).toBe("");
  });

  it("matches on card text content", () => {
    const input = document.getElementById("aliasSearch");
    input.value = "section B";
    input.dispatchEvent(new Event("input"));

    const cards = document.querySelectorAll(".alias-card");
    // "another-alias" card body contains "Another alias for section B."
    expect(cards[2].style.display).toBe("");
  });

  it("does not throw when #aliasSearch is missing", () => {
    document.getElementById("aliasSearch")?.remove();
    resetBindings();
    expect(() => initSearch()).not.toThrow();
  });
});
