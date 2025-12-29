import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:sticker_keyboard/models/keyboard_config.dart';
import 'package:sticker_keyboard/models/sticker.dart';
import 'package:sticker_keyboard/utils/sticker_keyboard_utils.dart';
import 'package:sticker_keyboard/widgets/search/sticker_search.dart';
import 'package:sticker_keyboard/widgets/sticker_picker_widget.dart';

class StickerKeyboard extends StatefulWidget {
  /// Optional keyboard configuration.
  final KeyboardConfig keyboardConfig;

  /// Optional callback function for when a sticker is pressed.
  final Function(Sticker)? onStickerSelected;

  /// Optional callback function for when Backspace is pressed.
  final Function()? onBackspacePressed;

  const StickerKeyboard({
    Key? key,
    this.keyboardConfig = const KeyboardConfig(),
    this.onBackspacePressed,
    this.onStickerSelected,
  }) : super(key: key);

  @override
  State<StickerKeyboard> createState() => _StickerKeyboardState();
}

class _StickerKeyboardState extends State<StickerKeyboard> {
  final StreamController<String> scrollStream =
      StreamController<String>.broadcast();
  final List<Sticker> _recentSticker = List.empty(growable: true);

  bool _isSearching = false;
  bool _showBottomNav = true;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      scrollStream.stream.listen((event) {
        if (event == "hideNav") {
          if (_showBottomNav) {
            setState(() {
              _showBottomNav = false;
            });
          }
        } else {
          if (!_showBottomNav) {
            setState(() {
              _showBottomNav = true;
            });
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: widget.keyboardConfig.withSafeArea &&
          _showBottomNav &&
          widget.keyboardConfig.showBottomNav,
      top: widget.keyboardConfig.withSafeArea,
      left: widget.keyboardConfig.withSafeArea,
      right: widget.keyboardConfig.withSafeArea,
      child: _isSearching
          ? StickerSearch(
              recents: _recentSticker,
              keyboardConfig: widget.keyboardConfig,
              onStickerSelected: (Sticker sticker) {
                if (widget.onStickerSelected != null) {
                  widget.onStickerSelected!(sticker);
                }
              },
              onCloseSearch: () {
                setState(() {
                  _isSearching = false;
                });
              },
            )
          : Column(
              children: [
                Expanded(
                  child: StickerPickerWidget(
                    keyboardConfig: widget.keyboardConfig,
                    stickers: widget.keyboardConfig.stickers,
                    onStickerSelected: widget.onStickerSelected,
                    scrollStream: scrollStream,
                  ),
                ),
                Visibility(
                  visible: _showBottomNav &&
                      widget.keyboardConfig.showBottomNav,
                  child: _buildBottomNav(),
                ),
              ],
            ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 50,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: widget.keyboardConfig.bgColor,
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(43, 52, 69, .1),
            offset: Offset(0, -5),
            spreadRadius: 10,
            blurRadius: 200,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Opacity(
              opacity: widget.keyboardConfig.showSearchButton ? 1 : 0,
              child: IconButton(
                onPressed: () async {
                  if (!widget.keyboardConfig.showSearchButton) {
                    return;
                  }

                  setState(() => _isSearching = true);
                  _recentSticker.clear();
                  _recentSticker.addAll((await StickerKeyboardUtils()
                          .getRecentStickers())
                      .map((e) => e.sticker)
                      .toList());
                },
                icon: const Icon(
                  Icons.search,
                ),
              ),
            ),
            const Spacer(),
            Opacity(
              opacity: widget.keyboardConfig.showBackSpace ? 1 : 0,
              child: IconButton(
                onPressed: () {
                  if (!widget.keyboardConfig.showBackSpace ||
                      widget.onBackspacePressed == null) {
                    return;
                  }
                  widget.onBackspacePressed!();
                },
                icon: const Icon(
                  Icons.backspace_outlined,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
