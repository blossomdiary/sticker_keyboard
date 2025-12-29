import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sticker_keyboard/models/category_sticker.dart';
import 'package:sticker_keyboard/models/custom_keyboard_tab.dart';
import 'package:sticker_keyboard/models/keyboard_config.dart';
import 'package:sticker_keyboard/models/recent_sticker.dart';
import 'package:sticker_keyboard/models/sticker.dart';
import 'package:sticker_keyboard/utils/sticker_picker_internal_utils.dart';
import 'package:sticker_keyboard/widgets/display/sticker_display.dart';

enum _KeyboardTabKind { recents, category, custom }

class _KeyboardTabEntry {
  _KeyboardTabEntry.recents()
      : kind = _KeyboardTabKind.recents,
        categoryName = 'Recents',
        customTab = null;

  _KeyboardTabEntry.category(this.categoryName)
      : kind = _KeyboardTabKind.category,
        customTab = null;

  _KeyboardTabEntry.custom(this.customTab)
      : kind = _KeyboardTabKind.custom,
        categoryName = null;

  final _KeyboardTabKind kind;
  final String? categoryName;
  final CustomKeyboardTab? customTab;
  CategorySticker? categorySticker;
}

class StickerPickerWidget extends StatefulWidget {
  const StickerPickerWidget({
    Key? key,
    required this.keyboardConfig,
    this.onStickerSelected,
    required this.scrollStream,
    required this.stickers,
  }) : super(key: key);

  final Function(Sticker)? onStickerSelected;
  final KeyboardConfig keyboardConfig;
  final StreamController<String> scrollStream;
  final List<CategorySticker> stickers;

  @override
  State<StickerPickerWidget> createState() => StickerPickerWidgetState();
}

