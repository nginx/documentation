import { expect, test } from "@playwright/test";
import { handleConsentPopup, waitFor } from "./util";

// Unit test for the accuracy of the calculations
// test.describe('Numerical test for N4A calculator page', () => {
//     test.beforeEach(async ({ page }) => {
//         await page.goto('/nginxaas/azure/billing/usage-and-cost-estimator/');
//         await page.waitForLoadState('load');
//         await waitFor(async () => await handleConsentPopup(page));
//     });

//     test('estimageNCUUsage calculations are accurate', async ({page}) => {
//         // change input-avgNewConnsPerSec to 1000 (label-ncuEstimateValue should be 30 NCUs)

//         // change input-avgConnDuration 100 (label-ncuEstimateValue should be 30 NCUs)

//         // change input-totalBandwidth to 1000 (label-ncuEstimateValue should be 20 NCUs)

//     });
// });

// UI test to click buttons to test functionality
test.describe("Button and input functionality test for N4A calculator page", () => {
	test.beforeEach(async ({ page }) => {
		await page.goto("/nginxaas/azure/billing/usage-and-cost-estimator/");
		await page.waitForLoadState("load");
		await waitFor(async () => await handleConsentPopup(page));
	});

	test("estimateNCUUsage buttons and input are functional", async ({
		page,
	}) => {
		await page.getByTestId("button-ncu-usage-details").click();
		await page.getByTestId("button-total-cost-details").click();
	});
	// go through each input and change it to 10000. label-total-value != $219
	test("input-avgNewConnsPerSec", async ({ page }) => {
		const input = page.getByTestId("input-avgNewConnsPerSec");
		const label = page.getByTestId("label-total-value");

		const before = await label.textContent();

		await input.fill("1000");
		await input.blur();

		await expect(input).toHaveValue("1000");
		await expect(label).not.toHaveText(before || "");
		console.log('before:', before, 'after:', await label.textContent());
	});

	test("input-avgConnDuration", async ({ page }) => {
		const input = page.getByTestId("input-avgConnDuration");
		const label = page.getByTestId("label-total-value");

		const before = await label.textContent();

		await input.fill("1000");
		await input.blur();

		await expect(input).toHaveValue("1000");
		await expect(label).not.toHaveText(before || "");
	});

	test("input-totalBandwidth", async ({ page }) => {
		const input = page.getByTestId("input-totalBandwidth");
		const label = page.getByTestId("label-total-value");

		const before = await label.textContent();

		await input.fill("1000");
		await input.blur();

		await expect(input).toHaveValue("1000");
		await expect(label).not.toHaveText(before || "");
	});

	test("input-numNcus", async ({ page }) => {
		const input = page.getByTestId("input-numNcus");
		const label = page.getByTestId("label-total-value");

		const before = await label.textContent();

		await input.fill("1000");
		await input.blur();

		await expect(input).toHaveValue("1000");
		await expect(label).not.toHaveText(before || "");
	});

	test("input-numHours", async ({ page }) => {
		const input = page.getByTestId("input-numHours");
		const label = page.getByTestId("label-total-value");

		const before = await label.textContent();

		await input.fill("1000");
		await input.blur();

		await expect(input).toHaveValue("1000");
		await expect(label).not.toHaveText(before || "");
	});

	test("input-numListenPorts", async ({ page }) => {
		const input = page.getByTestId("input-numListenPorts");
		const label = page.getByTestId("label-total-value");

		const before = await label.textContent();

		await input.fill("1000");
		await input.blur();

		await expect(input).toHaveValue("1000");
		await expect(label).not.toHaveText(before || "");
	});
});

// // UI test to make sure the page renders correctly. IE. Calculator with #s on it, regions, etc are populated
// test.describe('Smoke test for calculation page', () => {
//     test.beforeEach(async ({ page }) => {
//         await page.goto('/nginxaas/azure/billing/usage-and-cost-estimator/');
//         await page.waitForLoadState('load');
//         await waitFor(async () => await handleConsentPopup(page));
//         // await waitFor(async () => await handleConsentPopup(page));
//     });

//     test('estimateNCUUSage renders', async ({page}) => {
//         await expect(
//             await page.getByTestId("form-section-content-estimateNCUUsage").count()
//         ).toBeTruthy();
//         await expect(
//             await page.getByTestId("input-avgNewConnsPerSec").count()
//         ).toBeTruthy();
//         await expect(
//             await page.getByTestId("input-avgConnDuration").count()
//         ).toBeTruthy();
//         await expect(
//             await page.getByTestId("input-totalBandwidth").count()
//         ).toBeTruthy();
//         await expect(
//             await page.getByTestId("form-section-content-capacityUnitsNeeded").count()
//         ).toBeTruthy();
//         await expect(
//             await page.getByTestId("label-ncuEstimateValue").count()
//         ).toBeTruthy();
//         await expect(
//             await page.getByTestId("button-ncu-usage-details").count()
//         ).toBeTruthy();
//         await expect(
//             await page.getByTestId("label-ncuEstMin1").count()
//         ).toBeTruthy();
//         await expect(
//             await page.getByTestId("form-section-content-estimateMonthlyCost").count()
//         ).toBeTruthy();
//         await expect(
//             await page.getByTestId("dropdown-region").count()
//         ).toBeTruthy();
//         await expect(
//             await page.getByTestId("input-numNcus").count()
//         ).toBeTruthy();
//         await expect(
//             await page.getByTestId("input-numHours").count()
//         ).toBeTruthy();
//         await expect(
//             await page.getByTestId("input-numListenPorts").count()
//         ).toBeTruthy();
//         await expect(
//             await page.getByTestId("label-total-value").count()
//         ).toBeTruthy();
//         await expect(
//             await page.getByTestId("button-total-cost-details").count()
//         ).toBeTruthy();

//     })
// });

// Behavioural test
