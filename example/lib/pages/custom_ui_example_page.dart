import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sticker_keyboard/sticker_keyboard.dart';

class CustomUiExamplePage extends StatefulWidget {
  const CustomUiExamplePage({super.key});

  static const routeName = '/custom-ui';

  @override
  State<CustomUiExamplePage> createState() => _CustomUiExamplePageState();
}

class _CustomUiExamplePageState extends State<CustomUiExamplePage> {
  Sticker? selectedSticker;
  late Future<List<CategorySticker>> _stickerPacksFuture;
  final Color _accentColor = const Color(0xFFFF635B);

  @override
  void initState() {
    super.initState();
    _stickerPacksFuture = _loadStickerPacks();
  }

  Future<List<CategorySticker>> _loadStickerPacks() async {
    final assetManifest =
        await AssetManifest.loadFromAssetBundle(rootBundle);
    final stickerAssets = assetManifest
        .listAssets()
        .where((path) => path.startsWith('assets/stickers/'))
        .where((path) {
          final lower = path.toLowerCase();
          return lower.endsWith('.webp') ||
              lower.endsWith('.png') ||
              lower.endsWith('.jpg') ||
              lower.endsWith('.gif') ||
              lower.endsWith('.jpeg');
        })
        .toList()
      ..sort();

    final Map<String, List<String>> byCategory = {};
    for (final asset in stickerAssets) {
      final parts = asset.split('/');
      if (parts.length < 3) {
        continue;
      }
      final category = parts[2];
      byCategory.putIfAbsent(category, () => []).add(asset);
    }

    final categories = byCategory.keys.toList()..sort();
    return categories
        .map(
          (category) => CategorySticker(
            category: category,
            stickers: byCategory[category]!
                .map((assetUrl) => Sticker(
                      assetUrl: assetUrl,
                      category: category,
                    ))
                .toList(),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7F4),
      appBar: AppBar(
        title: const Text('UI Custom Example'),
        backgroundColor: _accentColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                selectedSticker != null
                    ? _buildStickerPreview(selectedSticker!)
                    : const Text(
                        'Pick a sticker',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
              ],
            ),
          ),
          SizedBox(
            height: 320,
            child: FutureBuilder<List<CategorySticker>>(
              future: _stickerPacksFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No sticker packs found.'),
                  );
                }

                return StickerKeyboard(
                  onStickerSelected: (Sticker sticker) {
                    setState(() {
                      selectedSticker = sticker;
                    });
                  },
                  keyboardConfig: KeyboardConfig(
                    stickerColumns: 4,
                    stickerHorizontalSpacing: 6,
                    stickerVerticalSpacing: 6,
                    withSafeArea: true,
                    gridPadding: const EdgeInsets.symmetric(horizontal: 8),
                    bgColor: Colors.white,
                    indicatorColor: _accentColor,
                    iconColor: Colors.grey.shade500,
                    iconColorSelected: _accentColor,
                    progressIndicatorColor: _accentColor,
                    backspaceColor: _accentColor,
                    showRecentsTab: true,
                    recentsLimit: 24,
                    noRecents: Text(
                      'No recents yet',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    replaceRecentOnLimitExceed: true,
                    showBottomNav: true,
                    tabIndicatorAnimDuration: kTabScrollDuration,
                    showBackSpace: true,
                    showSearchButton: true,
                    categoryTabBuilder: (context, category, isSelected) {
                      if (category.category == 'Recents') {
                        return Icon(
                          Icons.access_time,
                          color: isSelected ? _accentColor : Colors.grey,
                        );
                      }

                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? _accentColor.withOpacity(0.12)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? _accentColor
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.folder_open,
                              size: 14,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              category.category,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? _accentColor
                                    : Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    customTabs: [
                      CustomKeyboardTab(
                        id: 'action',
                        tabBuilder: (context, isSelected) => Icon(
                          Icons.bolt,
                          color:
                              isSelected ? _accentColor : Colors.grey.shade400,
                        ),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Custom action tab tapped.'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                      CustomKeyboardTab(
                        id: 'custom-page',
                        tabBuilder: (context, isSelected) => Icon(
                          Icons.star,
                          color:
                              isSelected ? _accentColor : Colors.grey.shade400,
                        ),
                        pageBuilder: (context) =>
                            _buildCustomTabPage(context),
                      ),
                    ],
                    customTabPlacement: CustomTabPlacement.afterRecents,
                    stickers: snapshot.data!,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStickerPreview(Sticker sticker) {
    final assetUrl = sticker.assetUrl;
    if (assetUrl.startsWith('http')) {
      return Image.network(
        assetUrl,
        height: 120,
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
      );
    }

    return Image.asset(
      assetUrl,
      height: 120,
      errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
    );
  }

  Widget _buildCustomTabPage(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      alignment: Alignment.center,
      color: const Color(0xFFFFF7F4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.auto_awesome,
            size: 48,
            color: Color(0xFFFF635B),
          ),
          const SizedBox(height: 12),
          const Text(
            'Custom tab page',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Show any custom UI here.',
            style: TextStyle(color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }
}
