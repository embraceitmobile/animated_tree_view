import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class FakeStatelessTreeView<T> extends StatelessWidget {
  final TreeNode<T> tree;

  const FakeStatelessTreeView({super.key, required this.tree});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Material(
        child: TreeView.simple(
          tree: tree,
          expansionBehavior: ExpansionBehavior.scrollToLastChild,
          showRootNode: true,
          builder: (context, node) => ListTile(
            title: Text("Item ${node.level}-${node.key}"),
            subtitle: Text('Level ${node.level}'),
          ),
        ),
      ),
    );
  }
}

class FakeStatefulTreeView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FakeStatefulTreeViewState();
}

class FakeStatefulTreeViewState extends State<FakeStatefulTreeView> {
  int stateCount = 0;

  void _nextTree() {
    setState(() {
      if (stateCount < testTrees.length - 1)
        stateCount++;
      else {
        stateCount = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Material(
        child: Stack(children: [
          TreeView.simple(
            tree: testTrees[stateCount].item1,
            expansionBehavior: ExpansionBehavior.scrollToLastChild,
            showRootNode: true,
            builder: (context, node) => ListTile(
              title: Text("Item ${node.level}-${node.key}"),
              subtitle: Text('Level ${node.level}'),
            ),
          ),
          TextButton(
            key: ValueKey("nextButton"),
            child: Text("Next"),
            onPressed: _nextTree,
          ),
        ]),
      ),
    );
  }
}

late final testTrees = <Tuple2<TreeNode, List<TreeNode>>>[
  Tuple2(defaultTree, []),
  Tuple2(nodesAddedTree, []),
  Tuple2(nodesRemovedTree, [
    TreeNode(key: "0C"),
    TreeNode(key: "0C1C"),
    TreeNode(key: "0C1C2A"),
    TreeNode(key: "0C1C2A3C"),
  ]),
];

TreeNode get defaultTree => TreeNode.root()
  ..addAll([
    TreeNode(key: "0A")
      ..addAll([
        TreeNode(key: "0A1A"),
      ]),
    TreeNode(key: "0B"),
    TreeNode(key: "0C")
      ..addAll([
        TreeNode(key: "0C1C")
          ..addAll([
            TreeNode(key: "0C1C2A")
              ..addAll([
                TreeNode(key: "0C1C2A3C"),
              ]),
          ]),
      ]),
  ]);

TreeNode get nodesAddedTree => TreeNode.root()
  ..addAll([
    TreeNode(key: "0A")
      ..addAll([
        TreeNode(key: "0A1A"),
      ]),
    TreeNode(key: "0B"),
    TreeNode(key: "0C")
      ..addAll([
        TreeNode(key: "0C1C")
          ..addAll([
            TreeNode(key: "0C1C2A")
              ..addAll([
                TreeNode(key: "0C1C2A3C"),
              ]),
          ]),
      ]),
    TreeNode(key: "0D"),
  ]);

TreeNode get nodesRemovedTree => TreeNode.root()
  ..addAll([
    TreeNode(key: "0A")
      ..addAll([
        TreeNode(key: "0A1A"),
      ]),
    TreeNode(key: "0B"),
    TreeNode(key: "0D"),
  ]);
