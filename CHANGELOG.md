# Changelog

## [0.5.0] - 2026-08-26
### Added
- **Cart & Order History:** Added card-to-card payment guide banners with support details (card number, account name, and phone number for payment receipt submission) to both `CartPage` and `OrderHistoryPage`.
- **UI Enhancements:** Improved layout consistency and visibility for payment instructions across shopping and order tracking flows.
### Changed
- Bumped project version to `0.5.0` in `VERSION` and `pubspec.yaml`.

## [0.4.0] - 2026-08-25
### Fixed
- **Navigation**: Resolved the critical `Scaffold.geometryOf() must only be accessed during the paint phase` error by refactoring `CustomBottomNavBar` layout structure.
- **UI Rendering**: Eliminated mouse tracker assertion conflicts and layout synchronization issues associated with custom bottom app bar clipping.
### Updated
- **Home & Scanner**: Minor adjustments and stability improvements across home and product scanner pages.

## [0.3.0] - 2026-08-25
### Features & Improvements
- **Bottom Navigation**: Replaced `BottomAppBar` implementation with a robust custom `Material` wrapper to prevent Scaffold geometry assertion errors on desktop/Linux platforms.
- **Order History**: Fixed `LateInitializationError` by securely pre-initializing the orders future state before the initial widget render.
- **Home & Layout**: Optimized home page structure and cleaned up widget rendering tree for a smoother cross-platform user experience.

## [0.2.0] - 2026-08-25
### Features
- **VIP & Showcase System:** Implemented tiered user subscriptions (`free`, `bronze`, `silver`, `gold`) and separated showcase products from the main store inventory based on user tier (`feat_home`, `feat_product`).
- **About Us Page:** Added a comprehensive "About Us" section (`feat_about`) with structured company details, service descriptions, and fully interactive/clickable external links using `url_launcher`.
- **Navigation & UI Updates:** Integrated the About Us page into the application drawer (`app_drawer.dart`) and updated user model records (`user_model.dart`, `auth_service.dart`) to properly handle subscription tiers.

## [0.1.6] - 2026-08-21
### Added
- Integrated official app logo and assets for multi-platform branding.
- Configured `flutter_launcher_icons` to automatically generate adaptive icons for Android, iOS, and Web.
- Added iOS configuration to remove the alpha channel (`remove_alpha_ios: true`) to comply with App Store submission guidelines.
### Changed
- Updated `pubspec.yaml` with launcher icon generation rules and development dependencies.
- Updated native icon assets across Android mipmap directories, iOS asset catalogs, and Web manifest/favicon resources.

## [0.1.5] - 2026-08-16
### Added
- Implemented Order History pagination (10 items per page).
- Added local order history deletion functionality (using SharedPreferences).
- Added direct access to order history from the navigation drawer.
### Fixed
- Fixed `RecordModel` type error in `OrderHistoryPage`.
- UI/UX improvements in the order history layout.
- 
## [0.1.4] - 2026-08-15
### Bug Fixes & Improvements
- **Cart Service**: Fixed a `NoSuchMethodError` crash caused by attempting to expand JSON cart items (`items.product`) directly in PocketBase. Replaced it with a robust mechanism to fetch product details individually using product IDs.
- **UI / Cart Page**: Cleaned up the price formatting on both the cart item cards and the checkout total summary by removing unwanted decimal zeros (`.00`), providing a cleaner numeric display.

## [0.1.3] - 2026-08-09
### Added
* Added app version, contact phone number, and address footer to the app drawer (`AppDrawer`).
* Integrated external web registration link (`https://idna.dataist.ir`) directly into the login page.
### Changed
* Updated the first-time onboarding flow (`SplashScreen`) to bypass the mandatory login screen and direct users straight to the home page.
* Improved product inventory handling and out-of-stock data synchronization from the backend.
### Fixed
* Streamlined navigation flow to ensure the login page is only accessed on-demand from the profile/cart sections.

## [0.1.1] - 2026-07-12
### Added
* GitHub workflows for CI/CD automation (`.github/`).
* `CHANGELOG.md` and `VERSION` files for release tracking.
### Changed
* Bumped project version and updated metadata in `pubspec.yaml`.

## [0.1.0] - Initial Development
### Added
* Core shared services with PocketBase integration.
* Authentication system (User model, Login, Register, Profile).
* Product management (Models, Details, Service request).
* Cart management and order history tracking.
* Main UI layout (Home page, Product scanner).
* Native platform configurations and build scripts.
* Initial widget and unit tests.
* Splash screen and first-time launch onboarding logic.