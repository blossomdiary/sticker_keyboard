import 'package:sticker_keyboard/models/sticker.dart';

/// A sticker with a usage counter for recents.
class RecentSticker {
  /// Constructor
  RecentSticker(this.sticker, this.counter);

  /// Sticker instance
  final Sticker sticker;

  /// Counter how often a sticker has been used before
  int counter = 0;

  /// Parse RecentSticker from json
  static RecentSticker fromJson(dynamic json) {
    return RecentSticker(
      Sticker.fromJson(json['sticker'] as Map<String, dynamic>),
      json['counter'] as int,
    );
  }

  /// Encode RecentSticker to json
  Map<String, dynamic> toJson() => {
        'sticker': sticker,
        'counter': counter,
      };
}
