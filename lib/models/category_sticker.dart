import 'package:sticker_keyboard/models/sticker.dart';

/// A category and its associated stickers.
class CategorySticker {
  late String category;
  List<Sticker> stickers = [];

  /// Creates a category with its stickers.
  CategorySticker({
    required this.category,
    this.stickers = const [],
  });

  /// Copy method
  CategorySticker copyWith({String? category, List<Sticker>? stickers}) {
    return CategorySticker(
      category: category ?? this.category,
      stickers: stickers ?? this.stickers,
    );
  }
}
