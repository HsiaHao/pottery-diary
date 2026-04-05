import 'dart:io';

import 'package:flutter/material.dart';

/// Renders a local file image with a grey placeholder if the file is missing.
class SafeFileImage extends StatelessWidget {
  const SafeFileImage({
    super.key,
    required this.path,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  final String path;
  final double? width;
  final double? height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Image.file(
      File(path),
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => Container(
        width: width,
        height: height,
        color: const Color(0xFFE8E0D8),
        child: const Icon(Icons.image_not_supported_outlined,
            color: Color(0xFFBFAFA0)),
      ),
    );
  }
}
