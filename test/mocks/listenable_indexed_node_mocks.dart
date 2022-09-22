import 'package:animated_tree_view/animated_tree_view.dart';

IndexedListenableNode get mockListenableIndexedNode1 =>
    IndexedListenableNode.root()
      ..addAll([
        IndexedListenableNode(key: "0A")
          ..add(IndexedListenableNode(key: "0A1A")),
        IndexedListenableNode(key: "0B"),
        IndexedListenableNode(key: "0C")
          ..addAll([
            IndexedListenableNode(key: "0C1A"),
            IndexedListenableNode(key: "0C1B"),
            IndexedListenableNode(key: "0C1C")
              ..addAll([
                IndexedListenableNode(key: "0C1C2A")
                  ..addAll([
                    IndexedListenableNode(key: "0C1C2A3A"),
                    IndexedListenableNode(key: "0C1C2A3B"),
                    IndexedListenableNode(key: "0C1C2A3C"),
                  ]),
              ]),
          ]),
      ]);

IndexedListenableNode get mockListenableIndexedNode2 =>
    IndexedListenableNode(key: "M2")
      ..addAll([
        IndexedListenableNode(key: "0A")
          ..add(IndexedListenableNode(key: "0A1A")),
        IndexedListenableNode(key: "0B"),
        IndexedListenableNode(key: "0C")
          ..addAll([
            IndexedListenableNode(key: "0C1A"),
            IndexedListenableNode(key: "0C1B"),
            IndexedListenableNode(key: "0C1C")
              ..addAll([
                IndexedListenableNode(key: "0C1C2A")
                  ..addAll([
                    IndexedListenableNode(key: "0C1C2A3A"),
                    IndexedListenableNode(key: "0C1C2A3B"),
                    IndexedListenableNode(key: "0C1C2A3C"),
                  ]),
              ]),
          ]),
      ]);

IndexedListenableNode get mockListenableIndexedNode3 =>
    IndexedListenableNode(key: "M3")
      ..addAll([
        IndexedListenableNode(key: "0A")
          ..add(IndexedListenableNode(key: "0A1A")),
        IndexedListenableNode(key: "0B"),
        IndexedListenableNode(key: "0C")
          ..addAll([
            IndexedListenableNode(key: "0C1A"),
            IndexedListenableNode(key: "0C1B"),
            IndexedListenableNode(key: "0C1C")
              ..addAll([
                IndexedListenableNode(key: "0C1C2A")
                  ..addAll([
                    IndexedListenableNode(key: "0C1C2A3A"),
                    IndexedListenableNode(key: "0C1C2A3B"),
                    IndexedListenableNode(key: "0C1C2A3C"),
                  ]),
              ]),
          ]),
      ]);

IndexedListenableNode get mockNoRootListenableIndexedNode1 =>
    IndexedListenableNode(key: "M1")
      ..addAll([
        IndexedListenableNode(key: "0A")
          ..add(IndexedListenableNode(key: "0A1A")),
        IndexedListenableNode(key: "0B"),
        IndexedListenableNode(key: "0C")
          ..addAll([
            IndexedListenableNode(key: "0C1A"),
            IndexedListenableNode(key: "0C1B"),
            IndexedListenableNode(key: "0C1C")
              ..addAll([
                IndexedListenableNode(key: "0C1C2A")
                  ..addAll([
                    IndexedListenableNode(key: "0C1C2A3A"),
                    IndexedListenableNode(key: "0C1C2A3B"),
                    IndexedListenableNode(key: "0C1C2A3C"),
                  ]),
              ]),
          ]),
      ]);

IndexedListenableNode get mockNoRootListenableIndexedNode2 =>
    IndexedListenableNode(key: "M2")
      ..addAll([
        IndexedListenableNode(key: "0A")
          ..add(IndexedListenableNode(key: "0A1A")),
        IndexedListenableNode(key: "0B"),
        IndexedListenableNode(key: "0C")
          ..addAll([
            IndexedListenableNode(key: "0C1A"),
            IndexedListenableNode(key: "0C1B"),
            IndexedListenableNode(key: "0C1C")
              ..addAll([
                IndexedListenableNode(key: "0C1C2A")
                  ..addAll([
                    IndexedListenableNode(key: "0C1C2A3A"),
                    IndexedListenableNode(key: "0C1C2A3B"),
                    IndexedListenableNode(key: "0C1C2A3C"),
                  ]),
              ]),
          ]),
      ]);

IndexedListenableNode get mockNoRootListenableIndexedNode3 =>
    IndexedListenableNode(key: "M3")
      ..addAll([
        IndexedListenableNode(key: "0A")
          ..add(IndexedListenableNode(key: "0A1A")),
        IndexedListenableNode(key: "0B"),
        IndexedListenableNode(key: "0C")
          ..addAll([
            IndexedListenableNode(key: "0C1A"),
            IndexedListenableNode(key: "0C1B"),
            IndexedListenableNode(key: "0C1C")
              ..addAll([
                IndexedListenableNode(key: "0C1C2A")
                  ..addAll([
                    IndexedListenableNode(key: "0C1C2A3A"),
                    IndexedListenableNode(key: "0C1C2A3B"),
                    IndexedListenableNode(key: "0C1C2A3C"),
                  ]),
              ]),
          ]),
      ]);
