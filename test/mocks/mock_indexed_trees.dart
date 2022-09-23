import 'package:animated_tree_view/animated_tree_view.dart';

late final testTrees = [
  defaultIndexedTree,
  nodesAddedIndexedTree,
  nodesRemovedIndexedTree,
  nodesLevelOneChildRemovedIndexedTree,
  nodesLevelTwoChildRemovedIndexedTree,
];

final defaultIndexedTree = IndexedTreeNode.root()
  ..addAll([
    IndexedTreeNode(key: "0A")..add(IndexedTreeNode(key: "0A1A")),
    IndexedTreeNode(key: "0B"),
    IndexedTreeNode(key: "0C")
      ..addAll([
        IndexedTreeNode(key: "0C1A"),
        IndexedTreeNode(key: "0C1B"),
        IndexedTreeNode(key: "0C1C")
          ..addAll([
            IndexedTreeNode(key: "0C1C2A")
              ..addAll([
                IndexedTreeNode(key: "0C1C2A3A"),
                IndexedTreeNode(key: "0C1C2A3B"),
                IndexedTreeNode(key: "0C1C2A3C"),
              ]),
          ]),
      ]),
  ]);

final nodesAddedIndexedTree = IndexedTreeNode.root()
  ..addAll([
    IndexedTreeNode(key: "0A")..add(IndexedTreeNode(key: "0A1A")),
    IndexedTreeNode(key: "0B"),
    IndexedTreeNode(key: "0C")
      ..addAll([
        IndexedTreeNode(key: "0C1A"),
        IndexedTreeNode(key: "0C1B"),
        IndexedTreeNode(key: "0C1C")
          ..addAll([
            IndexedTreeNode(key: "0C1C2A")
              ..addAll([
                IndexedTreeNode(key: "0C1C2A3A"),
                IndexedTreeNode(key: "0C1C2A3B"),
                IndexedTreeNode(key: "0C1C2A3C"),
              ]),
          ]),
      ]),
    IndexedTreeNode(key: "0D"),
    IndexedTreeNode(key: "0E"),
  ]);

final nodesRemovedIndexedTree = IndexedTreeNode.root()
  ..addAll([
    IndexedTreeNode(key: "0A")..add(IndexedTreeNode(key: "0A1A")),
    IndexedTreeNode(key: "0C")
      ..addAll([
        IndexedTreeNode(key: "0C1A"),
        IndexedTreeNode(key: "0C1B"),
        IndexedTreeNode(key: "0C1C")
          ..addAll([
            IndexedTreeNode(key: "0C1C2A")
              ..addAll([
                IndexedTreeNode(key: "0C1C2A3A"),
                IndexedTreeNode(key: "0C1C2A3B"),
                IndexedTreeNode(key: "0C1C2A3C"),
              ]),
          ]),
      ]),
  ]);

final nodesLevelOneChildRemovedIndexedTree = IndexedTreeNode.root()
  ..addAll([
    IndexedTreeNode(key: "0A")..add(IndexedTreeNode(key: "0A1A")),
    IndexedTreeNode(key: "0C")
      ..addAll([
        IndexedTreeNode(key: "0C1C")
          ..addAll([
            IndexedTreeNode(key: "0C1C2A")
              ..addAll([
                IndexedTreeNode(key: "0C1C2A3A"),
                IndexedTreeNode(key: "0C1C2A3B"),
                IndexedTreeNode(key: "0C1C2A3C"),
              ]),
          ]),
      ]),
  ]);

final nodesLevelTwoChildRemovedIndexedTree = IndexedTreeNode.root()
  ..addAll([
    IndexedTreeNode(key: "0A")..add(IndexedTreeNode(key: "0A1A")),
    IndexedTreeNode(key: "0C")
      ..addAll([
        IndexedTreeNode(key: "0C1C")
          ..addAll([
            IndexedTreeNode(key: "0C1C2A")
              ..addAll([
                IndexedTreeNode(key: "0C1C2A3A"),
              ]),
          ]),
      ]),
  ]);
