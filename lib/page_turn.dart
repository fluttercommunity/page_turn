import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'src/builders/index.dart';

class PageTurn extends StatefulWidget {
  const PageTurn({
    Key key,
    this.duration = const Duration(milliseconds: 600),
    this.forwardCutoff = 0.6,
    this.reverseCutoff = 0.5,
    @required this.children,
  }) : super(key: key);

  final List<Widget> children;
  final Duration duration;

  final double forwardCutoff, reverseCutoff;
  @override
  _PageTurnState createState() => _PageTurnState();
}

class _PageTurnState extends State<PageTurn> with TickerProviderStateMixin {
  int currentIndex = 0;
  List<Widget> pages;

  bool _isForward;
  AnimationController _currentPage, _previousPage;

  @override
  void dispose() {
    _currentPage.dispose();
    _previousPage.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final _length = widget.children.length;
    pages = widget.children;
    _currentPage = AnimationController(
      value: 1,
      duration: widget.duration,
      vsync: this,
    );
    _previousPage = AnimationController(
      value: 0,
      duration: widget.duration,
      vsync: this,
    );
  }

  bool get _isLastPage => pages != null && (pages.length - 1) == currentIndex;

  bool get _isFirstPage => currentIndex == 0;

  void _turnPage(DragUpdateDetails details, BoxConstraints dimens) {
    final _ratio = details.delta.dx / dimens.maxWidth;
    if (_isForward == null) {
      if (details.delta.dx > 0) {
        _isForward = true;
      } else {
        _isForward = false;
      }
    }
    if (_isForward) {
      _previousPage.value += _ratio;
    } else {
      _currentPage.value += _ratio;
    }
  }

  // void _goNext() {
  //   _currentPage.reverse().then((_) async {
  //     await Future.delayed(Duration(milliseconds: 200));
  //     if (mounted)
  //       setState(() {
  //         currentIndex++;
  //         _currentPage.value = 1;
  //       });
  //   });
  // }

  // void _goBack() {
  //   _previousPage.forward().then((_) async {
  //     await Future.delayed(Duration(milliseconds: 200));
  //     if (mounted)
  //       setState(() {
  //         _previousPage.value = 0;
  //         currentIndex--;
  //       });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: LayoutBuilder(
        builder: (context, dimens) => GestureDetector(
          behavior: HitTestBehavior.opaque,
          onHorizontalDragCancel: () => Future.wait([
            _currentPage.forward(),
            _previousPage.reverse(),
          ]),
          onHorizontalDragStart: (_) {
            _currentPage.value = 1;
            _previousPage.value = 0;
          },
          onHorizontalDragUpdate: (details) => _turnPage(details, dimens),
          onHorizontalDragEnd: (_) async {
            print('C: ${_currentPage.value}, P: ${_previousPage.value}');
            if (!_isLastPage && _currentPage.value <= widget.forwardCutoff) {
              await _currentPage.reverse();
              if (mounted)
                setState(() {
                  currentIndex++;
                });
              _currentPage.value = 1;
            } else {
              _currentPage.forward();
            }
          },
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              if (!_isLastPage && pages.length > 1)
                Container(
                  color: Colors.blue,
                  child: IndexedStack(
                    children: pages,
                    index: currentIndex + 1,
                  ),
                ),
              if (pages != null)
                PageTurnWidget(
                  backgroundColor: Colors.red,
                  amount: _currentPage,
                  child: IndexedStack(
                    children: pages,
                    index: currentIndex,
                  ),
                ),
              // if (!_isFirstPage)
              //   PageTurnWidget(
              //     backgroundColor: Colors.greenAccent,
              //     amount: _previousPage,
              //     child: pages[currentIndex - 1],
              //   ),
              Positioned.fill(
                child: Flex(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    Flexible(
                      flex: 3,
                      child: Container(
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: _isFirstPage
                              ? null
                              : mounted
                                  ? () {
                                      setState(() => currentIndex--);
                                      _currentPage.forward();
                                      _previousPage.reverse();
                                    }
                                  : null,
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Container(
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: _isLastPage
                              ? null
                              : mounted
                                  ? () {
                                      setState(() => currentIndex++);
                                      _currentPage.forward();
                                      _previousPage.reverse();
                                    }
                                  : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
