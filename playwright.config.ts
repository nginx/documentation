import { defineConfig, devices } from '@playwright/test';
export default defineConfig({
    testDir: 'tests',
    fullyParallel: true,
    workers: 1,
    outputDir: 'tests/test-results',
    reporter: [['html', {  outputFolder: 'tests/playwright-report' }]],
    projects: [
        {
            name: 'chromium',
            use: { ...devices['Desktop Chrome'] },
        },
        {
            name: 'firefox',
            use: { ...devices['Desktop Firefox'] },
        },
        {
            name: 'webkit',
            use: { ...devices['Desktop Safari'] },
        },
        {
            name: 'Mobile Chrome',
            use: { ...devices['Pixel 5'] },
        },
    ],
    use: {
        // Base URL to use in actions like `await page.goto('/')`.
        baseURL: 'https://docs.nginx.com',
        // Set Geolocation to Cork, Ireland
        geolocation: { longitude: -8.486316, latitude: 51.896893 },
        permissions: ['geolocation'],
        video: 'retain-on-failure'
      },
})