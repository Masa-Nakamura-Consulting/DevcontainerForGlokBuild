# Sample Code for Python

A simple ToDo app built with Python, Flask, and HTMX.

## Run the app

```bash
uv sync
uv run python app.py
```

Open http://localhost:5000 in a browser to use it.

## Playwright e2e tests (headed)

### Setup

- Open http://localhost:6080/vnc.html in a browser and click Connect. You will see the Xvfb desktop running inside the container.

```bash
uv run playwright install
DISPLAY=:1 uv run pytest --headed --slowmo 2000
```
