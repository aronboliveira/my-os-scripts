// @ts-check
import { test, expect } from "@playwright/test";

test.describe("Bash aliases-references", () => {
  test.beforeEach(async ({ page }) => {
    await page.goto("/bash.html");
    await page.waitForLoadState("domcontentloaded");
  });

  test("page loads with correct title", async ({ page }) => {
    await expect(page).toHaveTitle(/Bash Aliases Reference/);
  });

  test("has correct structural elements", async ({ page }) => {
    await expect(page.locator("#mainNav")).toBeVisible();
    await expect(page.locator("#aliasApp")).toBeVisible();
    await expect(page.locator("#tocSidebar")).toBeVisible();
    await expect(page.locator("#aliasSearch")).toBeVisible();
    await expect(page.locator("#themeBtn")).toBeVisible();
  });

  test("all sidebar links resolve to existing articles", async ({ page }) => {
    const links = page.locator("#tocSidebar .nav-link");
    const count = await links.count();
    expect(count).toBeGreaterThan(0);
    for (let i = 0; i < count; i++) {
      const href = await links.nth(i).getAttribute("href");
      expect(href).toBeTruthy();
      if (href) {
        const targetId = href.replace("#", "");
        await expect(page.locator(`#${targetId}`)).toBeAttached();
      }
    }
  });

  test("alias cards have data-alias attribute", async ({ page }) => {
    const cards = page.locator(".alias-card");
    const count = await cards.count();
    expect(count).toBeGreaterThan(0);
    for (let i = 0; i < count; i++) {
      const alias = await cards.nth(i).getAttribute("data-alias");
      expect(alias).toBeTruthy();
    }
  });

  test("cards are inside article sections", async ({ page }) => {
    const cards = page.locator("article .alias-card");
    const allCards = page.locator(".alias-card");
    expect(await cards.count()).toBe(await allCards.count());
  });

  test("accordion cards are inside accordion-body", async ({ page }) => {
    const accordionCards = page.locator(".accordion .alias-card");
    const accordionBodyCards = page.locator(".accordion-body .alias-card");
    const total = await accordionCards.count();
    const insideBody = await accordionBodyCards.count();
    expect(insideBody).toBe(total);
  });

  test("search filters cards", async ({ page }) => {
    const search = page.locator("#aliasSearch");
    await search.fill("setup-software-gl");
    // Wait for filter to apply
    await page.waitForTimeout(100);
    const visibleCards = page.locator('.alias-card:not([style*="display: none"])');
    const hiddenCards = page.locator('.alias-card[style*="display: none"]');
    expect(await visibleCards.count()).toBeGreaterThan(0);
    expect(await hiddenCards.count()).toBeGreaterThan(0);
  });

  test("search clears correctly", async ({ page }) => {
    const search = page.locator("#aliasSearch");
    const allCards = page.locator(".alias-card");
    const totalCards = await allCards.count();

    await search.fill("setup-software-gl");
    await page.waitForTimeout(100);
    await search.fill("");
    await page.waitForTimeout(100);

    const visibleCards = page.locator('.alias-card:not([style*="display: none"])');
    expect(await visibleCards.count()).toBe(totalCards);
  });

  test("theme toggle switches between dark and light", async ({ page }) => {
    const html = page.locator("html");
    const initialTheme = await html.getAttribute("data-bs-theme");
    await page.locator("#themeBtn").click();
    const newTheme = await html.getAttribute("data-bs-theme");
    expect(newTheme).not.toBe(initialTheme);
    // Toggle back
    await page.locator("#themeBtn").click();
    const revertedTheme = await html.getAttribute("data-bs-theme");
    expect(revertedTheme).toBe(initialTheme);
  });

  test("example details can be expanded", async ({ page }) => {
    const details = page.locator(".example-details").first();
    await details.locator("summary").click();
    await expect(details).toHaveAttribute("open", "");
    await expect(details.locator(".example-block")).toBeVisible();
  });

  test("demo button starts and stops typing animation", async ({ page }) => {
    // First open the example details
    const details = page.locator(".example-details").first();
    await details.locator("summary").click();
    await expect(details.locator(".example-block")).toBeVisible();

    const btn = details.locator(".demo-btn").first();
    // Click to start
    await btn.click();
    await expect(btn).toHaveClass(/playing/);
    await expect(btn.locator("span")).toHaveText("Stop demo");

    // Wait for some typing to happen
    await page.waitForTimeout(200);
    const typed = details.locator(".typed-cmd").first();
    const text = await typed.textContent();
    expect(text?.length).toBeGreaterThan(0);

    // Click to stop
    await btn.click();
    await expect(btn).not.toHaveClass(/playing/);
    await expect(btn.locator("span")).toHaveText("Start demo");
  });

  test("cursor blinks during typing", async ({ page }) => {
    const details = page.locator(".example-details").first();
    await details.locator("summary").click();
    const btn = details.locator(".demo-btn").first();
    await btn.click();

    const cursor = details.locator(".typing-cursor").first();
    // Cursor should be visible (display: inline-block)
    await expect(cursor).toHaveCSS("display", "inline-block");

    // Stop the demo
    await btn.click();
    await expect(cursor).toHaveCSS("display", "none");
  });

  test("code-details can be toggled", async ({ page }) => {
    const codeDetails = page.locator("details.code-details").first();
    await codeDetails.locator("summary").click();
    await expect(codeDetails).toHaveAttribute("open", "");
    await expect(codeDetails.locator(".code-block")).toBeVisible();
  });

  test("back-to-top button appears on scroll", async ({ page }) => {
    const btn = page.locator("#backToTop");
    // Initially hidden
    await expect(btn).toHaveCSS("opacity", "0");
    // Scroll down
    await page.evaluate(() => window.scrollTo(0, 500));
    await page.waitForTimeout(100);
    await expect(btn).toHaveCSS("opacity", "1");
  });

  test("no JavaScript errors on page load", async ({ page }) => {
    /** @type {string[]} */
    const errors = [];
    page.on("pageerror", (err) => errors.push(err.message));
    await page.goto("/bash.html");
    await page.waitForLoadState("load");
    await page.waitForTimeout(500);
    expect(errors).toEqual([]);
  });

  test("preconnect and dns-prefetch links exist", async ({ page }) => {
    const preconnect = page.locator('link[rel="preconnect"]');
    const dnsPrefetch = page.locator('link[rel="dns-prefetch"]');
    expect(await preconnect.count()).toBeGreaterThanOrEqual(2);
    expect(await dnsPrefetch.count()).toBeGreaterThanOrEqual(2);
  });

  test("example blocks have required data attributes", async ({ page }) => {
    const blocks = page.locator(".example-block[data-example-id]");
    const count = await blocks.count();
    expect(count).toBeGreaterThan(0);
    for (let i = 0; i < count; i++) {
      const block = blocks.nth(i);
      await expect(block).toHaveAttribute("data-cmd");
      await expect(block).toHaveAttribute("data-output");
    }
  });

  test("each example block has typed-cmd, cursor, and output elements", async ({
    page,
  }) => {
    const blocks = page.locator(".example-block[data-example-id]");
    const count = await blocks.count();
    for (let i = 0; i < count; i++) {
      const id = await blocks.nth(i).getAttribute("data-example-id");
      await expect(page.locator(`#typed_${id}`)).toBeAttached();
      await expect(page.locator(`#cursor_${id}`)).toBeAttached();
      await expect(page.locator(`#output_${id}`)).toBeAttached();
    }
  });

  test("prompt shows $ for bash", async ({ page }) => {
    const prompts = page.locator(".example-block .prompt");
    const count = await prompts.count();
    expect(count).toBeGreaterThan(0);
    for (let i = 0; i < count; i++) {
      const text = await prompts.nth(i).textContent();
      expect(text?.trim()).toBe("$");
    }
  });
});
