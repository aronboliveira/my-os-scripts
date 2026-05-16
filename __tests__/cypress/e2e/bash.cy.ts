/**
 * Cypress E2E tests for Bash Aliases Reference page.
 */

describe("Bash Aliases Reference Page", () => {
  beforeEach(() => {
    cy.visit("/bash");
  });

  it("renders the page title", () => {
    cy.title().should("include", "Bash");
  });

  it("has a functional theme toggle", () => {
    cy.get("#themeBtn").should("exist").click();
    cy.get("html").should("have.attr", "data-bs-theme", "dark");
    cy.get("#themeBtn").click();
    cy.get("html").should("have.attr", "data-bs-theme", "light");
  });

  it("has a search input that filters aliases", () => {
    cy.get("#aliasSearch").should("exist").type("git");
    cy.get(".alias-card").should("have.length.gt", 0);
  });

  it("has a Vue app mounted without console errors", () => {
    cy.window().then((win) => {
      cy.spy(win.console, "error").as("consoleError");
    });
    cy.reload();
    cy.get("@consoleError").should("not.be.called");
  });

  it("renders TOC sidebar", () => {
    cy.get("#tocSidebar").should("exist");
    cy.get("#tocSidebar .nav-link").should("have.length.gt", 0);
  });
});

describe("PowerShell Aliases Reference Page", () => {
  beforeEach(() => {
    cy.visit("/powershell");
  });

  it("renders the page title", () => {
    cy.title().should("include", "PowerShell");
  });

  it("has a functional theme toggle", () => {
    cy.get("#themeBtn").should("exist").click();
    cy.get("html").should("have.attr", "data-bs-theme", "dark");
  });

  it("has a Vue app mounted without console errors", () => {
    cy.window().then((win) => {
      cy.spy(win.console, "error").as("consoleError");
    });
    cy.reload();
    cy.get("@consoleError").should("not.be.called");
  });

  it("renders TOC sidebar", () => {
    cy.get("#tocSidebar").should("exist");
  });
});
