import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:flutter/material.dart';

class FakeStatelessIndexedTreeView<T> extends StatelessWidget {
  final IndexedTreeNode<T> tree;
  final TreeReadyCallback<T, IndexedTreeNode<T>>? onTreeReady;

  const FakeStatelessIndexedTreeView({
    super.key,
    required this.tree,
    this.onTreeReady,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Material(
        child: TreeView.indexed(
          tree: tree,
          expansionBehavior: ExpansionBehavior.scrollToLastChild,
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

class FakeStatefulIndexedTreeView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FakeStatefulIndexedTreeViewState();

  const FakeStatefulIndexedTreeView({super.key});
}

class FakeStatefulIndexedTreeViewState
    extends State<FakeStatefulIndexedTreeView> {
  int stateCount = 0;

  void _nextTree() {
    setState(() {
      if (stateCount < testIndexedTrees.length - 1)
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
          TreeView.indexed(
            tree: testIndexedTrees[stateCount].$1,
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

late final testIndexedTrees = <(IndexedTreeNode, List<IndexedTreeNode>)>[
  (defaultIndexedTree, []),
  (nodesAddedIndexedTree, []),
  (
    nodesRemovedIndexedTree,
    [
      IndexedTreeNode(key: "0C"),
      IndexedTreeNode(key: "0C1C"),
      IndexedTreeNode(key: "0C1C2A"),
      IndexedTreeNode(key: "0C1C2A3C"),
    ]
  ),
];

IndexedTreeNode get defaultIndexedTree => IndexedTreeNode.root()
  ..addAll([
    IndexedTreeNode(key: "0A")
      ..addAll([
        IndexedTreeNode(key: "0A1A"),
      ]),
    IndexedTreeNode(key: "0B"),
    IndexedTreeNode(key: "0C")
      ..addAll([
        IndexedTreeNode(key: "0C1C")
          ..addAll([
            IndexedTreeNode(key: "0C1C2A")
              ..addAll([
                IndexedTreeNode(key: "0C1C2A3C"),
              ]),
          ]),
      ]),
  ]);

IndexedTreeNode get nodesAddedIndexedTree => IndexedTreeNode.root()
  ..addAll([
    IndexedTreeNode(key: "0A")
      ..addAll([
        IndexedTreeNode(key: "0A1A"),
      ]),
    IndexedTreeNode(key: "0B"),
    IndexedTreeNode(key: "0C")
      ..addAll([
        IndexedTreeNode(key: "0C1C")
          ..addAll([
            IndexedTreeNode(key: "0C1C2A")
              ..addAll([
                IndexedTreeNode(key: "0C1C2A3C"),
              ]),
          ]),
      ]),
    IndexedTreeNode(key: "0D"),
  ]);

IndexedTreeNode get nodesRemovedIndexedTree => IndexedTreeNode.root()
  ..addAll([
    IndexedTreeNode(key: "0A")
      ..addAll([
        IndexedTreeNode(key: "0A1A"),
      ]),
    IndexedTreeNode(key: "0B"),
    IndexedTreeNode(key: "0D"),
  ]);
