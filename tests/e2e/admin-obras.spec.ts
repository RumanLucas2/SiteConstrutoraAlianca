import { test, expect, request, APIRequestContext } from '@playwright/test';

const ADMIN_USER = process.env.ADMIN_USER || 'admin';
const ADMIN_PASS = process.env.ADMIN_PASS || 'admin';
const BASE_URL = process.env.BASE_URL || 'http://localhost:8081';

async function loginAndGetStorageState(api: APIRequestContext) {
  const res = await api.post(`${BASE_URL}/auth.php`, {
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    form: { user: ADMIN_USER, pass: ADMIN_PASS },
  });
  expect(res.ok()).toBeTruthy();

  const cookiesHeader = res.headers()['set-cookie'];
  expect(cookiesHeader).toBeTruthy();

  const cookieStrings = Array.isArray(cookiesHeader) ? cookiesHeader : [cookiesHeader];
  const cookies = cookieStrings
    .map((c) => c.split(';')[0])
    .filter(Boolean)
    .map((c) => {
      const [name, ...rest] = c.split('=');
      return { name, value: rest.join('='), url: BASE_URL };
    });

  return { cookies };
}

test.describe('Admin Obras', () => {
  let storageState: any;

  test.beforeAll(async ({ playwright }) => {
    const api = await request.newContext();
    storageState = await loginAndGetStorageState(api);
    await api.dispose();
  });

  test('carrega lista de obras', async ({ browser }) => {
    const context = await browser.newContext({ storageState });
    const page = await context.newPage();
    await page.goto('/Pages/Auxiliares/admin-config.html');
    await page.getByRole('button', { name: /Carregar lista/i }).click();
    await expect(page.locator('#worksStatus')).toContainText(/Lista carregada/i, { timeout: 10000 });
    await context.close();
  });

  test('reordena dentro da mesma categoria', async ({ browser }) => {
    const context = await browser.newContext({ storageState });
    const page = await context.newPage();
    await page.goto('/Pages/Auxiliares/admin-config.html');
    await page.getByRole('button', { name: /Carregar lista/i }).click();
    const firstList = page.locator('.works-list').first();
    const items = firstList.locator('li[data-slug]');
    const count = await items.count();
    test.skip(count < 2, 'Categoria precisa ter pelo menos 2 itens para reordenar');

    const firstSlug = await items.nth(0).getAttribute('data-slug');
    const second = items.nth(1);
    await items.nth(0).dragTo(second, { force: true });
    await expect(page.locator('#worksStatus')).toContainText(/Salvo/i, { timeout: 8000 });

    // Confirm reorder reflected in DOM
    const newFirstSlug = await firstList.locator('li[data-slug]').first().getAttribute('data-slug');
    expect(newFirstSlug).not.toEqual(firstSlug);
    await context.close();
  });

  test('move obra entre categorias', async ({ browser }) => {
    const context = await browser.newContext({ storageState });
    const page = await context.newPage();
    await page.goto('/Pages/Auxiliares/admin-config.html');
    await page.getByRole('button', { name: /Carregar lista/i }).click();

    const lists = page.locator('.works-list');
    const listCount = await lists.count();
    test.skip(listCount < 2, 'Precisa de pelo menos duas categorias com listas');

    const source = lists.nth(0);
    const target = lists.nth(1);
    const sourceItems = source.locator('li[data-slug]');
    const hasItem = (await sourceItems.count()) > 0;
    test.skip(!hasItem, 'Lista de origem sem itens');

    const item = sourceItems.first();
    const slug = await item.getAttribute('data-slug');

    // Drag onto target list area (empty or not)
    await item.dragTo(target, { force: true });
    await expect(page.locator('#worksStatus')).toContainText(/Salvo/i, { timeout: 8000 });

    // Verify it is now in target DOM
    const targetHasSlug = await target.locator(`li[data-slug="${slug}"]`).count();
    expect(targetHasSlug).toBeGreaterThan(0);
    await context.close();
  });
});
