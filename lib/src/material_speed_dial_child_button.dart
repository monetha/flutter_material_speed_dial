import 'package:flutter/material.dart';

class MaterialSpeedDialChildButton extends FloatingActionButton {
  final String buttonText;
  final Color buttonBackgroundColor;
  final Color buttonTextColor;

  MaterialSpeedDialChildButton({
    Key key,
    bool mini,
    Widget child,
    Function onPressed,
    String tooltip,
    this.buttonText,
    this.buttonBackgroundColor = Colors.white,
    this.buttonTextColor = Colors.black,
  }) : super(
          key: key,
          heroTag: null,
          mini: mini,
          child: child,
          onPressed: onPressed,
          tooltip: tooltip,
        );
}
