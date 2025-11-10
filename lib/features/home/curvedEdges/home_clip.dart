import 'package:flutter/cupertino.dart';
import 'package:the_melophiles/device/deviceutils.dart';

import 'curved_edges.dart';

class ImageClip extends StatelessWidget {
  const ImageClip({super.key, required this.imagePath, this.height});

  final String imagePath;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: TCurvedEdges(),
      child: Image.asset(
        imagePath,
        width: double.infinity,
        height: height ?? TDeviceUtils.screenHeight(context) * 0.4,
        fit: BoxFit.cover,
      ),
    );
  }
}
