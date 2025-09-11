import { expect, test } from '@playwright/test';
// import { handleConsentPopup, waitFor } from './util';

// Unit test for the accuracy of the calculations

// UI test to click buttons to test functionality

// UI test to make sure the page renders correctly. IE. Calculator with #s on it, regions, etc are populated
test.describe('Smoke test for calculation page', () => {
    test.beforeEach(async ({ page }) => {
        await page.goto('/test-product');
        await page.waitForLoadState('load');
        // await waitFor(async () => await handleConsentPopup(page));
    });

    test('estimateNCUUSage renders', async ({page}) => {
        await expect(
            await page.getByTestId("form-section-content-estimateNCUUsage").count()
        ).toBeTruthy();
        await expect(
            await page.getByTestId("input-avgNewConnsPerSec").count()
        ).toBeTruthy();
        await expect(
            await page.getByTestId("input-avgConnDuration").count()
        ).toBeTruthy();
        await expect(
            await page.getByTestId("input-totalBandwidth").count()
        ).toBeTruthy();
        await expect(
            await page.getByTestId("form-section-content-capacityUnitsNeeded").count()
        ).toBeTruthy();
        await expect(
            await page.getByTestId("label-ncuEstimateValue").count()
        ).toBeTruthy();
        await expect(
            await page.getByTestId("button-ncu-usage-details").count()
        ).toBeTruthy();
        await expect(
            await page.getByTestId("label-ncuEstMin1").count()
        ).toBeTruthy();
        await expect(
            await page.getByTestId("form-section-content-estimateMonthlyCost").count()
        ).toBeTruthy();
        await expect(
            await page.getByTestId("dropdown-region").count()
        ).toBeTruthy();
        await expect(
            await page.getByTestId("input-numNcus").count()
        ).toBeTruthy();
        await expect(
            await page.getByTestId("input-numHours").count()
        ).toBeTruthy();
        await expect(
            await page.getByTestId("input-numListenPorts").count()
        ).toBeTruthy();
        await expect(
            await page.getByTestId("label-total-value").count()
        ).toBeTruthy();
        await expect(
            await page.getByTestId("button-total-cost-details").count()
        ).toBeTruthy();

    })
});

// Behavioural test 