class StickerPickerWidgetState extends State<StickerPickerWidget>
    with SingleTickerProviderStateMixin {
  final int initCategory = 0;
  final double tabBarHeight = 46;

  PageController? _pageController;
  TabController? _tabController;
  final List<_KeyboardTabEntry> _tabs = List.empty(growable: true);

  List<RecentSticker> _recentSticker = List.empty(growable: true);

  bool _loaded = false;
  int _currentTabIndex = 0;
  int? _recentsTabIndex;
  bool _isRevertingPage = false;

  void updateRecentSticker(List<RecentSticker> recentSticker,
      {bool refresh = false}) {
    _recentSticker = recentSticker;
    final recentsIndex = _recentsTabIndex;
    if (recentsIndex == null) {
      return;
    }
    final entry = _tabs[recentsIndex];
    final existing = entry.categorySticker;
    if (existing == null) {
      return;
    }
    entry.categorySticker = existing.copyWith(
      stickers: _recentSticker.map((e) => e.sticker).toList(),
    );
    if (mounted && refresh) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _listAssets();

    _pageController = PageController(initialPage: initCategory)
      ..addListener((() => widget.scrollStream.add('showNav')));
  }

  Future _listAssets() async {
    // Load from properties

    //  Get folder names from categories and tab titles
    List<String> tabsTitle = [];
    for (var i = 0; i < widget.stickers.length; i++) {
      String s = widget.stickers[i].category;
      if (!tabsTitle.contains(s)) {
        tabsTitle.add(s);
      }
    }

    _tabs.clear();
    _recentsTabIndex = null;
    final customTabs = widget.keyboardConfig.customTabs;
    final placement = widget.keyboardConfig.customTabPlacement;

    void addCustomTabs() {
      for (final tab in customTabs) {
        _tabs.add(_KeyboardTabEntry.custom(tab));
      }
    }

    if (placement == CustomTabPlacement.beforeRecents) {
      addCustomTabs();
    }

    if (widget.keyboardConfig.showRecentsTab) {
      _recentsTabIndex = _tabs.length;
      _tabs.add(_KeyboardTabEntry.recents());
    }

    if (placement == CustomTabPlacement.afterRecents) {
      addCustomTabs();
    }

    for (final title in tabsTitle) {
      _tabs.add(_KeyboardTabEntry.category(title));
    }

    if (placement == CustomTabPlacement.afterCategories) {
      addCustomTabs();
    }

    //Add titles to tab list and create tab controller
    _tabController = TabController(
        initialIndex: initCategory, length: _tabs.length, vsync: this)
      ..addListener(() {
        widget.scrollStream.add('showNav');
        final nextIndex = _tabController?.index ?? 0;
        if (nextIndex != _currentTabIndex && mounted) {
          setState(() {
            _currentTabIndex = nextIndex;
          });
        }
      });
    _currentTabIndex = _tabController?.index ?? 0;

    //Get stickers and group them based on tabs
    _updateStickers();
  }

  Widget _buildTab(int index, _KeyboardTabEntry entry) {
    if (entry.kind == _KeyboardTabKind.custom) {
      return Tab(
        child: entry.customTab!.tabBuilder(
          context,
          _currentTabIndex == index,
        ),
      );
    }

    final category = entry.categorySticker ??
        CategorySticker(category: entry.categoryName ?? '');
    final tabBuilder = widget.keyboardConfig.categoryTabBuilder;
    if (tabBuilder != null) {
      return Tab(
        child: tabBuilder(
          context,
          category,
          _currentTabIndex == index,
        ),
      );
    }

    return Tab(
      child: entry.kind == _KeyboardTabKind.recents
          ? const Icon(Icons.access_time)
          : Text(
              category.category.toUpperCase(),
              textAlign: TextAlign.center,
            ),
    );
  }

  // Initialize sticker data
  Future<void> _updateStickers() async {
    for (final entry in _tabs) {
      if (entry.kind == _KeyboardTabKind.custom) {
        continue;
      }
      if (entry.kind == _KeyboardTabKind.recents) {
        List<Sticker> recents =
            (await StickerPickerInternalUtils().getRecentStickers())
                .map((e) => e.sticker)
                .toList();
        entry.categorySticker = CategorySticker(
          category: "Recents",
          stickers: recents,
        );
        continue;
      }

      List<Sticker> stickers = [];
      final categoryName = entry.categoryName ?? '';
      for (var sticker in widget.stickers) {
        if (sticker.category == categoryName) {
          stickers.addAll(sticker.stickers);
        }
      }
      entry.categorySticker = CategorySticker(
        category: categoryName,
        stickers: stickers,
      );
    }

    _loaded = true;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: widget.keyboardConfig.bgColor,
      child: _loaded
          ? Column(
              children: [
                SizedBox(
                  height: tabBarHeight,
                  child: TabBar(
                    isScrollable: _tabs.length > 4,
                    labelColor: widget.keyboardConfig.iconColorSelected,
                    indicatorColor: widget.keyboardConfig.indicatorColor,
                    unselectedLabelColor: widget.keyboardConfig.iconColor,
                    controller: _tabController,
                    labelPadding: _tabs.length > 4
                        ? const EdgeInsets.symmetric(horizontal: 10)
                        : EdgeInsets.zero,
                    onTap: (index) {
                      final previousIndex = _currentTabIndex;
                      final entry = _tabs[index];
                      if (entry.kind == _KeyboardTabKind.custom) {
                        entry.customTab?.onTap?.call();
                        if (entry.customTab?.pageBuilder == null) {
                          if (_tabController?.index != previousIndex) {
                            _tabController!.animateTo(previousIndex);
                          }
                          if (_pageController!.hasClients) {
                            _pageController!.jumpToPage(previousIndex);
                          }
                          return;
                        }
                      }

                      _pageController!.jumpToPage(index);
                    },
                    tabs: _tabs
                        .asMap()
                        .entries
                        .map((item) => _buildTab(item.key, item.value))
                        .toList(),
                  ),
                ),
                Flexible(
                  child: PageView.builder(
                    itemCount: _tabs.length,
                    controller: _pageController,
                    onPageChanged: (index) {
                      if (_isRevertingPage) {
                        return;
                      }
                      final entry = _tabs[index];
                      if (entry.kind == _KeyboardTabKind.custom &&
                          entry.customTab?.pageBuilder == null) {
                        _isRevertingPage = true;
                        final targetIndex = _currentTabIndex;
                        if (_pageController!.hasClients) {
                          _pageController!.jumpToPage(targetIndex);
                        }
                        _tabController!.animateTo(
                          targetIndex,
                          duration:
                              widget.keyboardConfig.tabIndicatorAnimDuration,
                        );
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _isRevertingPage = false;
                        });
                        return;
                      }
                      _tabController!.animateTo(
                        index,
                        duration:
                            widget.keyboardConfig.tabIndicatorAnimDuration,
                      );
                    },
                    itemBuilder: (context, index) {
                      final entry = _tabs[index];
                      if (entry.kind == _KeyboardTabKind.custom) {
                        final pageBuilder = entry.customTab?.pageBuilder;
                        if (pageBuilder != null) {
                          return pageBuilder(context);
                        }
                        return const SizedBox.shrink();
                      }

                      final stickerCategory = entry.categorySticker;
                      if (entry.kind == _KeyboardTabKind.recents &&
                          (stickerCategory == null ||
                              stickerCategory.stickers.isEmpty)) {
                        return Center(
                          child: widget.keyboardConfig.noRecents,
                        );
                      }

                      if (stickerCategory == null) {
                        return const SizedBox.shrink();
                      }

                      return StickerDisplay(
                        stickerModel: stickerCategory,
                        keyboardConfig: widget.keyboardConfig,
                        onStickerSelected: widget.onStickerSelected,
                        scrollStream: widget.scrollStream,
                        onUpdateRecent: (recentSticker, refresh) =>
                            updateRecentSticker(
                          recentSticker,
                          refresh: refresh,
                        ),
                      );
                    },
                  ),
                ),
              ],
            )
          : const CircularProgressIndicator.adaptive(),
    );
  }
}
