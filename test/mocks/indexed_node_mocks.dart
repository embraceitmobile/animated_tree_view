import 'package:animated_tree_view/animated_tree_view.dart';

IndexedNode get mockIndexedNode1 => IndexedNode.root()
  ..addAll([
    IndexedNode(key: "0A")..add(IndexedNode(key: "0A1A")),
    IndexedNode(key: "0B"),
    IndexedNode(key: "0C")
      ..addAll([
        IndexedNode(key: "0C1A"),
        IndexedNode(key: "0C1B"),
        IndexedNode(key: "0C1C")
          ..addAll([
            IndexedNode(key: "0C1C2A")
              ..addAll([
                IndexedNode(key: "0C1C2A3A"),
                IndexedNode(key: "0C1C2A3B"),
                IndexedNode(key: "0C1C2A3C"),
              ]),
          ]),
      ]),
  ]);

IndexedNode get mockIndexedNode2 => IndexedNode(key: "M2")
  ..addAll([
    IndexedNode(key: "0A")..add(IndexedNode(key: "0A1A")),
    IndexedNode(key: "0B"),
    IndexedNode(key: "0C")
      ..addAll([
        IndexedNode(key: "0C1A"),
        IndexedNode(key: "0C1B"),
        IndexedNode(key: "0C1C")
          ..addAll([
            IndexedNode(key: "0C1C2A")
              ..addAll([
                IndexedNode(key: "0C1C2A3A"),
                IndexedNode(key: "0C1C2A3B"),
                IndexedNode(key: "0C1C2A3C"),
              ]),
          ]),
      ]),
  ]);

IndexedNode get mockIndexedNode3 => IndexedNode(key: "M3")
  ..addAll([
    IndexedNode(key: "0A")..add(IndexedNode(key: "0A1A")),
    IndexedNode(key: "0B"),
    IndexedNode(key: "0C")
      ..addAll([
        IndexedNode(key: "0C1A"),
        IndexedNode(key: "0C1B"),
        IndexedNode(key: "0C1C")
          ..addAll([
            IndexedNode(key: "0C1C2A")
              ..addAll([
                IndexedNode(key: "0C1C2A3A"),
                IndexedNode(key: "0C1C2A3B"),
                IndexedNode(key: "0C1C2A3C"),
              ]),
          ]),
      ]),
  ]);

IndexedNode get mockNoRootIndexedNode1 => IndexedNode(key: "M1")
  ..addAll([
    IndexedNode(key: "0A")..add(IndexedNode(key: "0A1A")),
    IndexedNode(key: "0B"),
    IndexedNode(key: "0C")
      ..addAll([
        IndexedNode(key: "0C1A"),
        IndexedNode(key: "0C1B"),
        IndexedNode(key: "0C1C")
          ..addAll([
            IndexedNode(key: "0C1C2A")
              ..addAll([
                IndexedNode(key: "0C1C2A3A"),
                IndexedNode(key: "0C1C2A3B"),
                IndexedNode(key: "0C1C2A3C"),
              ]),
          ]),
      ]),
  ]);

IndexedNode get mockNoRootIndexedNode2 => IndexedNode(key: "M2")
  ..addAll([
    IndexedNode(key: "0A")..add(IndexedNode(key: "0A1A")),
    IndexedNode(key: "0B"),
    IndexedNode(key: "0C")
      ..addAll([
        IndexedNode(key: "0C1A"),
        IndexedNode(key: "0C1B"),
        IndexedNode(key: "0C1C")
          ..addAll([
            IndexedNode(key: "0C1C2A")
              ..addAll([
                IndexedNode(key: "0C1C2A3A"),
                IndexedNode(key: "0C1C2A3B"),
                IndexedNode(key: "0C1C2A3C"),
              ]),
          ]),
      ]),
  ]);

IndexedNode get mockNoRootIndexedNode3 => IndexedNode(key: "M3")
  ..addAll([
    IndexedNode(key: "0A")..add(IndexedNode(key: "0A1A")),
    IndexedNode(key: "0B"),
    IndexedNode(key: "0C")
      ..addAll([
        IndexedNode(key: "0C1A"),
        IndexedNode(key: "0C1B"),
        IndexedNode(key: "0C1C")
          ..addAll([
            IndexedNode(key: "0C1C2A")
              ..addAll([
                IndexedNode(key: "0C1C2A3A"),
                IndexedNode(key: "0C1C2A3B"),
                IndexedNode(key: "0C1C2A3C"),
              ]),
          ]),
      ]),
  ]);
