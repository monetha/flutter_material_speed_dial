import 'package:flutter/material.dart';

import 'background_overlay.dart';
import 'material_speed_dial_child_button.dart';

class MaterialSpeedDial extends StatefulWidget {
  final Function? onPressed;
  final String? tooltip;
  final List<MaterialSpeedDialChildButton> children;
  final bool visible;
  final bool overlay;
  final Color overlayColor;
  final double overlayOpacity;
  final Duration duration;
  final Widget firstChild;
  final Widget secondChild;
  final Color? splashColor;

  MaterialSpeedDial({
    Key? key,
    this.onPressed,
    this.tooltip,
    required this.children,
    this.visible = true,
    this.overlay = true,
    this.overlayColor = Colors.white,
    this.overlayOpacity = 0.7,
    this.duration = const Duration(milliseconds: 200),
    required this.firstChild,
    required this.secondChild,
    this.splashColor,
  }) : super(key: key);

  @override
  MaterialSpeedDialState createState() => MaterialSpeedDialState();
}

class MaterialSpeedDialState extends State<MaterialSpeedDial>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  var _isChildrenVisible = false;
  final _childrenAnimations = <Animation<double>>[];
  var _crossFadeState = CrossFadeState.showFirst;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    final childrenLength = widget.children.length;
    final intervalStep = 1 / childrenLength;
    for (var i = childrenLength - 1; i >= 0; i--) {
      final start = i / childrenLength;
      final animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(start, start + intervalStep),
      ));
      _childrenAnimations.add(animation);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !widget.visible,
      child: Stack(
        fit: StackFit.expand,
        overflow: Overflow.visible,
        children: <Widget>[
          if (widget.overlay)
            Positioned.fill(
              right: -16,
              bottom: -16,
              child: IgnorePointer(
                ignoring: !_isChildrenVisible,
                child: BackgroundOverlay(
                  color: widget.overlayColor,
                  opacity: widget.overlayOpacity,
                  animation: _animationController,
                  onPressed: _onBackgroundPressed,
                ),
              ),
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              AnimatedBuilder(
                animation: _animationController,
                builder: _buildAnimation,
              ),
              SizedBox(height: 15),
              AnimatedOpacity(
                opacity: widget.visible ? 1 : 0,
                duration: Duration(milliseconds: 100),
                child: FloatingActionButton(
                  heroTag: null,
                  tooltip: widget.tooltip,
                  splashColor: widget.splashColor,
                  child: AnimatedCrossFade(
                    firstChild: widget.firstChild,
                    secondChild: widget.secondChild,
                    crossFadeState: _crossFadeState,
                    duration: widget.duration,
                  ),
                  onPressed: _onFabPressed,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  void close([bool reset = false]) {
    if (reset) {
      _animationController.reset();
    } else {
      _animationController.reverse();
    }

    setState(() {
      _isChildrenVisible = false;
      _changeCrossFadeState();
    });
  }

  void open() {
    _animationController.forward();

    setState(() {
      _isChildrenVisible = true;
      _changeCrossFadeState();
    });
  }

  void _onBackgroundPressed() {
    close();
  }

  void _onFabPressed() {
    if (widget.onPressed != null) {
      widget.onPressed!();
    }

    if (_isChildrenVisible) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }

    setState(() {
      _isChildrenVisible = !_isChildrenVisible;
      _changeCrossFadeState();
    });
  }

  void _changeCrossFadeState() {
    if (_crossFadeState == CrossFadeState.showFirst) {
      _crossFadeState = CrossFadeState.showSecond;
    } else {
      _crossFadeState = CrossFadeState.showFirst;
    }
  }

  Widget _buildAnimation(BuildContext context, Widget? child) {
    return IgnorePointer(
      ignoring: !_isChildrenVisible,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          for (var i = 0; i < widget.children.length; i++)
            _childWidget(widget.children[i], _childrenAnimations[i])
        ],
      ),
    );
  }

  Widget _childWidget(
      MaterialSpeedDialChildButton child, Animation<double> animation) {
    return Container(
      margin: EdgeInsets.only(bottom: child.mini ? 5 : 10),
      child: Transform.translate(
          offset: Offset(child.mini ? -4 : 0, 0),
          child: child.buttonText != null
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Opacity(
                      opacity: animation.value,
                      child: Container(
                        margin: EdgeInsets.only(right: child.mini ? 10 : 16),
                        child: RaisedButton(
                          visualDensity:
                              child.mini ? VisualDensity.comfortable : null,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          elevation: 6,
                          color: child.buttonBackgroundColor,
                          textColor: child.buttonTextColor,
                          child: Text(child.buttonText),
                          onPressed: child.onPressed,
                        ),
                      ),
                    ),
                    Transform.scale(scale: animation.value, child: child)
                  ],
                )
              : Transform.scale(scale: animation.value, child: child)),
    );
  }
}
