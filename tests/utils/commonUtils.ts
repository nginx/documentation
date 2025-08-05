import { expect, type Page } from '@playwright/test';
import { TIMEOUT } from '../../tests/constants.ts';

// THE GDPR Consent button appears when test is run from EU locations. This handles that popup.
export async function handleConsentPopup(page: Page) {
    const consentContent = page.locator('#truste-consent-content');
    const isConsentContentVisibile = await consentContent.isVisible();
    if(isConsentContentVisibile) {
        const consentButton = page.locator('#truste-consent-required').first();
        console.log((await consentButton.all()).length);
        expect(consentButton).toBeVisible();
        await consentButton.click();
    }
}

let sleep = ms => new Promise(r => setTimeout(r, ms));
export let waitFor = async function waitFor(f, ftimeout=TIMEOUT){
    while(!f()) await sleep(ftimeout);
    return f();
};