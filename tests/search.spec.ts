import { test, expect, type Page } from '@playwright/test';

async function handleConsentPopup(page: Page) {
    const consentContent = page.locator('#truste-consent-content');
    const isConsentContentVisibile = await consentContent.isVisible();
    if(isConsentContentVisibile) {
        const consentButton = page.locator('#truste-consent-required');
        expect(consentButton).toBeVisible();
        await consentButton.click();
    }
}

let sleep = ms => new Promise(r => setTimeout(r, ms));
let waitFor = async function waitFor(f){
    while(!f()) await sleep(4000);
    return f();
};

test.describe("Testing search page", () => {
    test('Searchbar is visible', async ({ page }) => {
        await page.goto("https://docs.nginx.com"); 
        await waitFor(() => handleConsentPopup(page));

        const searchBox = page.locator('#searchbox');
        const searchValue = "proxy";
        expect(searchBox).toBeVisible();

        await searchBox.click();
        await page.keyboard.insertText(searchValue);
        await page.keyboard.press('Enter');

        await page.waitForURL(`https://docs.nginx.com/search.html#q=${searchValue}&sort=relevancy`);
        expect(await page.locator('div h1').innerHTML()).toBe('Search Results');
    });

    test('Search page returns results without error', async ({ page }) => {
        await page.goto("https://docs.nginx.com/search.html#q=proxy&sort=relevancy"); 
        await waitFor(() => handleConsentPopup(page));
        
        await page.waitForSelector('div.coveo-result-list-container');
        const coveoErrorReport = page.locator('div.CoveoErrorReport');
        const errorReportDisplay = await coveoErrorReport.evaluate(e => window.getComputedStyle(e).display);
        expect(errorReportDisplay).toBe('none');
    });
})