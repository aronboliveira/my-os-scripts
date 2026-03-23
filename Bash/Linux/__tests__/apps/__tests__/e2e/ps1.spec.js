// @ts-check
import { test, expect } from "@playwright/test";

test.describe("PS1 aliases-references", () => {
  test.beforeEach(async ({ page }) => {
    await page.goto("/ps1.html");
    await page.waitForLoadState("domcontentloaded");
  });

  test("page loads with correct title", async ({ page }) => {
    await expect(page).toHaveTitle(/PowerShell Aliases Reference/);
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

  test("search filters cards", async ({ page }) => {
    const search = page.locator("#aliasSearch");
    await search.fill("show-hosttype");
    await page.waitForTimeout(100);
    const visibleCards = page.locator('.alias-card:not([style*="display: none"])');
    expect(await visibleCards.count()).toBeGreaterThan(0);
  });

  test("theme toggle works", async ({ page }) => {
    const html = page.locator("html");
    const initial = await html.getAttribute("data-bs-theme");
    await page.locator("#themeBtn").click();
    const toggled = await html.getAttribute("data-bs-theme");
    expect(toggled).not.toBe(initial);
  });

  test("demo button starts and stops animation", async ({ page }) => {
    const details = page.locator(".example-details").first();
    await details.locator("summary").click();
    const btn = details.locator(".demo-btn").first();

    await btn.click();
    await expect(btn).toHaveClass(/playing/);

    await page.waitForTimeout(200);
    const typed = details.locator(".typed-cmd").first();
    const text = await typed.textContent();
    expect(text?.length).toBeGreaterThan(0);

    await btn.click();
    await expect(btn).not.toHaveClass(/playing/);
  });

  test("prompt shows PS> for PowerShell", async ({ page }) => {
    const prompts = page.locator(".example-block .prompt");
    const count = await prompts.count();
    expect(count).toBeGreaterThan(0);
    for (let i = 0; i < count; i++) {
      const text = await prompts.nth(i).textContent();
      expect(text?.trim()).toBe("PS>");
    }
  });

  test("no JavaScript errors on page load", async ({ page }) => {
    /** @type {string[]} */
    const errors = [];
    page.on("pageerror", (err) => errors.push(err.message));
    await page.goto("/ps1.html");
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

  test("example blocks have required elements", async ({ page }) => {
    const blocks = page.locator(".example-block[data-example-id]");
    const count = await blocks.count();
    for (let i = 0; i < count; i++) {
      const id = await blocks.nth(i).getAttribute("data-example-id");
      await expect(page.locator(`#typed_${id}`)).toBeAttached();
      await expect(page.locator(`#cursor_${id}`)).toBeAttached();
      await expect(page.locator(`#output_${id}`)).toBeAttached();
    }
  });

  test("PS-specific syntax classes exist in code blocks", async ({ page }) => {
    const psKeywords = page.locator(".ps-keyword");
    expect(await psKeywords.count()).toBeGreaterThan(0);
  });

  test("back-to-top appears on scroll", async ({ page }) => {
    const btn = page.locator("#backToTop");
    await expect(btn).toHaveCSS("opacity", "0");
    await page.evaluate(() => window.scrollTo(0, 500));
    await page.waitForTimeout(100);
    await expect(btn).toHaveCSS("opacity", "1");
  });
});
