import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:flutter/material.dart';

import '../utils/utils.dart';

const showSnackBar = false;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Indentation test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Indentation test'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: GridPaper(
          child: Indent(
            node: TreeNode(),
            indentation: Indentation(
              width: 100,
              decoration: IndentationDecoration(
                lineWidth: 20,
                color: Colors.green,
                style: IndentStyle.scopingLine,
              ),
            ),
            child: Container(
              padding: EdgeInsets.all(32),
              color: Colors.red,
              width: double.maxFinite,
              height: 200,
            ),
          ),
        ),
      ),
    );
  }
}
