import { describe, it, expect, beforeEach } from "@jest/globals";
import { buildBashDOM, resetBashBindings } from "../../src/fixtures/bash-dom";
import BashApp from "../../src/iife/bash-app";

describe("Bash — Search", () => {
  beforeEach(() => {
    buildBashDOM();
    resetBashBindings();
  });

  it("binds to #aliasSearch input", () => {
    BashApp.initSearch();
    const input = document.getElementById("aliasSearch");
    expect(input?.dataset.bound).toBe("1");
  });

  it("does not double-bind", () => {
    BashApp.initSearch();
    BashApp.initSearch();
    const input = document.getElementById("aliasSearch");
    expect(input?.dataset.bound).toBe("1");
  });

  it("filters cards by alias name", () => {
    BashApp.initSearch();
    const input = document.getElementById("aliasSearch") as HTMLInputElement;
    input.value = "show-user";
    input.dispatchEvent(new Event("input", { bubbles: true }));

    const cards = document.querySelectorAll(".alias-card");
    expect((cards[0] as HTMLElement).style.display).toBe("");
    expect((cards[1] as HTMLElement).style.display).toBe("none");
  });

  it("case-insensitive match", () => {
    BashApp.initSearch();
    const input = document.getElementById("aliasSearch") as HTMLInputElement;
    input.value = "SHOW-USER";
    input.dispatchEvent(new Event("input", { bubbles: true }));

    const cards = document.querySelectorAll(".alias-card");
    expect((cards[0] as HTMLElement).style.display).toBe("");
  });

  it("shows all cards when search cleared", () => {
    BashApp.initSearch();
    const input = document.getElementById("aliasSearch") as HTMLInputElement;
    input.value = "show-user";
    input.dispatchEvent(new Event("input", { bubbles: true }));
    input.value = "";
    input.dispatchEvent(new Event("input", { bubbles: true }));

    for (const card of document.querySelectorAll(".alias-card")) {
      expect((card as HTMLElement).style.display).toBe("");
    }
  });

  it("matches on card text content", () => {
    BashApp.initSearch();
    const input = document.getElementById("aliasSearch") as HTMLInputElement;
    input.value = "home path";
    input.dispatchEvent(new Event("input", { bubbles: true }));

    const cards = document.querySelectorAll(".alias-card");
    // show-home card contains "Display home path."
    expect((cards[1] as HTMLElement).style.display).toBe("");
  });

  it("does not throw when #aliasSearch is missing", () => {
    document.getElementById("aliasSearch")?.remove();
    expect(() => BashApp.initSearch()).not.toThrow();
  });
});
