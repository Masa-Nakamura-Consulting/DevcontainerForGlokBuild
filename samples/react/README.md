# Sample Code for React

A simple ToDo app built with React.

## Run the app

```bash
npm install
npm run dev
```

`npm install` puts dependencies in the repository root `node_modules` directory. Open http://localhost:5173 in a browser to use the app.

## Playwright e2e tests (headed)

### Setup

- Open http://localhost:6080/vnc.html in a browser and click Connect. You will see the Xvfb desktop running inside the container.

```bash
npx playwright install
DISPLAY=:1 SLOWMO=2000 npx playwright test --headed
```
