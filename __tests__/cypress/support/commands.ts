/**
 * Custom Cypress commands for testing the OS Aliases Reference pages.
 */

Cypress.Commands.add("getByTestId", (testId: string) => {
  return cy.get(`[data-testid="${testId}"]`);
});

export {};
