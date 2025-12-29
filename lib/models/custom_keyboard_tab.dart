import 'package:flutter/material.dart';

/// Placement options for custom tabs in the tab bar.
enum CustomTabPlacement {
  beforeRecents,
  afterRecents,
  afterCategories,
}

/// Builder for custom keyboard tabs.
typedef KeyboardTabWidgetBuilder = Widget Function(
  BuildContext context,
  bool isSelected,
);

/// Builder for custom tab pages.
typedef KeyboardTabPageBuilder = Widget Function(BuildContext context);

/// Defines a custom tab for the sticker keyboard.
class CustomKeyboardTab {
  const CustomKeyboardTab({
    required this.id,
    required this.tabBuilder,
    this.onTap,
    this.pageBuilder,
  });

  /// Unique identifier for the tab.
  final String id;

  /// Tab widget builder.
  final KeyboardTabWidgetBuilder tabBuilder;

  /// Optional onTap callback.
  /// When [pageBuilder] is null, this acts as an action-only tab.
  final VoidCallback? onTap;

  /// Optional page builder.
  /// When null, the tab does not navigate to a page.
  final KeyboardTabPageBuilder? pageBuilder;
}
