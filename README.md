# ShopSphere Dashboard

A responsive Flutter dashboard UI for an e-commerce store, with desktop, tablet,
and mobile layouts.

## Architecture

The dashboard feature is organized into:

- `domain/` — dashboard models, repository contract, and overview use case.
- `data/` — mock repository data; replace this implementation with an API-backed
  repository when connecting a store backend.
- `presentation/` — responsive dashboard layout and reusable UI components.

The app currently uses representative sample data. Date-range and chart-period
controls update their UI state; live store data is not connected.

## Run

```sh
flutter pub get
flutter run
```

## Validate

```sh
flutter analyze
flutter test
```
