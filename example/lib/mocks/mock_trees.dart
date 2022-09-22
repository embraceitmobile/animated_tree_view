import 'package:animated_tree_view/animated_tree_view.dart';

late final testTrees = [
  defaultTree,
  nodesAddedTree,
  levelOneNodesAdded,
  levelTwoNodesAdded,
  nodesRemoved,
  levelOneNodesRemoved,
  levelTwoNodesRemoved,
];

final defaultTree = SimpleNode.root()
  ..addAll([
    SimpleNode("0A")..add(SimpleNode("0A1A")),
    SimpleNode("0B"),
    SimpleNode("0C"),
  ]);

final nodesAddedTree = SimpleNode.root()
  ..addAll([
    SimpleNode("0A")..add(SimpleNode("0A1A")),
    SimpleNode("0B"),
    SimpleNode("0C"),
    SimpleNode("0D"),
    SimpleNode("0E"),
  ]);

final levelOneNodesAdded = SimpleNode.root()
  ..addAll([
    SimpleNode("0A")..add(SimpleNode("0A1A")),
    SimpleNode("0C")
      ..addAll([
        SimpleNode("0C1A"),
        SimpleNode("0C1B"),
        SimpleNode("0C1C")..addAll([SimpleNode("0C1C2A")]),
      ]),
    SimpleNode("0D"),
    SimpleNode("0E"),
  ]);

final levelTwoNodesAdded = SimpleNode.root()
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
    SimpleNode("0D"),
    SimpleNode("0E"),
  ]);

final nodesRemoved = SimpleNode.root()
  ..addAll([
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

final levelOneNodesRemoved = SimpleNode.root()
  ..addAll([
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

final levelTwoNodesRemoved = SimpleNode.root()
  ..addAll([
    SimpleNode("0C")
      ..addAll([
        SimpleNode("0C1C")
          ..addAll([
            SimpleNode("0C1C2A")
              ..addAll([
                SimpleNode("0C1C2A3C"),
              ]),
          ]),
      ]),
  ]);
