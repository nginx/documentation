import { expect } from '@playwright/test';
import { TIMEOUT } from './constants.js';

// THE GDPR Consent button appears when test is run from EU locations. This handles that popup.
export async function handleConsentPopup(page) {
  await page.addLocatorHandler(
    page.locator('#truste-consent-content'),
    async () => {
      const consentButton = page.locator('#truste-consent-required');
      expect(consentButton).toBeVisible();
      await consentButton.click();
    }
  );
}

const sleep = (ms) => new Promise((r) => setTimeout(r, ms));
export const waitFor = async function waitFor(f, ftimeout = TIMEOUT) {
  while (!f()) await sleep(ftimeout);
  return f();
};
