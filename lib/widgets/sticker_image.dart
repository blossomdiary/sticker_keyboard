import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_lottie/cached_network_lottie.dart';
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
    if (_isLottieNetworkAsset(assetUrl)) {
      return LayoutBuilder(builder: (context, constraints) {
        return CachedNetworkLottie(
          assetUrl,
          fit: fit,
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
        );
      });
    }

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

bool _isLottieNetworkAsset(String url) {
  if (!url.startsWith('https')) {
    return false;
  }

  final uri = Uri.tryParse(url);
  final path = (uri?.path ?? url).toLowerCase();

  return path.endsWith('.lottie') ||
      path.endsWith('.json') ||
      path.endsWith('.tgs');
}
