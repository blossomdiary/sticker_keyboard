import 'package:flutter/material.dart';
import 'package:sticker_keyboard/models/category_sticker.dart';

/// KeyboardConfig for customizations
class KeyboardConfig {
  /// Constructor
  const KeyboardConfig({
    this.stickerColumns = 4,
    this.stickerHorizontalSpacing = 5,
    this.stickerVerticalSpacing = 5,
    this.gridPadding = EdgeInsets.zero,
    this.bgColor = const Color(0xFFEBEFF2),
    this.indicatorColor = Colors.blue,
    this.iconColor = Colors.grey,
    this.iconColorSelected = Colors.blue,
    this.progressIndicatorColor = Colors.blue,
    this.backspaceColor = Colors.blue,
    this.showRecentsTab = true,
    this.recentsLimit = 28,
    this.replaceRecentOnLimitExceed = false,
    this.noRecents = const Text(
      'No Recents',
      style: TextStyle(fontSize: 20, color: Colors.black26),
      textAlign: TextAlign.center,
    ),
    this.tabIndicatorAnimDuration = kTabScrollDuration,
    this.withSafeArea = true,
    this.showBackSpace = false,
    this.showSearchButton = true,
    this.showBottomNav = true,
    this.stickers = const [],
  });

  /// Number of stickers per row
  final int stickerColumns;

  /// Vertical spacing between stickers
  final double stickerVerticalSpacing;

  /// Horizontal spacing between stickers
  final double stickerHorizontalSpacing;

  /// Apply [SafeArea] widget around keyboard
  final bool withSafeArea;

  /// Show search button on the bottom nav
  final bool showSearchButton;

  /// Show backspace button on the bottom nav
  /// Backspace is normally used for deleting characters.
  final bool showBackSpace;

  /// The background color of the Widget
  final Color bgColor;

  /// The color of the category indicator
  final Color indicatorColor;

  /// The color of the category icons
  final Color iconColor;

  /// The color of the category icon when selected
  final Color iconColorSelected;

  /// The color of the loading indicator during initialization
  final Color progressIndicatorColor;

  /// The color of the backspace icon button
  final Color backspaceColor;

  /// Show extra tab with recently used stickers
  final bool showRecentsTab;

  /// Limit of recently used stickers that will be saved
  final int recentsLimit;

  /// A widget (usually [Text]) to be displayed if no recent stickers to display
  final Widget noRecents;

  /// Duration of tab indicator to animate to next category
  final Duration tabIndicatorAnimDuration;

  /// The padding of GridView, default is [EdgeInsets.zero]
  final EdgeInsets gridPadding;

  /// Replace latest sticker on recents list on limit exceed
  final bool replaceRecentOnLimitExceed;

  // Show bottom navigator
  final bool showBottomNav;

  /// Initial stickers
  final List<CategorySticker> stickers;
}
