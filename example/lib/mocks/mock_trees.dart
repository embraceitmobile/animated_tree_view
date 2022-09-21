import 'package:animated_tree_view/animated_tree_view.dart';

late final testTrees = [
  defaultTree,
  nodesAddedTree,
  nodesRemovedTree,
  nodesLevelOneChildRemovedTree,
  nodesLevelTwoChildRemovedTree,
];

final defaultTree = SimpleNode.root()
  ..addAll([
    SimpleNode("0A")..add(SimpleNode("0A1A")),
    SimpleNode("0B"),
    SimpleNode("0C")
      ..addAll([
        SimpleNode("0C1A"),
        SimpleNode("0C1B"),
        SimpleNode("0C1C")
          ..addAll([
            SimpleNode("0C1C2A")
              ..addAll([
                SimpleNode("0C1C2A3A"),
                SimpleNode("0C1C2A3B"),
                SimpleNode("0C1C2A3C"),
              ]),
          ]),
      ]),
  ]);

final nodesAddedTree = SimpleNode.root()
  ..addAll([
    SimpleNode("0A")..add(SimpleNode("0A1A")),
    SimpleNode("0B"),
    SimpleNode("0C")
      ..addAll([
        SimpleNode("0C1A"),
        SimpleNode("0C1B"),
        SimpleNode("0C1C")
          ..addAll([
            SimpleNode("0C1C2A")
              ..addAll([
                SimpleNode("0C1C2A3A"),
                SimpleNode("0C1C2A3B"),
                SimpleNode("0C1C2A3C"),
              ]),
          ]),
      ]),
    SimpleNode("0D"),
    // SimpleNode("0E"),
  ]);

final nodesRemovedTree = SimpleNode.root()
  ..addAll([
    SimpleNode("0A")..add(SimpleNode("0A1A")),
    SimpleNode("0C")
      ..addAll([
        SimpleNode("0C1A"),
        SimpleNode("0C1B"),
        SimpleNode("0C1C")
          ..addAll([
            SimpleNode("0C1C2A")
              ..addAll([
                SimpleNode("0C1C2A3A"),
                SimpleNode("0C1C2A3B"),
                SimpleNode("0C1C2A3C"),
              ]),
          ]),
      ]),
  ]);

final nodesLevelOneChildRemovedTree = SimpleNode.root()
  ..addAll([
    SimpleNode("0A")..add(SimpleNode("0A1A")),
    SimpleNode("0C")
      ..addAll([
        SimpleNode("0C1C")
          ..addAll([
            SimpleNode("0C1C2A")
              ..addAll([
                SimpleNode("0C1C2A3A"),
                SimpleNode("0C1C2A3B"),
                SimpleNode("0C1C2A3C"),
              ]),
          ]),
      ]),
  ]);

final nodesLevelTwoChildRemovedTree = SimpleNode.root()
  ..addAll([
    SimpleNode("0A")..add(SimpleNode("0A1A")),
    SimpleNode("0C")
      ..addAll([
        SimpleNode("0C1C")
          ..addAll([
            SimpleNode("0C1C2A")
              ..addAll([
                SimpleNode("0C1C2A3A"),
              ]),
          ]),
      ]),
  ]);
