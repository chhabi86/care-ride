import { test } from '@playwright/test';

test('inspect contact submit button', async ({ page }) => {
  await page.goto('http://127.0.0.1:4201/contact', { waitUntil: 'networkidle' });
  // ensure app has time to bootstrap
  await page.waitForTimeout(500);

  const button = await page.locator('button[type="submit"]');
  const exists = await button.count();
  console.log('button present count=', exists);
  if (exists) {
    const attr = await button.getAttribute('disabled');
    const prop = await page.evaluate(el => (el as HTMLButtonElement).disabled, await button.elementHandle());
    const style = await page.evaluate(el => getComputedStyle(el).pointerEvents, await button.elementHandle());
    const rect = await page.evaluate(el => {
      const r = el.getBoundingClientRect();
      return { x: r.x, y: r.y, w: r.width, h: r.height };
    }, await button.elementHandle());
    console.log('disabled attribute:', attr);
    console.log('disabled property:', prop);
    console.log('pointer-events style:', style);
    console.log('bounding rect:', rect);
    // element at center point
    const centerX = Math.round(rect.x + rect.w/2);
    const centerY = Math.round(rect.y + rect.h/2);
    const elAtPoint = await page.evaluate(({x,y}) => {
      const el = document.elementFromPoint(x,y);
      if (!el) return null;
      return { tag: el.tagName, id: el.id, class: el.className };
    }, { x: centerX, y: centerY });
    console.log('element at button center:', elAtPoint);
  }
});
