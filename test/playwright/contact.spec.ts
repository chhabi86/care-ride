import { test, expect } from '@playwright/test';

test('contact form submit', async ({ page }) => {
  // collect console logs for debugging
  const logs: string[] = [];
  page.on('console', msg => logs.push(`${msg.type()}: ${msg.text()}`));

  await page.goto('http://127.0.0.1:4201/contact', { waitUntil: 'networkidle' });
  await page.fill('input[name="name"]', 'Playwright Test');
  await page.fill('input[name="phone"]', '555-9999');
  await page.fill('input[name="email"]', 'pwtest@example.com');
  await page.fill('input[name="reason"]', 'Inquiry');
  await page.fill('textarea[name="message"]', 'This is an automated test.');

  // wait for the network request that submits the contact form
  const [response] = await Promise.all([
    page.waitForResponse(resp => resp.url().includes('/api/contact'), { timeout: 5000 }),
    page.click('button[type="submit"]')
  ]);

  // capture debug artifacts
  await page.screenshot({ path: 'test/playwright/contact-after-submit.png', fullPage: true });
  const html = await page.content();
  const fs = require('fs');
  fs.writeFileSync('test/playwright/contact-after-submit.html', html);
  // log network response details
  const status = response.status();
  let body = '';
  try { body = await response.text(); } catch (e) { body = '<unreadable>'; }
  fs.writeFileSync('test/playwright/contact-console.log', logs.join('\n') + `\nRESPONSE STATUS: ${status}\nRESPONSE BODY:\n${body}`);

  // wait for visible banner by id and assert its text
  const success = page.locator('#contact-success');
  await expect(success).toBeVisible({ timeout: 7000 });
  const txt = (await success.textContent()) || '';
  if (!txt.includes("Request submitted.")) throw new Error('Unexpected success text: ' + txt);
});
