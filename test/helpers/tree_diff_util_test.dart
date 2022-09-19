import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:animated_tree_view/src/helpers/tree_diff_util.dart';
import 'package:diffutil_dart/diffutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Test Node diff returns correct updates", () {
    test(
        "Correct position and data is notified on inserting a new node at single level",
        () {
      final tree1 = SimpleNode.root()
        ..addAll([SimpleNode("a"), SimpleNode("b"), SimpleNode("c")]);
      final tree2 = SimpleNode.root()
        ..addAll([
          SimpleNode("a"),
          SimpleNode("b"),
          SimpleNode("c"),
          SimpleNode("d")
        ]);

      final result = calculateTreeDiff(tree1, tree2);
      expect(result.length, 1);
      expect(result.first, isA<DataInsert>());
      expect(((result.first as DataInsert).data as SimpleNode).key, 'd');
    });

    test(
        "Correct position and data is notified on removing a new node at single level",
        () {
      final tree1 = SimpleNode.root()
        ..addAll([
          SimpleNode("a"),
          SimpleNode("b"),
          SimpleNode("c"),
          SimpleNode("d")
        ]);
      final tree2 = SimpleNode.root()
        ..addAll([SimpleNode("a"), SimpleNode("b"), SimpleNode("c")]);

      final result = calculateTreeDiff(tree1, tree2);
      expect(result.length, 1);
      expect(result.first, isA<DataRemove>());
      expect(((result.first as DataRemove).data as SimpleNode).key, 'd');
    });

    test(
        "Correct position and data is notified on simultaneous inserting and removing a new node at single level",
        () {
      final tree1 = SimpleNode.root()
        ..addAll([SimpleNode("a"), SimpleNode("b"), SimpleNode("c")]);
      final tree2 = SimpleNode.root()
        ..addAll([SimpleNode("b"), SimpleNode("c"), SimpleNode("d")]);

      final result = calculateTreeDiff(tree1, tree2);
      expect(result.length, 2);

      expect(result.first, isA<DataInsert>());
      expect(((result.first as DataInsert).data as SimpleNode).key, 'd');
      expect(result.last, isA<DataRemove>());
      expect(((result.last as DataRemove).data as SimpleNode).key, 'a');
    });

    test(
        "Correct position and data is notified on inserting a new node at double level",
        () {
      final tree1 = SimpleNode.root()
        ..addAll([SimpleNode("a"), SimpleNode("b"), SimpleNode("c")]);

      final tree2 = SimpleNode.root()
        ..addAll([
          SimpleNode("a"),
          SimpleNode("b"),
          SimpleNode("c")..addAll([SimpleNode("c1")]),
        ]);

      final result = calculateTreeDiff(tree1, tree2);
      expect(result.length, 1);
      expect(result.first, isA<DataInsert>());
      expect(((result.first as DataInsert).data as SimpleNode).path, "/.c.c1");
    });

    test(
        "Correct position and data is notified on removing a node at double level",
        () {
      final tree1 = SimpleNode.root()
        ..addAll([
          SimpleNode("a"),
          SimpleNode("b"),
          SimpleNode("c")..addAll([SimpleNode("c1")])
        ]);

      final tree2 = SimpleNode.root()
        ..addAll([
          SimpleNode("a"),
          SimpleNode("b"),
          SimpleNode("c"),
        ]);

      final result = calculateTreeDiff(tree1, tree2);
      expect(result.length, 1);
      expect(result.first, isA<DataRemove>());
      expect(((result.first as DataRemove).data as SimpleNode).path, "/.c.c1");
    });

    test(
        "Correct position and data is notified on inserting and removing a node at double level",
        () {
      final tree1 = SimpleNode.root()
        ..addAll([
          SimpleNode("a"),
          SimpleNode("b"),
          SimpleNode("c")..addAll([SimpleNode("c1")]),
        ]);

      final tree2 = SimpleNode.root()
        ..addAll([
          SimpleNode("a")..addAll([SimpleNode("a1")]),
          SimpleNode("b"),
          SimpleNode("c"),
        ]);

      final result = calculateTreeDiff(tree1, tree2);
      expect(result.length, 2);
      expect(result.first, isA<DataInsert>());
      expect(((result.first as DataInsert).data as SimpleNode).path, "/.a.a1");
      expect(result.last, isA<DataRemove>());
      expect(((result.last as DataRemove).data as SimpleNode).path, "/.c.c1");
    });

    test(
        "Correct position and data is notified on inserting a nodes at double level",
        () {
      final tree1 = SimpleNode.root()
        ..addAll([SimpleNode("a"), SimpleNode("b"), SimpleNode("c")]);

      final tree2 = SimpleNode.root()
        ..addAll([
          SimpleNode("a"),
          SimpleNode("b")
            ..addAll([
              SimpleNode("b1")
                ..addAll([
                  SimpleNode("b1-1")..addAll([SimpleNode("b1-1-1")])
                ])
            ]),
          SimpleNode("c")..addAll([SimpleNode("c1")]),
        ]);

      final result = calculateTreeDiff(tree1, tree2);
      expect(result.length, 2);
      expect(result.first, isA<DataInsert>());
      expect(((result.first as DataInsert).data as SimpleNode).path, "/.b.b1");
      expect(result.last, isA<DataInsert>());
      expect(((result.last as DataInsert).data as SimpleNode).path, "/.c.c1");
    });

    test(
        "Correct position and data is notified on inserting a new node at third level",
        () {
      final tree1 = SimpleNode.root()
        ..addAll([
          SimpleNode("a"),
          SimpleNode("b"),
          SimpleNode("c")..addAll([SimpleNode("c1")]),
        ]);

      final tree2 = SimpleNode.root()
        ..addAll([
          SimpleNode("a"),
          SimpleNode("b"),
          SimpleNode("c")
            ..addAll([
              SimpleNode("c1")..addAll([SimpleNode("c1-1")]),
            ]),
        ]);

      final result = calculateTreeDiff(tree1, tree2);
      expect(result.length, 1);
      expect(result.first, isA<DataInsert>());
      expect(((result.first as DataInsert).data as SimpleNode).path,
          "/.c.c1.c1-1");
    });

    test(
        "Correct position and data is notified on removing a node at third level",
        () {
      final tree1 = SimpleNode.root()
        ..addAll([
          SimpleNode("a"),
          SimpleNode("b"),
          SimpleNode("c")
            ..addAll([
              SimpleNode("c1")..addAll([SimpleNode("c1-1")]),
            ]),
        ]);

      final tree2 = SimpleNode.root()
        ..addAll([
          SimpleNode("a"),
          SimpleNode("b"),
          SimpleNode("c")..addAll([SimpleNode("c1")]),
        ]);

      final result = calculateTreeDiff(tree1, tree2);
      expect(result.length, 1);
      expect(result.first, isA<DataRemove>());
      expect(((result.first as DataRemove).data as SimpleNode).path,
          "/.c.c1.c1-1");
    });
  });

  group("Test Indexed Node diff returns correct updates", () {
    test(
        "Correct position and data is notified on inserting a new node at single level",
        () {
      final tree1 = SimpleIndexedNode.root()
        ..addAll([
          SimpleIndexedNode("a"),
          SimpleIndexedNode("b"),
          SimpleIndexedNode("c")
        ]);
      final tree2 = SimpleIndexedNode.root()
        ..addAll([
          SimpleIndexedNode("a"),
          SimpleIndexedNode("b"),
          SimpleIndexedNode("c"),
          SimpleIndexedNode("d")
        ]);

      final result = calculateTreeDiff(tree1, tree2);
      expect(result.length, 1);
      expect(result.first, isA<DataInsert>());
      expect((result.first as DataInsert).position, 3);
    });

    test(
        "Correct position and data is notified on removing a new node at single level",
        () {
      final tree1 = SimpleIndexedNode.root()
        ..addAll([
          SimpleIndexedNode("a"),
          SimpleIndexedNode("b"),
          SimpleIndexedNode("c"),
          SimpleIndexedNode("d")
        ]);
      final tree2 = SimpleIndexedNode.root()
        ..addAll([
          SimpleIndexedNode("a"),
          SimpleIndexedNode("b"),
          SimpleIndexedNode("c")
        ]);

      final result = calculateTreeDiff(tree1, tree2);
      expect(result.length, 1);
      expect(result.first, isA<DataRemove>());
      expect((result.first as DataRemove).position, 3);
    });

    test(
        "Correct position and data is notified on simultaneous inserting and removing a new node at single level",
        () {
      final tree1 = SimpleIndexedNode.root()
        ..addAll([
          SimpleIndexedNode("a"),
          SimpleIndexedNode("b"),
          SimpleIndexedNode("c")
        ]);
      final tree2 = SimpleIndexedNode.root()
        ..addAll([
          SimpleIndexedNode("b"),
          SimpleIndexedNode("c"),
          SimpleIndexedNode("d")
        ]);

      final result = calculateTreeDiff(tree1, tree2);
      expect(result.length, 2);

      expect(result.first, isA<DataInsert>());
      expect((result.first as DataInsert).position, 3);
      expect(result.last, isA<DataRemove>());
      expect((result.last as DataRemove).position, 0);
    });

    test(
        "Correct position and data is notified on inserting a new node at double level",
        () {
      final tree1 = SimpleIndexedNode.root()
        ..addAll([
          SimpleIndexedNode("a"),
          SimpleIndexedNode("b"),
          SimpleIndexedNode("c")
        ]);

      final tree2 = SimpleIndexedNode.root()
        ..addAll([
          SimpleIndexedNode("a"),
          SimpleIndexedNode("b"),
          SimpleIndexedNode("c")..addAll([SimpleIndexedNode("c1")]),
        ]);

      final result = calculateTreeDiff(tree1, tree2);
      expect(result.length, 1);
      expect(result.first, isA<DataInsert>());
      expect(((result.first as DataInsert).data as SimpleIndexedNode).path,
          "/.c.c1");
    });

    test(
        "Correct position and data is notified on removing a node at double level",
        () {
      final tree1 = SimpleIndexedNode.root()
        ..addAll([
          SimpleIndexedNode("a"),
          SimpleIndexedNode("b"),
          SimpleIndexedNode("c")..addAll([SimpleIndexedNode("c1")])
        ]);

      final tree2 = SimpleIndexedNode.root()
        ..addAll([
          SimpleIndexedNode("a"),
          SimpleIndexedNode("b"),
          SimpleIndexedNode("c"),
        ]);

      final result = calculateTreeDiff(tree1, tree2);
      expect(result.length, 1);
      expect(result.first, isA<DataRemove>());
      expect(((result.first as DataRemove).data as SimpleIndexedNode).path,
          "/.c.c1");
    });

    test(
        "Correct position and data is notified on inserting and removing a node at double level",
        () {
      final tree1 = SimpleIndexedNode.root()
        ..addAll([
          SimpleIndexedNode("a"),
          SimpleIndexedNode("b"),
          SimpleIndexedNode("c")..addAll([SimpleIndexedNode("c1")]),
        ]);

      final tree2 = SimpleIndexedNode.root()
        ..addAll([
          SimpleIndexedNode("a")..addAll([SimpleIndexedNode("a1")]),
          SimpleIndexedNode("b"),
          SimpleIndexedNode("c"),
        ]);

      final result = calculateTreeDiff(tree1, tree2);
      expect(result.length, 2);
      expect(result.first, isA<DataInsert>());
      expect(((result.first as DataInsert).data as SimpleIndexedNode).path,
          "/.a.a1");
      expect(result.last, isA<DataRemove>());
      expect(((result.last as DataRemove).data as SimpleIndexedNode).path,
          "/.c.c1");
    });

    test(
        "Correct position and data is notified on inserting a nodes at double level",
        () {
      final tree1 = SimpleIndexedNode.root()
        ..addAll([
          SimpleIndexedNode("a"),
          SimpleIndexedNode("b"),
          SimpleIndexedNode("c")
        ]);

      final tree2 = SimpleIndexedNode.root()
        ..addAll([
          SimpleIndexedNode("a"),
          SimpleIndexedNode("b")
            ..addAll([
              SimpleIndexedNode("b1")
                ..addAll([
                  SimpleIndexedNode("b1-1")
                    ..addAll([SimpleIndexedNode("b1-1-1")])
                ])
            ]),
          SimpleIndexedNode("c")..addAll([SimpleIndexedNode("c1")]),
        ]);

      final result = calculateTreeDiff(tree1, tree2);
      expect(result.length, 2);
      expect(result.first, isA<DataInsert>());
      expect(((result.first as DataInsert).data as SimpleIndexedNode).path,
          "/.b.b1");
      expect(result.last, isA<DataInsert>());
      expect(((result.last as DataInsert).data as SimpleIndexedNode).path,
          "/.c.c1");
    });

    test(
        "Correct position and data is notified on inserting a new node at third level",
        () {
      final tree1 = SimpleIndexedNode.root()
        ..addAll([
          SimpleIndexedNode("a"),
          SimpleIndexedNode("b"),
          SimpleIndexedNode("c")..addAll([SimpleIndexedNode("c1")]),
        ]);

      final tree2 = SimpleIndexedNode.root()
        ..addAll([
          SimpleIndexedNode("a"),
          SimpleIndexedNode("b"),
          SimpleIndexedNode("c")
            ..addAll([
              SimpleIndexedNode("c1")..addAll([SimpleIndexedNode("c1-1")]),
            ]),
        ]);

      final result = calculateTreeDiff(tree1, tree2);
      expect(result.length, 1);
      expect(result.first, isA<DataInsert>());
      expect(((result.first as DataInsert).data as SimpleIndexedNode).path,
          "/.c.c1.c1-1");
    });

    test(
        "Correct position and data is notified on removing a node at third level",
        () {
      final tree1 = SimpleIndexedNode.root()
        ..addAll([
          SimpleIndexedNode("a"),
          SimpleIndexedNode("b"),
          SimpleIndexedNode("c")
            ..addAll([
              SimpleIndexedNode("c1")..addAll([SimpleIndexedNode("c1-1")]),
            ]),
        ]);

      final tree2 = SimpleIndexedNode.root()
        ..addAll([
          SimpleIndexedNode("a"),
          SimpleIndexedNode("b"),
          SimpleIndexedNode("c")..addAll([SimpleIndexedNode("c1")]),
        ]);

      final result = calculateTreeDiff(tree1, tree2);
      expect(result.length, 1);
      expect(result.first, isA<DataRemove>());
      expect(((result.first as DataRemove).data as SimpleIndexedNode).path,
          "/.c.c1.c1-1");
    });
  });
}
