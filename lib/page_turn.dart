import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'src/builders/index.dart';

class PageTurn extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const PageTurn({
    Key key,
    this.child,
    this.duration = const Duration(milliseconds: 450),
  }) : super(key: key);
  @override
  _PageTurnState createState() => _PageTurnState();
}

class _PageTurnState extends State<PageTurn>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      value: 0.5,
      duration: widget.duration,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    if (_controller.status == AnimationStatus.dismissed ||
        _controller.status == AnimationStatus.reverse) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: LayoutBuilder(
        builder: (context, dimens) => GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _onTap,
          onHorizontalDragUpdate: (details) {
            final _dxPos = details.globalPosition.dx / dimens.maxWidth;
            final _ratio = details.delta.dx / dimens.maxWidth;
            _controller.value += _ratio;
          },
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              PageTurnImage(
                amount: AlwaysStoppedAnimation(1.0),
                image: NetworkImage(
                    'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6a/John_Masefield.djvu/page10-1024px-John_Masefield.djvu.jpg'),
              ),
              PageTurnWidget(
                amount: _controller,
                child: widget.child,
              ),
              Positioned(
                left: 0.0,
                right: 0.0,
                bottom: 20.0,
                height: 48.0,
                child: Container(
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) => Slider(
                      value: _controller.value,
                      onChanged: (double value) {
                        _controller.value = value;
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
