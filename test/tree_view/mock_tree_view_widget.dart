import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:flutter/material.dart';

class MockTreeView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MockTreeViewState();
}

class MockTreeViewState extends State<MockTreeView> {
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
            tree: testTrees[stateCount],
            expansionBehavior: ExpansionBehavior.none,
            showRootNode: true,
            builder: (context, level, item) => ListTile(
              title: Text("Item ${item.level}-${item.key}"),
              subtitle: Text('Level $level'),
            ),
          ),
          TextButton(
            key: ValueKey("nextTree"),
            child: Text("Next"),
            onPressed: _nextTree,
          ),
        ]),
      ),
    );
  }
}

late final testTrees = <TreeNode>[
  defaultTree,
  nodesAddedTree,
  levelOneNodesAdded,
  levelTwoNodesAdded,
  levelThreeNodesAdded,
  nodesRemoved,
  levelOneNodesRemoved,
  levelTwoNodesRemoved,
  levelThreeNodesRemoved,
];

final defaultTree = TreeNode.root()
  ..addAll([
    TreeNode(key: "0A")..add(TreeNode(key: "0A1A")),
    TreeNode(key: "0B"),
    TreeNode(key: "0C"),
  ]);

final nodesAddedTree = TreeNode.root()
  ..addAll([
    TreeNode(key: "0A")..add(TreeNode(key: "0A1A")),
    TreeNode(key: "0B"),
    TreeNode(key: "0C"),
    TreeNode(key: "0D"),
    TreeNode(key: "0E"),
  ]);

final levelOneNodesAdded = TreeNode.root()
  ..addAll([
    TreeNode(key: "0A")..add(TreeNode(key: "0A1A")),
    TreeNode(key: "0C")
      ..addAll([
        TreeNode(key: "0C1A"),
        TreeNode(key: "0C1B"),
        TreeNode(key: "0C1C"),
      ]),
    TreeNode(key: "0D"),
    TreeNode(key: "0E"),
  ]);

final levelTwoNodesAdded = TreeNode.root()
  ..addAll([
    TreeNode(key: "0A")..add(TreeNode(key: "0A1A")),
    TreeNode(key: "0C")
      ..addAll([
        TreeNode(key: "0C1A"),
        TreeNode(key: "0C1B"),
        TreeNode(key: "0C1C")..addAll([TreeNode(key: "0C1C2A")]),
      ]),
    TreeNode(key: "0D"),
    TreeNode(key: "0E"),
  ]);

final levelThreeNodesAdded = TreeNode.root()
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

final nodesRemoved = TreeNode.root()
  ..addAll([
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
  ]);

final levelOneNodesRemoved = TreeNode.root()
  ..addAll([
    TreeNode(key: "0C")
      ..addAll([
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
  ]);

final levelTwoNodesRemoved = TreeNode.root()
  ..addAll([
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

final levelThreeNodesRemoved = TreeNode.root()
  ..addAll([
    TreeNode(key: "0C")..addAll([TreeNode(key: "0C1C")]),
  ]);
