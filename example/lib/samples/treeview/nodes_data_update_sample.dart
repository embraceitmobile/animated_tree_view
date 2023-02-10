import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:flutter/material.dart';

import '../../utils/utils.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nodes data update sample',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Nodes data update sample'),
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
  int stateCount = 0;

  void _nextTree() {
    setState(() {
      if (stateCount < testTrees.length - 1)
        stateCount++;
      else {
        stateCount = 0;
      }
    });
    Future.microtask(
      () => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(testTrees[stateCount].key),
          duration: const Duration(seconds: 2),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.fast_forward),
        onPressed: _nextTree,
      ),
      body: TreeView.simple(
        tree: testTrees[stateCount].value,
        expansionIndicator: ExpansionIndicator.DownUpChevron,
        expansionBehavior: ExpansionBehavior.none,
        shrinkWrap: true,
        showRootNode: true,
        builder: (context, level, item) => Card(
          color: colorMapper[level.clamp(0, colorMapper.length - 1)]!,
          child: ListTile(
            title: Text("Item ${item.level}-${item.key}"),
            subtitle: Text('Data ${item.data}'),
          ),
        ),
      ),
    );
  }
}

class StringTreeNode extends TreeNode<String> {
  StringTreeNode({super.data, super.parent});
}

late final testTrees = <MapEntry<String, TreeNode>>[
  MapEntry("Default tree", defaultTree),
  MapEntry("Updated tree", updatedTree),
  MapEntry("Updated tree 2", updatedTree2),
];

final defaultTree = TreeNode.root()
  ..addAll([
    TreeNode(key: "0A", data: 'd_0A')
      ..add(TreeNode(key: "0A1A", data: 'd_0A1A')),
    TreeNode(key: "0C", data: 'd_0C')
      ..addAll([
        TreeNode(key: "0C1A", data: 'd_0C1A'),
        TreeNode(key: "0C1B", data: 'd_0C1B'),
        TreeNode(key: "0C1C", data: 'd_0C1C')
          ..addAll([TreeNode(key: "0C1C2A", data: 'd_0C1C2A')]),
      ]),
    TreeNode(key: "0D", data: 'd_0D'),
    TreeNode(key: "0E", data: 'd_0E'),
  ]);

final updatedTree = TreeNode.root()
  ..addAll([
    TreeNode(key: "0A", data: 'd_0A2')
      ..add(TreeNode(key: "0A1A", data: 'd_0A1A2')),
    TreeNode(key: "0C", data: 'd_0C2')
      ..addAll([
        TreeNode(key: "0C1A", data: 'd_0C1A2'),
        TreeNode(key: "0C1B", data: 'd_0C1B2'),
        TreeNode(key: "0C1C", data: 'd_0C1C2')
          ..addAll([TreeNode(key: "0C1C2A", data: 'd_0C1C2A2')]),
      ]),
    TreeNode(key: "0D", data: 'd_0D2'),
    TreeNode(key: "0E", data: 'd_0E2'),
  ]);

final updatedTree2 = TreeNode.root()
  ..addAll([
    TreeNode(key: "0A", data: 'd_0A3')
      ..add(TreeNode(key: "0A1A", data: 'd_0A1A3')),
    TreeNode(key: "0C", data: 'd_0C23')
      ..addAll([
        TreeNode(key: "0C1A", data: 'd_0C1A3'),
        TreeNode(key: "0C1B", data: 'd_0C1B3'),
        TreeNode(key: "0C1C", data: 'd_0C1C3')
          ..addAll([TreeNode(key: "0C1C2A", data: 'd_0C1C2A3')]),
      ]),
    TreeNode(key: "0D", data: 'd_0D3'),
    TreeNode(key: "0E", data: 'd_0E3'),
  ]);
