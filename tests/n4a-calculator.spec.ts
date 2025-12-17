import { expect, test } from "@playwright/test";
import { handleConsentPopup, waitFor } from "./util";

test.describe("Testing for N4A calculator page", () => {
	test.beforeEach(async ({ page }) => {
		await page.goto("/nginxaas/azure/billing/usage-and-cost-estimator/");
		await page.waitForLoadState("load");
		await waitFor(async () => await handleConsentPopup(page));
	});

	test("calculator renders", async ({ page }) => {
		const header = page.getByTestId("calculator-section-heading");
		const content = page.getByTestId("calculator-section-content");

		await expect(header).toBeVisible();
		await expect(content).toBeVisible();
	});

	test("calculator values render", async ({ page }) => {
		// Conjunction - If outputs are rendered, it is safe to say the inputs are rendered.
		// NOT testing changing numbers will impact the total values as that should be the job of unit tests. This is just a smoke tests.
		const ncuEstimateValue = page.getByTestId("ncuEstimateValue");
		const totalValue = page.getByTestId("total-value");
		
		expect(await ncuEstimateValue.textContent()).toBeTruthy();
		expect(await totalValue.textContent()).toBeTruthy();
	});
});
