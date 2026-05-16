/**
 * Cypress E2E tests for the Combined index.html page.
 * Tests that the combined page loads without errors.
 */

describe("Combined OS Aliases Reference Page", () => {
  beforeEach(() => {
    cy.visit("/combined");
  });

  it("renders both Bash and PowerShell sections", () => {
    cy.contains("Bash").should("exist");
    cy.contains("PowerShell").should("exist");
  });

  it("has no Vue initialization errors", () => {
    cy.window().then((win) => {
      cy.spy(win.console, "error").as("consoleError");
    });
    cy.reload();
    cy.get("@consoleError").should("not.be.calledWithMatch", /Vue init error/);
  });

  it("has no duplicate IDs in the DOM", () => {
    cy.window().then((win) => {
      const allIds = Array.from(
        win.document.querySelectorAll("[id]"),
        (el) => el.id,
      );
      const unique = new Set(allIds);
      expect(unique.size).to.equal(allIds.length);
    });
  });
});
