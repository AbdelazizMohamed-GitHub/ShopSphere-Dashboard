# ShopSphere Dashboard

A Flutter admin dashboard for the ShopSphere e-commerce store. It runs on web, Android, Windows and Linux (the platform folders are in the repo), and lets a store owner manage products, orders, customers and staff, view sales analytics, and send product-offer notifications to customers.

## Features

- **Authentication**: email/password login, registration, forgot password, email verification and Google sign-in (Firebase Auth).
- **Products**: list, search, filter, view details, and add products (with image upload).
- **Orders**: order table with status and payment filters, and order details (address, tracking number, items).
- **Analytics**: daily / weekly / monthly / yearly sales charts, most-sold products and category distribution (`fl_chart` and `syncfusion_flutter_charts`).
- **Users**: staff and customer lists, customer profiles with saved addresses and order history.
- **Notifications**: send a product offer to a customer through Firebase Cloud Messaging and show local notifications with `awesome_notifications`.
- **Onboarding**: intro screens shown before the login flow.

## Screenshots

### Products

![Products](screenshots/products.png)

### Edit Product

![Edit Product](screenshots/edit-product.png)

### Orders

![Orders](screenshots/orders.png)

### Order Details

![Order Details](screenshots/order-details.png)

### Analytics

![Analytics](screenshots/analytics.png)

### Users

![Users](screenshots/users.png)

## Tech Stack

- Flutter (Dart SDK `3.47.7`)
- State management: `flutter_bloc` (Cubit)
- Routing: `go_router`
- Dependency injection: `get_it`
- Backend services: Firebase (Auth, Cloud Firestore, Cloud Messaging) and Supabase

## Project Structure

```
lib/
├── core/            # routing, theme, DI setup, shared cubits, services, loaders
├── features/
│   ├── analytics/   # sales charts and summaries
│   ├── auth/        # login, register, verify, forgot password
│   ├── onboarding/  # intro screens
│   ├── orders/      # order list, filters and details
│   ├── products/    # product list, search, details, add product
│   └── users/       # staff, customers and notifications
└── main.dart
```

Each feature follows the same layers: `data/` (models, repository implementations), `domain/` (entities and repository contracts) and `presention/` (controllers and views).

## Setup

### 1. Prerequisites

- Flutter SDK matching the Dart version in `pubspec.yaml`
- A Firebase project and a Supabase project

### 2. Install dependencies

```sh
flutter pub get
```

### 3. Add the local configuration files

Some files are intentionally not committed. You need to create them before the app will build:

**`lib/core/app/app_keys.dart`** (git-ignored). It must define the Supabase values used in `main.dart`:

```dart
class AppKeys {
  static const String supbaseUrl = 'https://YOUR-PROJECT.supabase.co';
  static const String supbaseApiKey = 'YOUR_SUPABASE_ANON_KEY';
}
```

**Firebase configuration.** `lib/firebase_options.dart` and `android/app/google-services.json` are already in the repo. To point the app at a different Firebase project, regenerate them with the FlutterFire CLI:

```sh
flutterfire configure
```

> **Security note:** do not put a Firebase service account file inside the app. Anything bundled in the client can be extracted. Sending notifications with a service account should be done from a backend (for example a Cloud Function). The current `notification_service.dart` loads `assets/firebase_service_account.json`, which is git-ignored and not included in the repo, so this feature will not work until that code moves to a backend.

### 4. Run

```sh
flutter run            # default device
flutter run -d chrome  # web
```

## Validate

```sh
flutter analyze
flutter test
```

> There are currently no tests in the `test/` folder.

## Known Issues

- Some files imported in `lib/` are not in the repository (for example under `core/utils/`, `features/explor/`, `features/profile/` and `features/dashboard/`), so the project does not build from a fresh clone until they are restored or the imports are updated.
- `notification_service.dart` depends on a git-ignored service account file (see the security note above).
