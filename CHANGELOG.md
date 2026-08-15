# Changelog

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