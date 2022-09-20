import 'package:animated_tree_view/animated_tree_view.dart';

late final testTrees = [
  defaultIndexedTree,
  nodesAddedIndexedTree,
  nodesRemovedIndexedTree,
  nodesLevelOneChildRemovedIndexedTree,
  nodesLevelTwoChildRemovedIndexedTree,
];

final defaultIndexedTree = SimpleIndexedNode.root()
  ..addAll([
    SimpleIndexedNode("0A")..add(SimpleIndexedNode("0A1A")),
    SimpleIndexedNode("0B"),
    SimpleIndexedNode("0C")
      ..addAll([
        SimpleIndexedNode("0C1A"),
        SimpleIndexedNode("0C1B"),
        SimpleIndexedNode("0C1C")
          ..addAll([
            SimpleIndexedNode("0C1C2A")
              ..addAll([
                SimpleIndexedNode("0C1C2A3A"),
                SimpleIndexedNode("0C1C2A3B"),
                SimpleIndexedNode("0C1C2A3C"),
              ]),
          ]),
      ]),
  ]);

final nodesAddedIndexedTree = SimpleIndexedNode.root()
  ..addAll([
    SimpleIndexedNode("0A")..add(SimpleIndexedNode("0A1A")),
    SimpleIndexedNode("0B"),
    SimpleIndexedNode("0C")
      ..addAll([
        SimpleIndexedNode("0C1A"),
        SimpleIndexedNode("0C1B"),
        SimpleIndexedNode("0C1C")
          ..addAll([
            SimpleIndexedNode("0C1C2A")
              ..addAll([
                SimpleIndexedNode("0C1C2A3A"),
                SimpleIndexedNode("0C1C2A3B"),
                SimpleIndexedNode("0C1C2A3C"),
              ]),
          ]),
      ]),
    SimpleIndexedNode("0D"),
    SimpleIndexedNode("0E"),
  ]);

final nodesRemovedIndexedTree = SimpleIndexedNode.root()
  ..addAll([
    SimpleIndexedNode("0A")..add(SimpleIndexedNode("0A1A")),
    SimpleIndexedNode("0C")
      ..addAll([
        SimpleIndexedNode("0C1A"),
        SimpleIndexedNode("0C1B"),
        SimpleIndexedNode("0C1C")
          ..addAll([
            SimpleIndexedNode("0C1C2A")
              ..addAll([
                SimpleIndexedNode("0C1C2A3A"),
                SimpleIndexedNode("0C1C2A3B"),
                SimpleIndexedNode("0C1C2A3C"),
              ]),
          ]),
      ]),
  ]);

final nodesLevelOneChildRemovedIndexedTree = SimpleIndexedNode.root()
  ..addAll([
    SimpleIndexedNode("0A")..add(SimpleIndexedNode("0A1A")),
    SimpleIndexedNode("0C")
      ..addAll([
        SimpleIndexedNode("0C1C")
          ..addAll([
            SimpleIndexedNode("0C1C2A")
              ..addAll([
                SimpleIndexedNode("0C1C2A3A"),
                SimpleIndexedNode("0C1C2A3B"),
                SimpleIndexedNode("0C1C2A3C"),
              ]),
          ]),
      ]),
  ]);

final nodesLevelTwoChildRemovedIndexedTree = SimpleIndexedNode.root()
  ..addAll([
    SimpleIndexedNode("0A")..add(SimpleIndexedNode("0A1A")),
    SimpleIndexedNode("0C")
      ..addAll([
        SimpleIndexedNode("0C1C")
          ..addAll([
            SimpleIndexedNode("0C1C2A")
              ..addAll([
                SimpleIndexedNode("0C1C2A3A"),
              ]),
          ]),
      ]),
  ]);
