# Repository Guidelines

## Project Structure & Module Organization
- `lib/` holds the public package entrypoint (`flutter_social_keyboard.dart`) plus internal widgets, models, and utils under `lib/widgets`, `lib/models`, and `lib/utils`.
- `example/` contains a runnable Flutter demo app with its own `lib/`, `test/`, and platform folders (Android/iOS/macOS).
- `test/` is the package-level test suite (currently minimal).
- `screenshots/` and `lib/icons/` store documentation assets and package icon resources.

## Build, Test, and Development Commands
- `flutter pub get` installs dependencies for the package.
- `flutter analyze` runs static analysis using `flutter_lints`.
- `flutter test` runs package tests under `test/`.
- `flutter run` from `example/` launches the demo app; run `cd example` first.

## Coding Style & Naming Conventions
- Dart formatting: use `dart format .` (2-space indentation, trailing commas where typical for Flutter).
- Linting follows `analysis_options.yaml` via `flutter_lints`.
- File naming: lower_snake_case for Dart files (e.g., `sticker_picker_widget.dart`).
- Public API types and classes use UpperCamelCase; prefer descriptive widget names (e.g., `StickerPickerWidget`).

## Testing Guidelines
- Framework: `flutter_test` (see `dev_dependencies` in `pubspec.yaml`).
- Name tests using `_test.dart` suffix in `test/`.
- Add widget tests for UI behaviors and unit tests for utils; keep new coverage near touched code.

## Commit & Pull Request Guidelines
- Recent history shows short, imperative messages and optional emoji prefixes (e.g., `🐛 Fix incorrect logic`).
- Keep commits focused; include a brief context line in PR descriptions.
- For UI changes, attach screenshots or a short clip from the `example/` app.
- Link related issues when applicable.

## Configuration & Assets
- GIF search requires a Giphy API key; wire it through `KeyboardConfig.giphyAPIKey`.
- Sticker assets are expected under a project `assets/stickers/` tree in the host app; update the host app’s `pubspec.yaml` accordingly.
