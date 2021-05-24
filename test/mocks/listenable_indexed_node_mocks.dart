import 'package:tree_structure_view/listenable_node/listenable_indexed_node.dart';

ListenableIndexedNode get mockListenableIndexedNode1 =>
    ListenableIndexedNode.root()
      ..addAll([
        ListenableIndexedNode(key: "0A")
          ..add(ListenableIndexedNode(key: "0A1A")),
        ListenableIndexedNode(key: "0B"),
        ListenableIndexedNode(key: "0C")
          ..addAll([
            ListenableIndexedNode(key: "0C1A"),
            ListenableIndexedNode(key: "0C1B"),
            ListenableIndexedNode(key: "0C1C")
              ..addAll([
                ListenableIndexedNode(key: "0C1C2A")
                  ..addAll([
                    ListenableIndexedNode(key: "0C1C2A3A"),
                    ListenableIndexedNode(key: "0C1C2A3B"),
                    ListenableIndexedNode(key: "0C1C2A3C"),
                  ]),
              ]),
          ]),
      ]);

ListenableIndexedNode get mockListenableIndexedNode2 =>
    ListenableIndexedNode(key: "M2")
      ..addAll([
        ListenableIndexedNode(key: "0A")
          ..add(ListenableIndexedNode(key: "0A1A")),
        ListenableIndexedNode(key: "0B"),
        ListenableIndexedNode(key: "0C")
          ..addAll([
            ListenableIndexedNode(key: "0C1A"),
            ListenableIndexedNode(key: "0C1B"),
            ListenableIndexedNode(key: "0C1C")
              ..addAll([
                ListenableIndexedNode(key: "0C1C2A")
                  ..addAll([
                    ListenableIndexedNode(key: "0C1C2A3A"),
                    ListenableIndexedNode(key: "0C1C2A3B"),
                    ListenableIndexedNode(key: "0C1C2A3C"),
                  ]),
              ]),
          ]),
      ]);

ListenableIndexedNode get mockListenableIndexedNode3 =>
    ListenableIndexedNode(key: "M3")
      ..addAll([
        ListenableIndexedNode(key: "0A")
          ..add(ListenableIndexedNode(key: "0A1A")),
        ListenableIndexedNode(key: "0B"),
        ListenableIndexedNode(key: "0C")
          ..addAll([
            ListenableIndexedNode(key: "0C1A"),
            ListenableIndexedNode(key: "0C1B"),
            ListenableIndexedNode(key: "0C1C")
              ..addAll([
                ListenableIndexedNode(key: "0C1C2A")
                  ..addAll([
                    ListenableIndexedNode(key: "0C1C2A3A"),
                    ListenableIndexedNode(key: "0C1C2A3B"),
                    ListenableIndexedNode(key: "0C1C2A3C"),
                  ]),
              ]),
          ]),
      ]);
