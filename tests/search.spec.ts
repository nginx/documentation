import { test, expect} from '@playwright/test';
import { handleConsentPopup, waitFor } from '../tests/utils/commonUtils.ts'
  
test.describe("Testing search page", () => {
    test('Searchbar is visible', async ({ page }) => {
        await page.goto('/'); 
        await waitFor(() => handleConsentPopup(page));

        const searchBox = page.locator('.CoveoSearchbox').first();
        const searchButton = page.locator('.CoveoSearchButton');
        const searchValue = "proxy";
        expect(searchBox).toBeVisible();

        await searchBox.click();
        await page.keyboard.insertText(searchValue);
        await searchButton.click();
        await page.waitForURL(`/search.html#q=${searchValue}&sort=relevancy`);
        expect(await page.locator('div h1').innerHTML()).toBe('Search Results');
    });

    test('Search page returns results without error', async ({ page }) => {
        await page.goto("/search.html#q=proxy&sort=relevancy"); 
        await waitFor(() => handleConsentPopup(page));
        
        await page.waitForSelector('div.coveo-result-list-container');
        const coveoErrorReport = page.locator('div.CoveoErrorReport');
        const errorReportDisplay = await coveoErrorReport.evaluate(e => window.getComputedStyle(e).display);
        expect(errorReportDisplay).toBe('none');
    });
})