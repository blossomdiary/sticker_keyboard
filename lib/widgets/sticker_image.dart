import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class StickerImage extends StatelessWidget {
  const StickerImage({
    super.key,
    required this.assetUrl,
    this.fit = BoxFit.cover,
  });

  final String assetUrl;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    if (assetUrl.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: assetUrl,
        placeholder: (context, url) =>
            const CircularProgressIndicator.adaptive(),
        errorWidget: (context, url, error) => const Icon(Icons.error),
        fit: fit,
      );
    }

    return Image.asset(
      assetUrl,
      errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
      fit: fit,
    );
  }
}
