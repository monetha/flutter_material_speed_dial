import 'package:flutter/material.dart';

class BackgroundOverlay extends AnimatedWidget {
  final Color color;
  final double opacity;

  BackgroundOverlay({
    Key key,
    @required Animation<double> animation,
    this.color,
    this.opacity,
  }) : super(key: key, listenable: animation);

  @override
  build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Container(color: color.withOpacity(animation.value * opacity));
  }
}
