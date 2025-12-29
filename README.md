# Sticker Keyboard

Focused sticker keyboard for Flutter apps. Provide sticker assets (local or network) and render a lightweight picker UI with recents, search, and category tabs.

## Key features
- 📑 Category-based sticker organization with tabs
- 🔄 Automatic recently-used sticker management
- 🔍 Built-in search functionality
- 🌐 Support for local assets and remote URLs
- 🎨 Fully customizable appearance and layout

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  sticker_keyboard: <version>
```

Import:

```dart
import 'package:sticker_keyboard/sticker_keyboard.dart';
```

## Sticker setup

- Create an `assets/stickers/` folder in your app.
- Add subfolders per category (folder name becomes tab label).
- Supported files: `.png`, `.gif`, `.webp`, `.jpg`, `.jpeg`.
- Register the folders in your app `pubspec.yaml`.

Example:

```yaml
flutter:
  assets:
    - assets/stickers/mood/
    - assets/stickers/memes/
```

## Usage

```dart
StickerKeyboard(
  onStickerSelected: (Sticker sticker) {
    // Handle sticker selection
  },
  keyboardConfig: KeyboardConfig(
    stickerColumns: 5,
    stickerHorizontalSpacing: 6,
    stickerVerticalSpacing: 6,
    showRecentsTab: true,
    showSearchButton: true,
    stickers: [
      CategorySticker(
        category: 'Mood',
        stickers: [
          Sticker(assetUrl: 'assets/stickers/mood/sticker_1.webp', category: 'Mood'),
        ],
      ),
    ],
  ),
)
```

See `example/lib/main.dart` for a full demo.

## KeyboardConfig (sticker-related)

| property | description | default |
| --- | --- | --- |
| stickerColumns | Stickers per row | 4 |
| stickerVerticalSpacing | Vertical spacing | 5 |
| stickerHorizontalSpacing | Horizontal spacing | 5 |
| showRecentsTab | Show recents tab | true |
| recentsLimit | Max recents stored | 28 |
| replaceRecentOnLimitExceed | Replace newest when full | false |
| showSearchButton | Show search button | true |
| showBottomNav | Show bottom nav | true |
| withSafeArea | Wrap with SafeArea | true |
| bgColor | Background color | Color(0xFFEBEFF2) |

## Extended usage

```dart
final recentStickers = await StickerPickerUtils().getRecentStickers();
final results = await StickerPickerUtils().searchSticker(
  searchQuery: 'funny',
  context: context,
);
```

## Issues

Please file bugs and feature requests in the issue tracker.
