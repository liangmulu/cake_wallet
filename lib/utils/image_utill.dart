import 'package:cw_core/utils/proxy_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ImageUtil {
  static Widget getImageFromPath({required String imagePath, double? height, double? width}) {
    bool isNetworkImage = imagePath.startsWith('http') || imagePath.startsWith('https');
    if (CakeTor.instance.enabled && isNetworkImage) {
      imagePath = "assets/images/tor_logo.svg";
      isNetworkImage = false;
    }
    final bool isSvg = imagePath.endsWith('.svg');
    final double _height = height ?? 35;
    final double _width = width ?? 35;
    if (isNetworkImage) {
      return isSvg
          ? SvgPicture.network(
              key: ValueKey(imagePath),
              imagePath,
              height: _height,
              width: _width,
              placeholderBuilder: (BuildContext context) => Container(
                height: _height,
                width: _width,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              errorBuilder: (_, __, ___) {
                return Container(
                  height: _height,
                  width: _width,
                  child: Center(
                    child: Icon(Icons.error_outline, color: Colors.grey),
                  ),
                );
              },
            )
          : Image.network(
              key: ValueKey(imagePath),
              imagePath,
              height: _height,
              width: _width,
              loadingBuilder:
                  (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return Container(
                  height: _height,
                  width: _width,
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  ),
                );
              },
              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                return Container(
                  height: _height,
                  width: _width,
                  child: Center(
                    child: Icon(Icons.error_outline, color: Colors.grey),
                  ),
                );
              },
            );
    } else {
      return isSvg
          ? SvgPicture.asset(
              imagePath,
              height: _height,
              width: _width,
              placeholderBuilder: (_) => Icon(Icons.error),
              errorBuilder: (_, __, ___) => Icon(Icons.error),
              key: ValueKey(imagePath),
            )
          : Image.asset(
              imagePath,
              height: _height,
              width: _width,
              errorBuilder: (_, __, ___) => Icon(Icons.error),
              key: ValueKey(imagePath),
            );
    }
  }
}
