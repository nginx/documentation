import { defineConfig, devices } from '@playwright/test';

const BASE_URL = 'http://127.0.0.1';
const PORT = 1313;
const BASE_HUGO_CMD_PATH = '/github/home/actions_hugo/bin/hugo'; // Added so it runs the github actions version of hugo and not the playwright version.

export default defineConfig({
    testDir: './src',
    fullyParallel: true,
    workers: 1,
    outputDir: './test-results',
    reporter: [['html', { open: 'never', outputFolder: './playwright-report' }]],
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
        baseURL: `${BASE_URL}:${PORT}`,
        trace: 'on-first-retry',
        // Set Geolocation to Cork, Ireland
        geolocation: { longitude: -8.486316, latitude: 51.896893 },
        permissions: ['geolocation'],
        video: 'retain-on-failure'
      },
    webServer: {
        command: `cd ../ && ${BASE_HUGO_CMD_PATH} mod get && ${BASE_HUGO_CMD_PATH} serve --port ${PORT}`,
        url: `${BASE_URL}:${PORT}`,
        stdout: 'ignore', // Switch to 'pipe' for debugging
  },
})