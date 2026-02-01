import 'package:cached_network_lottie/cached_network_lottie.dart';
import 'package:flutter/material.dart';
import 'package:sticker_keyboard/sticker_keyboard.dart';

class LottieNetworkExamplePage extends StatefulWidget {
  const LottieNetworkExamplePage({super.key});

  static const routeName = '/lottie-network';

  @override
  State<LottieNetworkExamplePage> createState() =>
      _LottieNetworkExamplePageState();
}

class _LottieNetworkExamplePageState extends State<LottieNetworkExamplePage> {
  Sticker? selectedSticker;
  late final Future<List<CategorySticker>> _stickerPacksFuture =
      Future<List<CategorySticker>>.value(_buildStickerPacks());

  List<CategorySticker> _buildStickerPacks() {
    const packs = <String, List<String>>{
      'TGS': [
        'https://data.chpic.su/stickers/u/UtyaDuckFull/UtyaDuckFull_001.tgs',
        'https://data.chpic.su/stickers/u/UtyaDuckFull/UtyaDuckFull_002.tgs',
        'https://data.chpic.su/stickers/u/UtyaDuckFull/UtyaDuckFull_003.tgs',
        'https://data.chpic.su/stickers/u/UtyaDuckFull/UtyaDuckFull_004.tgs',
        'https://data.chpic.su/stickers/u/UtyaDuckFull/UtyaDuckFull_005.tgs',
        'https://data.chpic.su/stickers/u/UtyaDuckFull/UtyaDuckFull_006.tgs',
      ],
      'Lottie': [
        'https://assets10.lottiefiles.com/packages/lf20_touohxv0.json',
        'https://assets10.lottiefiles.com/packages/lf20_9cyyl8i4.json',
        'https://assets2.lottiefiles.com/packages/lf20_puciaact.json',
        'https://assets2.lottiefiles.com/packages/lf20_jmBauI.json',
        'https://assets2.lottiefiles.com/packages/lf20_jcikwtux.json',
        'https://assets2.lottiefiles.com/packages/lf20_zrqthn6o.json',
        'https://assets7.lottiefiles.com/packages/lf20_nk0erqks.json',
        'https://assets4.lottiefiles.com/packages/lf20_lk80fpsm.json',
      ],
      'dotLottie': [
        'https://lottie.host/6c7e04f6-c13c-46da-9abd-0cf90cecce01/0ucQtSv8fC.lottie',
        'https://lottie.host/ff94e47e-33b2-496a-b768-cabbeeed8293/LAgiDkiN8A.lottie',
        'https://lottie.host/ca89a61a-262d-4b50-a8a7-d672a34e65f4/Bi1gdE1gvF.lottie',
      ],
    };

    return packs.entries
        .map(
          (entry) => CategorySticker(
            category: entry.key,
            stickers: entry.value
                .map(
                  (assetUrl) => Sticker(
                    assetUrl: assetUrl,
                    category: entry.key,
                  ),
                )
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
        title: const Text('Lottie Network Example'),
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
                        'Pick a Lottie sticker',
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
                    bgColor: const Color(0xFFF7F7F7),
                    indicatorColor: Colors.deepPurple,
                    iconColor: Colors.grey,
                    iconColorSelected: Colors.deepPurple,
                    progressIndicatorColor: Colors.deepPurple,
                    backspaceColor: Colors.deepPurple,
                    showRecentsTab: true,
                    recentsLimit: 24,
                    noRecents: const Text(
                      'No recents yet',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black26,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    replaceRecentOnLimitExceed: true,
                    showBottomNav: true,
                    tabIndicatorAnimDuration: kTabScrollDuration,
                    showBackSpace: false,
                    showSearchButton: false,
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
    return CachedNetworkLottie(
      key: Key(assetUrl),
      assetUrl,
      height: 140,
      width: 140,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
    );
  }
}
