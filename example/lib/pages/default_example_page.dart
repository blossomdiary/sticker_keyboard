import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sticker_keyboard/sticker_keyboard.dart';

class DefaultExamplePage extends StatefulWidget {
  const DefaultExamplePage({super.key});

  static const routeName = '/default';

  @override
  State<DefaultExamplePage> createState() => _DefaultExamplePageState();
}

class _DefaultExamplePageState extends State<DefaultExamplePage> {
  Sticker? selectedSticker;
  late Future<List<CategorySticker>> _stickerPacksFuture;

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Sticker Keyboard'),
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
                        'No sticker selected',
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
                    stickerColumns: 5,
                    stickerHorizontalSpacing: 5,
                    stickerVerticalSpacing: 5,
                    withSafeArea: true,
                    gridPadding: EdgeInsets.zero,
                    bgColor: const Color(0xFFF2F2F2),
                    indicatorColor: Colors.blue,
                    iconColor: Colors.grey,
                    iconColorSelected: Colors.blue,
                    progressIndicatorColor: Colors.blue,
                    backspaceColor: Colors.blue,
                    showRecentsTab: true,
                    recentsLimit: 28,
                    noRecents: const Text(
                      'No Recents',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black26,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    replaceRecentOnLimitExceed: true,
                    showBottomNav: true,
                    tabIndicatorAnimDuration: kTabScrollDuration,
                    showBackSpace: false,
                    showSearchButton: true,
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
}
