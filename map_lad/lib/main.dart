// Flutter code sample for

// This sample shows an [AppBar] with two simple actions. The first action
// opens a [SnackBar], while the second action navigates to a new page.

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: MyStatelessWidget(),
    );
  }
}

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
final SnackBar snackBar = const SnackBar(content: Text('Showing Snackbar'));

/// This is the stateless widget that the main application instantiates.
class MyStatelessWidget extends StatelessWidget {
  MyStatelessWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MapLAD"),
        backgroundColor: Colors.pink,
      ),
      body: PageView(
        children: <Widget>[
          Container(
            child: Center(child: Text("This is a page")),
            color: Colors.pink,
          ),
          Container(
            child: Center(child: Text("Page 2?")),
            color: Colors.green,
          ),
          Container(
            child: Center(child: Text("Page 3 bby")),
            color: Colors.blue,
          ),
        ],
      ),
    );
  }
}