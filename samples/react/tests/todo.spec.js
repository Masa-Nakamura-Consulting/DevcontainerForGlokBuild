import { expect, test } from '@playwright/test'

test('add, toggle, and delete a task', async ({ page }) => {
  await page.goto('/')
  await expect(page.getByRole('heading', { name: 'ToDo' })).toBeVisible()
  await expect(page.locator('#todo-list .empty')).toHaveText('Nothing here yet')

  await page.getByLabel('Task').fill('Buy milk')
  await page.getByRole('button', { name: 'Add' }).click()

  const item = page.locator('#todo-list li')
  await expect(item).toHaveCount(1)
  await expect(item.getByRole('button', { name: 'Buy milk' })).toBeVisible()
  await expect(page.locator('#todo-list .empty')).toHaveCount(0)

  await item.getByRole('button', { name: 'Buy milk' }).click()
  await expect(page.locator('#todo-list li')).toHaveClass(/\bdone\b/)

  await page.getByRole('button', { name: 'Delete' }).click()
  await expect(page.locator('#todo-list .empty')).toBeVisible()
})
