[![Flutter Community: page_turn](https://fluttercommunity.dev/_github/header/page_turn)](https://github.com/fluttercommunity/community)

# Page Turn Widget

[![pub package](https://img.shields.io/pub/v/page_turn.svg)](https://pub.dartlang.org/packages/page_turn)
![github pages](https://github.com/fluttercommunity/page_turn/workflows/github%20pages/badge.svg)

Add a page turn effect to widgets in your app.

Created by Simon Lightfoot [@slightfoot](https://github.com/slightfoot)

## Screenshots

![info](https://raw.githubusercontent.com/fluttercommunity/page_turn/screenshots/screenshots/demo.gif)
![info](https://raw.githubusercontent.com/fluttercommunity/page_turn/screenshots/screenshots/turn.png)
![info](https://raw.githubusercontent.com/fluttercommunity/page_turn/screenshots/screenshots/cutoff.png)

## Example

```dart
import 'package:flutter/material.dart';

import 'package:page_turn/page_turn.dart';

import '../common/index.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key key,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = GlobalKey<PageTurnState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageTurn(
        key: _controller,
        backgroundColor: Colors.white,
        showDragCutoff: false,
        lastPage: Container(child: Center(child: Text('Last Page!'))),
        children: <Widget>[
          for (var i = 0; i < 20; i++) AlicePage(page: i),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          _controller.currentState.goToPage(2);
        },
      ),
    );
  }
}

```
