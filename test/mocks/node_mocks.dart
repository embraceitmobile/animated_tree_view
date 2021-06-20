import 'package:animated_tree_view/animated_tree_view.dart';

Node get mockNode1 => Node.root()
  ..addAll([
    Node(key: "0A")..add(Node(key: "0A1A")),
    Node(key: "0B"),
    Node(key: "0C")
      ..addAll([
        Node(key: "0C1A"),
        Node(key: "0C1B"),
        Node(key: "0C1C")
          ..addAll([
            Node(key: "0C1C2A")
              ..addAll([
                Node(key: "0C1C2A3A"),
                Node(key: "0C1C2A3B"),
                Node(key: "0C1C2A3C"),
              ]),
          ]),
      ]),
  ]);

Node get mockNode2 => Node(key: "M2")
  ..addAll([
    Node(key: "0A")..add(Node(key: "0A1A")),
    Node(key: "0B"),
    Node(key: "0C")
      ..addAll([
        Node(key: "0C1A"),
        Node(key: "0C1B"),
        Node(key: "0C1C")
          ..addAll([
            Node(key: "0C1C2A")
              ..addAll([
                Node(key: "0C1C2A3A"),
                Node(key: "0C1C2A3B"),
                Node(key: "0C1C2A3C"),
              ]),
          ]),
      ]),
  ]);

Node get mockNode3 => Node(key: "M3")
  ..addAll([
    Node(key: "0A")..add(Node(key: "0A1A")),
    Node(key: "0B"),
    Node(key: "0C")
      ..addAll([
        Node(key: "0C1A"),
        Node(key: "0C1B"),
        Node(key: "0C1C")
          ..addAll([
            Node(key: "0C1C2A")
              ..addAll([
                Node(key: "0C1C2A3A"),
                Node(key: "0C1C2A3B"),
                Node(key: "0C1C2A3C"),
              ]),
          ]),
      ]),
  ]);
