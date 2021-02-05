import 'package:flutter/material.dart';
import 'package:multi_level_list_view/multi_level_list_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ListenableTree test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ListenableTreeTest(),
    );
  }
}

class ListenableTreeTest extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ListenableTreeTestState();
}

class _ListenableTreeTestState extends State<ListenableTreeTest> {
  final listenableTree = ListenableTree<RowItem>();

  @override
  void initState() {
    super.initState();
    listenableTree.addedNodes.listen((event) {
      print("Nodes added: of type $event, ${event.items.length}");
    });

    listenableTree.removedNodes.listen((event) {
      print("Nodes removed: of type $event, ${event.keys}");
    });
  }

  @override
  void dispose() {
    listenableTree.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RaisedButton(
            child: Text("Add Node"),
            onPressed: () => listenableTree.add(RowItem()),
          ),
          RaisedButton(
            child: Text("Add 2xNodes"),
            onPressed: () => listenableTree.addAll([RowItem(), RowItem()]),
          ),
        ],
      ),
    );
  }
}
