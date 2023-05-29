import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:flutter/material.dart';

class FakeStatelessTreeView<T> extends StatelessWidget {
  final TreeNode<T> tree;
  final TreeReadyCallback<T, TreeNode<T>>? onTreeReady;

  const FakeStatelessTreeView({
    super.key,
    required this.tree,
    this.onTreeReady,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Material(
        child: TreeView.simple(
          tree: tree,
          showRootNode: true,
          onTreeReady: onTreeReady,
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
            tree: testTrees[stateCount].$1,
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

late final testTrees = <(TreeNode, List<TreeNode>)>[
  (defaultTree, []),
  (nodesAddedTree, []),
  (
    nodesRemovedTree,
    [
      TreeNode(key: "0C"),
      TreeNode(key: "0C1C"),
      TreeNode(key: "0C1C2A"),
      TreeNode(key: "0C1C2A3C"),
    ]
  ),
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

TreeNode get longTree => TreeNode.root()
  ..addAll([
    TreeNode(key: "0A"),
    TreeNode(key: "0B"),
    TreeNode(key: "0C"),
    TreeNode(key: "0D"),
    TreeNode(key: "0E"),
    TreeNode(key: "0F"),
    TreeNode(key: "0G"),
    TreeNode(key: "0H"),
    TreeNode(key: "0I"),
    TreeNode(key: "0J"),
    TreeNode(key: "0K"),
    TreeNode(key: "0L"),
    TreeNode(key: "0M"),
    TreeNode(key: "0N"),
    TreeNode(key: "0Z")
      ..addAll([
        TreeNode(key: "0Z1Z")
          ..addAll([
            TreeNode(key: "0Z1Z2A")
              ..addAll([
                TreeNode(key: "0Z1Z2A3Z"),
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
