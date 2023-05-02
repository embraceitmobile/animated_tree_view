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
      title: 'Simple Animated Tree Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Simple Animated Tree Demo'),
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
  final GlobalKey<TreeViewState> _treeKey = GlobalKey<TreeViewState>();
  late final controller = _treeKey.currentState?.controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (sampleTree.isExpanded) {
            controller?.collapseNode(sampleTree);
          } else {
            controller?.expandAllChildren(sampleTree);
          }
          setState(() {});
        },
        label:
            sampleTree.isExpanded ? Text("Collapse all") : Text("Expand all"),
      ),
      body: TreeView.simple(
        key: _treeKey,
        tree: sampleTree,
        expansionIndicatorBuilder: (context, node) =>
            ChevronIndicator.rightDown(
          tree: node,
          color: Colors.blue[700],
          padding: const EdgeInsets.all(8),
        ),
        indentation: Indentation(style: IndentStyle.squareJoint),
        onItemTap: (item) {
          print("Item tapped: ${item.key}");
          if (showSnackBar)
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Item tapped: ${item.key}"),
                duration: const Duration(milliseconds: 750),
              ),
            );
        },
        builder: (context, node) => Card(
          color: colorMapper[node.level.clamp(0, colorMapper.length - 1)]!,
          child: ListTile(
            title: Text("Item ${node.level}-${node.key}"),
            subtitle: Text('Level ${node.level}'),
          ),
        ),
      ),
    );
  }
}

final sampleTree = TreeNode.root()
  ..addAll([
    TreeNode(key: "0A")..add(TreeNode(key: "0A1A")),
    TreeNode(key: "0C")
      ..addAll([
        TreeNode(key: "0C1A"),
        TreeNode(key: "0C1B"),
        TreeNode(key: "0C1C")
          ..addAll([
            TreeNode(key: "0C1C2A")
              ..addAll([
                TreeNode(key: "0C1C2A3A"),
                TreeNode(key: "0C1C2A3B"),
                TreeNode(key: "0C1C2A3C"),
              ]),
          ]),
      ]),
    TreeNode(key: "0D"),
    TreeNode(key: "0E"),
  ]);
