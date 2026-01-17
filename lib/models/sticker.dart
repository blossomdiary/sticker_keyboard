/// A sticker entry used by the keyboard.
class Sticker {
  late String category;
  late String assetUrl;

  /// Creates a sticker with an asset or network URL and category.
  Sticker({
    required this.assetUrl,
    required this.category,
  });

  /// Creates a sticker from a JSON map.
  static Sticker fromJson(dynamic json) {
    return Sticker(
      assetUrl: json["assetUrl"],
      category: json['category'],
    );
  }

  /// Converts this sticker to JSON.
  Map<String, dynamic> toJson() => {
        'assetUrl': assetUrl,
        'category': category,
      };
}
