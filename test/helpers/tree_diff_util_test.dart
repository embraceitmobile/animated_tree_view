import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:animated_tree_view/src/tree_diff/tree_diff_update.dart';
import 'package:animated_tree_view/src/tree_diff/tree_diff_util.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mocks/mock_indexed_trees.dart';
import '../mocks/mock_trees.dart';

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

      final result = calculateTreeDiff<Node>(tree1, tree2);
      expect(result.length, 1);
      expect(result.first, isA<NodeAdd>());
      expect(((result.first as NodeAdd).data as SimpleNode).key, 'd');
    });

    test("Correct data is notified on removing a new node at single level", () {
      final tree1 = SimpleNode.root()
        ..addAll([
          SimpleNode("a"),
          SimpleNode("b"),
          SimpleNode("c"),
          SimpleNode("d")
        ]);
      final tree2 = SimpleNode.root()
        ..addAll([SimpleNode("a"), SimpleNode("b"), SimpleNode("c")]);

      final result = calculateTreeDiff<Node>(tree1, tree2);
      expect(result.length, 1);
      expect(result.first, isA<NodeRemove>());
      expect(((result.first as NodeRemove).data as SimpleNode).key, 'd');
    });

    test(
        "Correct data is notified on simultaneous inserting and removing a new node at single level",
        () {
      final tree1 = SimpleNode.root()
        ..addAll([SimpleNode("a"), SimpleNode("b"), SimpleNode("c")]);
      final tree2 = SimpleNode.root()
        ..addAll([SimpleNode("b"), SimpleNode("c"), SimpleNode("d")]);

      final result = calculateTreeDiff<Node>(tree1, tree2);
      expect(result.length, 2);

      expect(result.first, isA<NodeAdd>());
      expect(((result.first as NodeAdd).data as SimpleNode).key, 'd');
      expect(result.last, isA<NodeRemove>());
      expect(((result.last as NodeRemove).data as SimpleNode).key, 'a');
    });

    test("Correct data is notified on inserting a new node at double level",
        () {
      final tree1 = SimpleNode.root()
        ..addAll([SimpleNode("a"), SimpleNode("b"), SimpleNode("c")]);

      final tree2 = SimpleNode.root()
        ..addAll([
          SimpleNode("a"),
          SimpleNode("b"),
          SimpleNode("c")..addAll([SimpleNode("c1")]),
        ]);

      final result = calculateTreeDiff<Node>(tree1, tree2);
      expect(result.length, 1);
      expect(result.first, isA<NodeAdd>());
      expect(((result.first as NodeAdd).data as SimpleNode).path, "/.c.c1");
    });

    test("Correct data is notified on removing a node at double level", () {
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

      final result = calculateTreeDiff<Node>(tree1, tree2);
      expect(result.length, 1);
      expect(result.first, isA<NodeRemove>());
      expect(((result.first as NodeRemove).data as SimpleNode).path, "/.c.c1");
    });

    test(
        "Correct data is notified on inserting and removing a node at double level",
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

      final result = calculateTreeDiff<Node>(tree1, tree2);
      expect(result.length, 2);
      expect(result.first, isA<NodeAdd>());
      expect(((result.first as NodeAdd).data as SimpleNode).path, "/.a.a1");
      expect(result.last, isA<NodeRemove>());
      expect(((result.last as NodeRemove).data as SimpleNode).path, "/.c.c1");
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

      final result = calculateTreeDiff<Node>(tree1, tree2);
      expect(result.length, 2);
      expect(result.first, isA<NodeAdd>());
      expect(((result.first as NodeAdd).data as SimpleNode).path, "/.b.b1");
      expect(result.last, isA<NodeAdd>());
      expect(((result.last as NodeAdd).data as SimpleNode).path, "/.c.c1");
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

      final result = calculateTreeDiff<Node>(tree1, tree2);
      expect(result.length, 1);
      expect(result.first, isA<NodeAdd>());
      expect(
          ((result.first as NodeAdd).data as SimpleNode).path, "/.c.c1.c1-1");
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

      final result = calculateTreeDiff<Node>(tree1, tree2);
      expect(result.length, 1);
      expect(result.first, isA<NodeRemove>());
      expect(((result.first as NodeRemove).data as SimpleNode).path,
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

      final result = calculateTreeDiff<IndexedNode>(tree1, tree2);
      expect(result.length, 1);
      expect(result.first, isA<NodeInsert>());
      expect((result.first as NodeInsert).position, 3);
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

      final result = calculateTreeDiff<IndexedNode>(tree1, tree2);
      expect(result.length, 1);
      expect(result.first, isA<NodeRemove>());
      expect((result.first as NodeRemove).position, 3);
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

      final result = calculateTreeDiff<IndexedNode>(tree1, tree2);
      expect(result.length, 2);

      expect(result.first, isA<NodeInsert>());
      expect((result.first as NodeInsert).position, 3);
      expect(result.last, isA<NodeRemove>());
      expect((result.last as NodeRemove).position, 0);
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

      final result = calculateTreeDiff<IndexedNode>(tree1, tree2);
      expect(result.length, 1);
      expect(result.first, isA<NodeInsert>());
      expect(((result.first as NodeInsert).data as SimpleIndexedNode).path,
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

      final result = calculateTreeDiff<IndexedNode>(tree1, tree2);
      expect(result.length, 1);
      expect(result.first, isA<NodeRemove>());
      expect(((result.first as NodeRemove).data as SimpleIndexedNode).path,
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

      final result = calculateTreeDiff<IndexedNode>(tree1, tree2);
      expect(result.length, 2);
      expect(result.first, isA<NodeInsert>());
      expect(((result.first as NodeInsert).data as SimpleIndexedNode).path,
          "/.a.a1");
      expect(result.last, isA<NodeRemove>());
      expect(((result.last as NodeRemove).data as SimpleIndexedNode).path,
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

      final result = calculateTreeDiff<IndexedNode>(tree1, tree2);
      expect(result.length, 2);
      expect(result.first, isA<NodeInsert>());
      expect(((result.first as NodeInsert).data as SimpleIndexedNode).path,
          "/.b.b1");
      expect(result.last, isA<NodeInsert>());
      expect(((result.last as NodeInsert).data as SimpleIndexedNode).path,
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

      final result = calculateTreeDiff<IndexedNode>(tree1, tree2);
      expect(result.length, 1);
      expect(result.first, isA<NodeInsert>());
      expect(((result.first as NodeInsert).data as SimpleIndexedNode).path,
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

      final result = calculateTreeDiff<IndexedNode>(tree1, tree2);
      expect(result.length, 1);
      expect(result.first, isA<NodeRemove>());
      expect(((result.first as NodeRemove).data as SimpleIndexedNode).path,
          "/.c.c1.c1-1");
    });
  });

  group("Test multiple tree modifications", () {
    test("Test correct result is returned on adding nodes", () {
      final result = calculateTreeDiff<Node>(defaultTree, nodesAddedTree);
      expect(result.length, 2);
      expect(result.first, isA<NodeAdd>());
      expect(result.last, isA<NodeAdd>());
      expect((result.first as NodeAdd).data.key, "0D");
      expect((result.last as NodeAdd).data.key, "0E");
    });

    test("Test correct result is returned on removing nodes", () {
      final result = calculateTreeDiff<Node>(nodesAddedTree, nodesRemovedTree);
      expect(result.length, 3);
      expect(result.first, isA<NodeRemove>());
      expect(result.last, isA<NodeRemove>());
      expect((result.first as NodeRemove).data.key, "0B");
      expect((result.last as NodeRemove).data.key, "0E");
    });

    test("Test correct result is returned on removing nodes on level 1", () {
      final result = calculateTreeDiff<Node>(
          nodesRemovedTree, nodesLevelOneChildRemovedTree);
      expect(result.length, 2);
      expect(result.first, isA<NodeRemove>());
      expect(result.last, isA<NodeRemove>());
      expect((result.first as NodeRemove).data.key, "0C1A");
      expect((result.first as NodeRemove).data.path, "/.0C.0C1A");
      expect((result.last as NodeRemove).data.key, "0C1B");
      expect((result.last as NodeRemove).data.path, "/.0C.0C1B");
    });

    test("Test correct result is returned on removing nodes on level 2", () {
      final result = calculateTreeDiff<Node>(
          nodesLevelOneChildRemovedTree, nodesLevelTwoChildRemovedTree);
      expect(result.length, 2);
      expect(result.first, isA<NodeRemove>());
      expect(result.last, isA<NodeRemove>());
      expect((result.first as NodeRemove).data.key, "0C1C2A3B");
      expect(
          (result.first as NodeRemove).data.path, "/.0C.0C1C.0C1C2A.0C1C2A3B");
      expect((result.last as NodeRemove).data.key, "0C1C2A3C");
      expect(
          (result.last as NodeRemove).data.path, "/.0C.0C1C.0C1C2A.0C1C2A3C");
    });
  });

  group("Test multiple indexed tree modifications", () {
    test("Test correct result is returned on adding indexed nodes", () {
      final result = calculateTreeDiff<IndexedNode>(
          defaultIndexedTree, nodesAddedIndexedTree);
      expect(result.length, 2);
      expect(result.first, isA<NodeInsert>());
      expect(result.last, isA<NodeInsert>());
      expect((result.first as NodeInsert).data.key, "0E");
      expect((result.last as NodeInsert).data.key, "0D");
    });

    test("Test correct result is returned on removing indexed nodes", () {
      final result = calculateTreeDiff<IndexedNode>(
          nodesAddedIndexedTree, nodesRemovedIndexedTree);
      expect(result.length, 3);
      expect(result.first, isA<NodeRemove>());
      expect(result.last, isA<NodeRemove>());
      expect((result.first as NodeRemove).data.key, "0E");
      expect((result.last as NodeRemove).data.key, "0B");
    });

    test("Test correct result is returned on removing indexed nodes on level 1",
        () {
      final result = calculateTreeDiff<IndexedNode>(
          nodesRemovedIndexedTree, nodesLevelOneChildRemovedIndexedTree);
      expect(result.length, 2);
      expect(result.first, isA<NodeRemove>());
      expect(result.last, isA<NodeRemove>());
      expect((result.first as NodeRemove).data.key, "0C1B");
      expect((result.first as NodeRemove).data.path, "/.0C.0C1B");
      expect((result.last as NodeRemove).data.key, "0C1A");
      expect((result.last as NodeRemove).data.path, "/.0C.0C1A");
    });

    test("Test correct result is returned on removing indexed nodes on level 2",
        () {
      final result = calculateTreeDiff<IndexedNode>(
          nodesLevelOneChildRemovedIndexedTree,
          nodesLevelTwoChildRemovedIndexedTree);
      expect(result.length, 2);
      expect(result.first, isA<NodeRemove>());

      expect((result.first as NodeRemove).data.key, "0C1C2A3C");
      expect(
        (result.first as NodeRemove).data.path,
        "/.0C.0C1C.0C1C2A.0C1C2A3C",
      );
      expect(result.last, isA<NodeRemove>());
      expect((result.last as NodeRemove).data.key, "0C1C2A3B");
      expect(
        (result.last as NodeRemove).data.path,
        "/.0C.0C1C.0C1C2A.0C1C2A3B",
      );
    });
  });
}
