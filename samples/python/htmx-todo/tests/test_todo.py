import re

from playwright.sync_api import Page, expect


def _full_loads(page: Page) -> str:
    return page.locator("body").get_attribute("data-full-loads")


def test_add_toggle_delete_swap_only_the_list(page: Page, server_url: str):
    page.goto(server_url)
    expect(page.get_by_role("heading", name="ToDo")).to_be_visible()
    expect(page.locator("#todo-list .empty")).to_have_text("Nothing here yet")
    assert _full_loads(page) == "1"

    page.get_by_label("Task").fill("Buy milk")
    page.get_by_role("button", name="Add").click()

    item = page.locator("#todo-list li")
    expect(item).to_have_count(1)
    expect(item.get_by_role("button", name="Buy milk")).to_be_visible()
    expect(page.locator("#todo-list .empty")).to_have_count(0)
    assert _full_loads(page) == "1"

    item.get_by_role("button", name="Buy milk").click()
    expect(page.locator("#todo-list li")).to_have_class(re.compile(r"\bdone\b"))
    assert _full_loads(page) == "1"

    page.get_by_role("button", name="Delete").click()
    expect(page.locator("#todo-list .empty")).to_be_visible()
    assert _full_loads(page) == "1"
