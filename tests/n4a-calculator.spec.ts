import { expect, test } from "@playwright/test";
import { handleConsentPopup, waitFor } from "./util";

/**
 * Changes the input for a given form section by updating the value in the input with the given value multiplier, and checks if the given value locator changes. 
 * Sometimes it shouldn't, so use 'shouldValueChange' to denote if a change is expected or not.
 * 
 * @param page 
 * @param formSection 
 * @param value 
 * @param valueMultiplier 
 * @param shouldValueChange 
 */
async function updateInputs(page, formSection, value, valueMultiplier = 3, shouldValueChange = true) {
	const inputs = await (formSection.locator("input")).all(); 
	const oldNcuEstimate = await value.textContent();

	for(let i = 0; i < inputs.length; i++) {
		const input = inputs.at(i);
		const type = await input.getAttribute("type");
		if(input && type === "number") {
			const value = Number(await input.inputValue());
			const newValue = value + (value * valueMultiplier); // Increase by some significant value
			await input.fill(newValue.toString());
			await page.keyboard.press('Enter');
		}
		else if(type === "checkbox") {
			await input.check();
		}

		const newNcuEstimate = await value.textContent();
		if(shouldValueChange) {
			expect(newNcuEstimate).not.toBe(oldNcuEstimate);
		}
		else {
			expect(newNcuEstimate).toBe(oldNcuEstimate)
		}
	}
}

/**
 * Returns a random number between the given min and max, inclusive.
 * 
 * @param min 
 * @param max 
 * @returns 
 */
function getRandomNumber(min, max) {
	// Enforce to be integer
	min = Math.ceil(min);
  	max = Math.floor(max);
  	return Math.floor(Math.random() * (max - min + 1)) + min;
}

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
		const ncuEstimateValue = page.getByTestId("ncuEstimateValue");
		const totalValue = page.getByTestId("total-value");
		
		expect(await ncuEstimateValue.textContent()).toBeTruthy();
		expect(await totalValue.textContent()).toBeTruthy();
	});

	test("inputs from 'Estimate NCU Usage' section change NCU Needed (happy)", async ({ page }) => {
		const totalValue = page.getByTestId("total-value");
		const oldTotalValue = await totalValue.textContent();
		const ncuEstimateValue = page.getByTestId("ncuEstimateValue");
		const formSectionEstimateNCU = page.getByTestId("form-section-content-estimateNCUUsage");

		// Inputs from NCU box should adjust estimate 
		await updateInputs(page, formSectionEstimateNCU, ncuEstimateValue, 80);

		// Check that total value changes
		// Safe to say, if estimate NCU changes, so will the total monthly payment
		const newTotalValue = await totalValue.textContent();
		expect(newTotalValue).not.toBe(oldTotalValue);

	});

	test("inputs from 'Estimate NCU Usage' section change NCU Needed (unhappy 1)", async ({ page }) => {
		const totalValue = page.getByTestId("total-value");
		const oldTotalValue = await totalValue.textContent();
		const ncuEstimateValue = page.getByTestId("ncuEstimateValue");
		const formSectionEstimateNCU = page.getByTestId("form-section-content-estimateNCUUsage");

		// Inputs from NCU box should adjust estimate 
		await updateInputs(page, formSectionEstimateNCU, ncuEstimateValue, 0.1, false);

		// Check that total value doesn't changes
		const newTotalValue = await totalValue.textContent();
		expect(newTotalValue).toBe(oldTotalValue);
	});

	test("inputs from 'Estimate NCU Usage' section change NCU Needed (unhappy 2)", async ({ page }) => {
		const totalValue = page.getByTestId("total-value");
		const oldTotalValue = await totalValue.textContent();
		const ncuEstimateValue = page.getByTestId("ncuEstimateValue");
		const formSectionEstimateNCU = page.getByTestId("form-section-content-estimateNCUUsage");

		// Inputs from NCU box should adjust estimate 
		await updateInputs(page, formSectionEstimateNCU, ncuEstimateValue, -0.1, false);

		// Check that total value doesn't changes
		const newTotalValue = await totalValue.textContent();
		expect(newTotalValue).toBe(oldTotalValue);
	});

	test("inputs from 'Estimate Monthly Cost' section change Total Monthly Payment", async ({ page }) => {
		const totalValue = page.getByTestId("total-value");
		const formSectionMonthlyCost = page.getByTestId("form-section-content-estimateMonthlyCost");

		await updateInputs(page, formSectionMonthlyCost, totalValue);
	});

	test("'Listen Ports' input conditionally changes Total Monthly Payment", async({ page }) => {
		const listenPorts = page.getByTestId("input-numListenPorts");
		const totalValue = page.getByTestId("total-value");
		const oldTotalValue = await totalValue.textContent();
		const randomMaxValue = getRandomNumber(5, 10); // Smaller max for performance reasons.

		for(let i = 1; i <= randomMaxValue; i++) {
			await listenPorts.fill(i.toString());
			await page.keyboard.press('Enter');

			// First 5 are included
			const newTotalValue = await totalValue.textContent();
			if(i <= 5) {
				expect(newTotalValue).toBe(oldTotalValue);
			}
			else {
				expect(newTotalValue).not.toBe(oldTotalValue);
			}
		}
	});
});
