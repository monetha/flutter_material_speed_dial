import 'package:flutter/material.dart';

class BackgroundOverlay extends AnimatedWidget {
  final Color color;
  final double opacity;
  final VoidCallback? onPressed;

  BackgroundOverlay({
    Key? key,
    required Animation<double> animation,
    required this.opacity,
    required this.color,
    this.onPressed,
  }) : super(key: key, listenable: animation);

  @override
  build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return GestureDetector(
      onTap: onPressed,
      child: Container(color: color.withOpacity(animation.value * opacity)),
    );
  }
}
