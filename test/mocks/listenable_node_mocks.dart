import 'package:animated_tree_view/animated_tree_view.dart';

ListenableNode get mockListenableNode1 => ListenableNode.root()
  ..addAll([
    ListenableNode(key: "0A")..add(ListenableNode(key: "0A1A")),
    ListenableNode(key: "0B"),
    ListenableNode(key: "0C")
      ..addAll([
        ListenableNode(key: "0C1A"),
        ListenableNode(key: "0C1B"),
        ListenableNode(key: "0C1C")
          ..addAll([
            ListenableNode(key: "0C1C2A")
              ..addAll([
                ListenableNode(key: "0C1C2A3A"),
                ListenableNode(key: "0C1C2A3B"),
                ListenableNode(key: "0C1C2A3C"),
              ]),
          ]),
      ]),
  ]);

ListenableNode get mockListenableNode2 => ListenableNode(key: "M2")
  ..addAll([
    ListenableNode(key: "0A")..add(ListenableNode(key: "0A1A")),
    ListenableNode(key: "0B"),
    ListenableNode(key: "0C")
      ..addAll([
        ListenableNode(key: "0C1A"),
        ListenableNode(key: "0C1B"),
        ListenableNode(key: "0C1C")
          ..addAll([
            ListenableNode(key: "0C1C2A")
              ..addAll([
                ListenableNode(key: "0C1C2A3A"),
                ListenableNode(key: "0C1C2A3B"),
                ListenableNode(key: "0C1C2A3C"),
              ]),
          ]),
      ]),
  ]);

ListenableNode get mockListenableNode3 => ListenableNode(key: "M3")
  ..addAll([
    ListenableNode(key: "0A")..add(ListenableNode(key: "0A1A")),
    ListenableNode(key: "0B"),
    ListenableNode(key: "0C")
      ..addAll([
        ListenableNode(key: "0C1A"),
        ListenableNode(key: "0C1B"),
        ListenableNode(key: "0C1C")
          ..addAll([
            ListenableNode(key: "0C1C2A")
              ..addAll([
                ListenableNode(key: "0C1C2A3A"),
                ListenableNode(key: "0C1C2A3B"),
                ListenableNode(key: "0C1C2A3C"),
              ]),
          ]),
      ]),
  ]);
