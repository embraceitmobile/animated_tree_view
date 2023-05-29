import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:animated_tree_view/tree_diff/tree_diff_change.dart';
import 'package:animated_tree_view/tree_diff/tree_diff_util.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mocks/mock_indexed_trees.dart';
import '../mocks/mock_trees.dart';

void main() {
  group("Test Node diff returns correct updates", () {
    test(
        "Correct position and data is notified on inserting a new node at single level",
        () {
      final tree1 = TreeNode.root()
        ..addAll([TreeNode(key: "a"), TreeNode(key: "b"), TreeNode(key: "c")]);
      final tree2 = TreeNode.root()
        ..addAll([
          TreeNode(key: "a"),
          TreeNode(key: "b"),
          TreeNode(key: "c"),
          TreeNode(key: "d")
        ]);

      final result = calculateTreeDiff<TreeNode>(tree1, tree2);
      expect(result.length, 1);
      expect(result.first, isA<TreeDiffNodeAdd>());
      expect(((result.first as TreeDiffNodeAdd).data as TreeNode).key, 'd');
    });

    test("Correct data is notified on removing a new node at single level", () {
      final tree1 = TreeNode.root()
        ..addAll([
          TreeNode(key: "a"),
          TreeNode(key: "b"),
          TreeNode(key: "c"),
          TreeNode(key: "d")
        ]);
      final tree2 = TreeNode.root()
        ..addAll([TreeNode(key: "a"), TreeNode(key: "b"), TreeNode(key: "c")]);

      final result = calculateTreeDiff<TreeNode>(tree1, tree2);
      expect(result.length, 1);
      expect(result.first, isA<TreeDiffNodeRemove>());
      expect(((result.first as TreeDiffNodeRemove).data as TreeNode).key, 'd');
    });

    test(
        "Correct data is notified on simultaneous inserting and removing a new node at single level",
        () {
      final tree1 = TreeNode.root()
        ..addAll([TreeNode(key: "a"), TreeNode(key: "b"), TreeNode(key: "c")]);
      final tree2 = TreeNode.root()
        ..addAll([TreeNode(key: "b"), TreeNode(key: "c"), TreeNode(key: "d")]);

      final result = calculateTreeDiff<TreeNode>(tree1, tree2);
      expect(result.length, 2);

      expect(result.first, isA<TreeDiffNodeAdd>());
      expect(((result.first as TreeDiffNodeAdd).data as TreeNode).key, 'd');
      expect(result.last, isA<TreeDiffNodeRemove>());
      expect(((result.last as TreeDiffNodeRemove).data as TreeNode).key, 'a');
    });

    test("Correct data is notified on inserting a new node at double level",
        () {
      final tree1 = TreeNode.root()
        ..addAll([TreeNode(key: "a"), TreeNode(key: "b"), TreeNode(key: "c")]);

      final tree2 = TreeNode.root()
        ..addAll([
          TreeNode(key: "a"),
          TreeNode(key: "b"),
          TreeNode(key: "c")..addAll([TreeNode(key: "c1")]),
        ]);

      final result = calculateTreeDiff<TreeNode>(tree1, tree2);
      expect(result.length, 1);
      expect(result.first, isA<TreeDiffNodeAdd>());
      expect(
          ((result.first as TreeDiffNodeAdd).data as TreeNode).path, "/.c.c1");
    });

    test("Correct data is notified on removing a node at double level", () {
      final tree1 = TreeNode.root()
        ..addAll([
          TreeNode(key: "a"),
          TreeNode(key: "b"),
          TreeNode(key: "c")..addAll([TreeNode(key: "c1")])
        ]);

      final tree2 = TreeNode.root()
        ..addAll([
          TreeNode(key: "a"),
          TreeNode(key: "b"),
          TreeNode(key: "c"),
        ]);

      final result = calculateTreeDiff<TreeNode>(tree1, tree2);
      expect(result.length, 1);
      expect(result.first, isA<TreeDiffNodeRemove>());
      expect(((result.first as TreeDiffNodeRemove).data as TreeNode).path,
          "/.c.c1");
    });

    test(
        "Correct data is notified on inserting and removing a node at double level",
        () {
      final tree1 = TreeNode.root()
        ..addAll([
          TreeNode(key: "a"),
          TreeNode(key: "b"),
          TreeNode(key: "c")..addAll([TreeNode(key: "c1")]),
        ]);

      final tree2 = TreeNode.root()
        ..addAll([
          TreeNode(key: "a")..addAll([TreeNode(key: "a1")]),
          TreeNode(key: "b"),
          TreeNode(key: "c"),
        ]);

      final result = calculateTreeDiff<TreeNode>(tree1, tree2);
      expect(result.length, 2);
      expect(result.first, isA<TreeDiffNodeAdd>());
      expect(
          ((result.first as TreeDiffNodeAdd).data as TreeNode).path, "/.a.a1");
      expect(result.last, isA<TreeDiffNodeRemove>());
      expect(((result.last as TreeDiffNodeRemove).data as TreeNode).path,
          "/.c.c1");
    });

    test(
        "Correct position and data is notified on inserting a nodes at double level",
        () {
      final tree1 = TreeNode.root()
        ..addAll([TreeNode(key: "a"), TreeNode(key: "b"), TreeNode(key: "c")]);

      final tree2 = TreeNode.root()
        ..addAll([
          TreeNode(key: "a"),
          TreeNode(key: "b")
            ..addAll([
              TreeNode(key: "b1")
                ..addAll([
                  TreeNode(key: "b1-1")..addAll([TreeNode(key: "b1-1-1")])
                ])
            ]),
          TreeNode(key: "c")..addAll([TreeNode(key: "c1")]),
        ]);

      final result = calculateTreeDiff<TreeNode>(tree1, tree2);
      expect(result.length, 2);
      expect(result.first, isA<TreeDiffNodeAdd>());
      expect(
          ((result.first as TreeDiffNodeAdd).data as TreeNode).path, "/.b.b1");
      expect(result.last, isA<TreeDiffNodeAdd>());
      expect(
          ((result.last as TreeDiffNodeAdd).data as TreeNode).path, "/.c.c1");
    });

    test(
        "Correct position and data is notified on inserting a new node at third level",
        () {
      final tree1 = TreeNode.root()
        ..addAll([
          TreeNode(key: "a"),
          TreeNode(key: "b"),
          TreeNode(key: "c")..addAll([TreeNode(key: "c1")]),
        ]);

      final tree2 = TreeNode.root()
        ..addAll([
          TreeNode(key: "a"),
          TreeNode(key: "b"),
          TreeNode(key: "c")
            ..addAll([
              TreeNode(key: "c1")..addAll([TreeNode(key: "c1-1")]),
            ]),
        ]);

      final result = calculateTreeDiff<TreeNode>(tree1, tree2);
      expect(result.length, 1);
      expect(result.first, isA<TreeDiffNodeAdd>());
      expect(((result.first as TreeDiffNodeAdd).data as TreeNode).path,
          "/.c.c1.c1-1");
    });

    test(
        "Correct position and data is notified on removing a node at third level",
        () {
      final tree1 = TreeNode.root()
        ..addAll([
          TreeNode(key: "a"),
          TreeNode(key: "b"),
          TreeNode(key: "c")
            ..addAll([
              TreeNode(key: "c1")..addAll([TreeNode(key: "c1-1")]),
            ]),
        ]);

      final tree2 = TreeNode.root()
        ..addAll([
          TreeNode(key: "a"),
          TreeNode(key: "b"),
          TreeNode(key: "c")..addAll([TreeNode(key: "c1")]),
        ]);

      final result = calculateTreeDiff<TreeNode>(tree1, tree2);
      expect(result.length, 1);
      expect(result.first, isA<TreeDiffNodeRemove>());
      expect(((result.first as TreeDiffNodeRemove).data as TreeNode).path,
          "/.c.c1.c1-1");
    });
  });

  group("Test Indexed Node diff returns correct updates", () {
    test(
        "Correct position and data is notified on inserting a new node at single level",
        () {
      final tree1 = IndexedTreeNode.root()
        ..addAll([
          IndexedTreeNode(key: "a"),
          IndexedTreeNode(key: "b"),
          IndexedTreeNode(key: "c")
        ]);
      final tree2 = IndexedTreeNode.root()
        ..addAll([
          IndexedTreeNode(key: "a"),
          IndexedTreeNode(key: "b"),
          IndexedTreeNode(key: "c"),
          IndexedTreeNode(key: "d")
        ]);

      final result = calculateTreeDiff<IndexedTreeNode>(tree1, tree2);
      expect(result.length, 1);
      expect(result.first, isA<TreeDiffNodeInsert>());
      expect((result.first as TreeDiffNodeInsert).position, 3);
    });

    test(
        "Correct position and data is notified on removing a new node at single level",
        () {
      final tree1 = IndexedTreeNode.root()
        ..addAll([
          IndexedTreeNode(key: "a"),
          IndexedTreeNode(key: "b"),
          IndexedTreeNode(key: "c"),
          IndexedTreeNode(key: "d")
        ]);
      final tree2 = IndexedTreeNode.root()
        ..addAll([
          IndexedTreeNode(key: "a"),
          IndexedTreeNode(key: "b"),
          IndexedTreeNode(key: "c")
        ]);

      final result = calculateTreeDiff<IndexedTreeNode>(tree1, tree2);
      expect(result.length, 1);
      expect(result.first, isA<TreeDiffNodeRemove>());
      expect((result.first as TreeDiffNodeRemove).position, 3);
    });

    test(
        "Correct position and data is notified on simultaneous inserting and removing a new node at single level",
        () {
      final tree1 = IndexedTreeNode.root()
        ..addAll([
          IndexedTreeNode(key: "a"),
          IndexedTreeNode(key: "b"),
          IndexedTreeNode(key: "c")
        ]);
      final tree2 = IndexedTreeNode.root()
        ..addAll([
          IndexedTreeNode(key: "b"),
          IndexedTreeNode(key: "c"),
          IndexedTreeNode(key: "d")
        ]);

      final result = calculateTreeDiff<IndexedTreeNode>(tree1, tree2);
      expect(result.length, 2);

      expect(result.first, isA<TreeDiffNodeInsert>());
      expect((result.first as TreeDiffNodeInsert).position, 3);
      expect(result.last, isA<TreeDiffNodeRemove>());
      expect((result.last as TreeDiffNodeRemove).position, 0);
    });

    test(
        "Correct position and data is notified on inserting a new node at double level",
        () {
      final tree1 = IndexedTreeNode.root()
        ..addAll([
          IndexedTreeNode(key: "a"),
          IndexedTreeNode(key: "b"),
          IndexedTreeNode(key: "c")
        ]);

      final tree2 = IndexedTreeNode.root()
        ..addAll([
          IndexedTreeNode(key: "a"),
          IndexedTreeNode(key: "b"),
          IndexedTreeNode(key: "c")..addAll([IndexedTreeNode(key: "c1")]),
        ]);

      final result = calculateTreeDiff<IndexedTreeNode>(tree1, tree2);
      expect(result.length, 1);
      expect(result.first, isA<TreeDiffNodeInsert>());
      expect(
          ((result.first as TreeDiffNodeInsert).data as IndexedTreeNode).path,
          "/.c.c1");
    });

    test(
        "Correct position and data is notified on removing a node at double level",
        () {
      final tree1 = IndexedTreeNode.root()
        ..addAll([
          IndexedTreeNode(key: "a"),
          IndexedTreeNode(key: "b"),
          IndexedTreeNode(key: "c")..addAll([IndexedTreeNode(key: "c1")])
        ]);

      final tree2 = IndexedTreeNode.root()
        ..addAll([
          IndexedTreeNode(key: "a"),
          IndexedTreeNode(key: "b"),
          IndexedTreeNode(key: "c"),
        ]);

      final result = calculateTreeDiff<IndexedTreeNode>(tree1, tree2);
      expect(result.length, 1);
      expect(result.first, isA<TreeDiffNodeRemove>());
      expect(
          ((result.first as TreeDiffNodeRemove).data as IndexedTreeNode).path,
          "/.c.c1");
    });

    test(
        "Correct position and data is notified on inserting and removing a node at double level",
        () {
      final tree1 = IndexedTreeNode.root()
        ..addAll([
          IndexedTreeNode(key: "a"),
          IndexedTreeNode(key: "b"),
          IndexedTreeNode(key: "c")..addAll([IndexedTreeNode(key: "c1")]),
        ]);

      final tree2 = IndexedTreeNode.root()
        ..addAll([
          IndexedTreeNode(key: "a")..addAll([IndexedTreeNode(key: "a1")]),
          IndexedTreeNode(key: "b"),
          IndexedTreeNode(key: "c"),
        ]);

      final result = calculateTreeDiff<IndexedTreeNode>(tree1, tree2);
      expect(result.length, 2);
      expect(result.first, isA<TreeDiffNodeInsert>());
      expect(
          ((result.first as TreeDiffNodeInsert).data as IndexedTreeNode).path,
          "/.a.a1");
      expect(result.last, isA<TreeDiffNodeRemove>());
      expect(((result.last as TreeDiffNodeRemove).data as IndexedTreeNode).path,
          "/.c.c1");
    });

    test(
        "Correct position and data is notified on inserting a nodes at double level",
        () {
      final tree1 = IndexedTreeNode.root()
        ..addAll([
          IndexedTreeNode(key: "a"),
          IndexedTreeNode(key: "b"),
          IndexedTreeNode(key: "c")
        ]);

      final tree2 = IndexedTreeNode.root()
        ..addAll([
          IndexedTreeNode(key: "a"),
          IndexedTreeNode(key: "b")
            ..addAll([
              IndexedTreeNode(key: "b1")
                ..addAll([
                  IndexedTreeNode(key: "b1-1")
                    ..addAll([IndexedTreeNode(key: "b1-1-1")])
                ])
            ]),
          IndexedTreeNode(key: "c")..addAll([IndexedTreeNode(key: "c1")]),
        ]);

      final result = calculateTreeDiff<IndexedTreeNode>(tree1, tree2);
      expect(result.length, 2);
      expect(result.first, isA<TreeDiffNodeInsert>());
      expect(
          ((result.first as TreeDiffNodeInsert).data as IndexedTreeNode).path,
          "/.b.b1");
      expect(result.last, isA<TreeDiffNodeInsert>());
      expect(((result.last as TreeDiffNodeInsert).data as IndexedTreeNode).path,
          "/.c.c1");
    });

    test(
        "Correct position and data is notified on inserting a new node at third level",
        () {
      final tree1 = IndexedTreeNode.root()
        ..addAll([
          IndexedTreeNode(key: "a"),
          IndexedTreeNode(key: "b"),
          IndexedTreeNode(key: "c")..addAll([IndexedTreeNode(key: "c1")]),
        ]);

      final tree2 = IndexedTreeNode.root()
        ..addAll([
          IndexedTreeNode(key: "a"),
          IndexedTreeNode(key: "b"),
          IndexedTreeNode(key: "c")
            ..addAll([
              IndexedTreeNode(key: "c1")
                ..addAll([IndexedTreeNode(key: "c1-1")]),
            ]),
        ]);

      final result = calculateTreeDiff<IndexedTreeNode>(tree1, tree2);
      expect(result.length, 1);
      expect(result.first, isA<TreeDiffNodeInsert>());
      expect(
          ((result.first as TreeDiffNodeInsert).data as IndexedTreeNode).path,
          "/.c.c1.c1-1");
    });

    test(
        "Correct position and data is notified on removing a node at third level",
        () {
      final tree1 = IndexedTreeNode.root()
        ..addAll([
          IndexedTreeNode(key: "a"),
          IndexedTreeNode(key: "b"),
          IndexedTreeNode(key: "c")
            ..addAll([
              IndexedTreeNode(key: "c1")
                ..addAll([IndexedTreeNode(key: "c1-1")]),
            ]),
        ]);

      final tree2 = IndexedTreeNode.root()
        ..addAll([
          IndexedTreeNode(key: "a"),
          IndexedTreeNode(key: "b"),
          IndexedTreeNode(key: "c")..addAll([IndexedTreeNode(key: "c1")]),
        ]);

      final result = calculateTreeDiff<IndexedTreeNode>(tree1, tree2);
      expect(result.length, 1);
      expect(result.first, isA<TreeDiffNodeRemove>());
      expect(
          ((result.first as TreeDiffNodeRemove).data as IndexedTreeNode).path,
          "/.c.c1.c1-1");
    });
  });

  group("Test multiple tree modifications", () {
    test("Test correct result is returned on adding nodes", () {
      final result = calculateTreeDiff<TreeNode>(defaultTree, nodesAddedTree);
      expect(result.length, 2);
      expect(result.first, isA<TreeDiffNodeAdd>());
      expect(result.last, isA<TreeDiffNodeAdd>());
      expect((result.first as TreeDiffNodeAdd).data.key, "0D");
      expect((result.last as TreeDiffNodeAdd).data.key, "0E");
    });

    test("Test correct result is returned on removing nodes", () {
      final result =
          calculateTreeDiff<TreeNode>(nodesAddedTree, nodesRemovedTree);
      expect(result.length, 3);
      expect(result.first, isA<TreeDiffNodeRemove>());
      expect(result.last, isA<TreeDiffNodeRemove>());
      expect((result.first as TreeDiffNodeRemove).data.key, "0B");
      expect((result.last as TreeDiffNodeRemove).data.key, "0E");
    });

    test("Test correct result is returned on removing nodes on level 1", () {
      final result = calculateTreeDiff<TreeNode>(
          nodesRemovedTree, nodesLevelOneChildRemovedTree);
      expect(result.length, 2);
      expect(result.first, isA<TreeDiffNodeRemove>());
      expect(result.last, isA<TreeDiffNodeRemove>());
      expect((result.first as TreeDiffNodeRemove).data.key, "0C1A");
      expect((result.first as TreeDiffNodeRemove).data.path, "/.0C.0C1A");
      expect((result.last as TreeDiffNodeRemove).data.key, "0C1B");
      expect((result.last as TreeDiffNodeRemove).data.path, "/.0C.0C1B");
    });

    test("Test correct result is returned on removing nodes on level 2", () {
      final result = calculateTreeDiff<TreeNode>(
          nodesLevelOneChildRemovedTree, nodesLevelTwoChildRemovedTree);
      expect(result.length, 2);
      expect(result.first, isA<TreeDiffNodeRemove>());
      expect(result.last, isA<TreeDiffNodeRemove>());
      expect((result.first as TreeDiffNodeRemove).data.key, "0C1C2A3B");
      expect((result.first as TreeDiffNodeRemove).data.path,
          "/.0C.0C1C.0C1C2A.0C1C2A3B");
      expect((result.last as TreeDiffNodeRemove).data.key, "0C1C2A3C");
      expect((result.last as TreeDiffNodeRemove).data.path,
          "/.0C.0C1C.0C1C2A.0C1C2A3C");
    });
  });

  group("Test multiple indexed tree modifications", () {
    test("Test correct result is returned on adding indexed nodes", () {
      final result = calculateTreeDiff<IndexedTreeNode>(
          defaultIndexedTree, nodesAddedIndexedTree);
      expect(result.length, 2);
      expect(result.first, isA<TreeDiffNodeInsert>());
      expect(result.last, isA<TreeDiffNodeInsert>());
      expect((result.first as TreeDiffNodeInsert).data.key, "0E");
      expect((result.last as TreeDiffNodeInsert).data.key, "0D");
    });

    test("Test correct result is returned on removing indexed nodes", () {
      final result = calculateTreeDiff<IndexedTreeNode>(
          nodesAddedIndexedTree, nodesRemovedIndexedTree);
      expect(result.length, 3);
      expect(result.first, isA<TreeDiffNodeRemove>());
      expect(result.last, isA<TreeDiffNodeRemove>());
      expect((result.first as TreeDiffNodeRemove).data.key, "0E");
      expect((result.last as TreeDiffNodeRemove).data.key, "0B");
    });

    test("Test correct result is returned on removing indexed nodes on level 1",
        () {
      final result = calculateTreeDiff<IndexedTreeNode>(
          nodesRemovedIndexedTree, nodesLevelOneChildRemovedIndexedTree);
      expect(result.length, 2);
      expect(result.first, isA<TreeDiffNodeRemove>());
      expect(result.last, isA<TreeDiffNodeRemove>());
      expect((result.first as TreeDiffNodeRemove).data.key, "0C1B");
      expect((result.first as TreeDiffNodeRemove).data.path, "/.0C.0C1B");
      expect((result.last as TreeDiffNodeRemove).data.key, "0C1A");
      expect((result.last as TreeDiffNodeRemove).data.path, "/.0C.0C1A");
    });

    test("Test correct result is returned on removing indexed nodes on level 2",
        () {
      final result = calculateTreeDiff<IndexedTreeNode>(
          nodesLevelOneChildRemovedIndexedTree,
          nodesLevelTwoChildRemovedIndexedTree);
      expect(result.length, 2);
      expect(result.first, isA<TreeDiffNodeRemove>());

      expect((result.first as TreeDiffNodeRemove).data.key, "0C1C2A3C");
      expect(
        (result.first as TreeDiffNodeRemove).data.path,
        "/.0C.0C1C.0C1C2A.0C1C2A3C",
      );
      expect(result.last, isA<TreeDiffNodeRemove>());
      expect((result.last as TreeDiffNodeRemove).data.key, "0C1C2A3B");
      expect(
        (result.last as TreeDiffNodeRemove).data.path,
        "/.0C.0C1C.0C1C2A.0C1C2A3B",
      );
    });
  });

  group("Test nodes updates on tree", () {
    test("Test nodes updates on level 0", () {
      final tree1 = TreeNode.root()
        ..addAll([
          TreeNode(key: "a", data: "A"),
          TreeNode(key: "b", data: "B"),
          TreeNode(key: "c", data: "C")
        ]);

      final tree2 = TreeNode.root()
        ..addAll([
          TreeNode(key: "a", data: "A"),
          TreeNode(key: "b", data: "B"),
          TreeNode(key: "c", data: "C1")
        ]);

      final result = calculateTreeDiff<TreeNode>(tree1, tree2);
      expect(result.length, 1);
      expect(result.first, isA<TreeDiffNodeUpdate>());
      expect(((result.first as TreeDiffNodeUpdate).data as TreeNode).key, 'c');
      expect(
          ((result.first as TreeDiffNodeUpdate).data as TreeNode).data, 'C1');
    });

    test("Test nodes updates on level 1", () {
      final tree1 = TreeNode.root()
        ..addAll([
          TreeNode(key: "a", data: "A"),
          TreeNode(key: "b", data: "B"),
          TreeNode(key: "c", data: "C")
            ..addAll([TreeNode(key: "c1", data: "CC1")]),
        ]);

      final tree2 = TreeNode.root()
        ..addAll([
          TreeNode(key: "a", data: "A"),
          TreeNode(key: "b", data: "B"),
          TreeNode(key: "c", data: "C")
            ..addAll([TreeNode(key: "c1", data: "CC2")])
        ]);

      final result = calculateTreeDiff<TreeNode>(tree1, tree2);
      expect(result.length, 1);
      expect(result.first, isA<TreeDiffNodeUpdate>());
      expect(((result.first as TreeDiffNodeUpdate).data as TreeNode).key, 'c1');
      expect(
          ((result.first as TreeDiffNodeUpdate).data as TreeNode).data, 'CC2');
    });
  });

  group("Test nodes updates on indexed tree", () {
    test("Test nodes updates on level 0", () {
      final tree1 = IndexedTreeNode.root()
        ..addAll([
          IndexedTreeNode(key: "a", data: "A"),
          IndexedTreeNode(key: "b", data: "B"),
          IndexedTreeNode(key: "c", data: "C")
        ]);

      final tree2 = IndexedTreeNode.root()
        ..addAll([
          IndexedTreeNode(key: "a", data: "A"),
          IndexedTreeNode(key: "b", data: "B"),
          IndexedTreeNode(key: "c", data: "C1")
        ]);

      final result = calculateTreeDiff<IndexedTreeNode>(tree1, tree2);
      expect(result.length, 1);
      expect(result.first, isA<TreeDiffNodeUpdate>());
      expect(((result.first as TreeDiffNodeUpdate).data as IndexedTreeNode).key,
          'c');
      expect(
          ((result.first as TreeDiffNodeUpdate).data as IndexedTreeNode).data,
          'C1');
    });

    test("Test nodes updates on level 1", () {
      final tree1 = IndexedTreeNode.root()
        ..addAll([
          IndexedTreeNode(key: "a", data: "A"),
          IndexedTreeNode(key: "b", data: "B"),
          IndexedTreeNode(key: "c", data: "C")
            ..addAll([IndexedTreeNode(key: "c1", data: "CC1")]),
        ]);

      final tree2 = IndexedTreeNode.root()
        ..addAll([
          IndexedTreeNode(key: "a", data: "A"),
          IndexedTreeNode(key: "b", data: "B"),
          IndexedTreeNode(key: "c", data: "C")
            ..addAll([IndexedTreeNode(key: "c1", data: "CC2")])
        ]);

      final result = calculateTreeDiff<IndexedTreeNode>(tree1, tree2);
      expect(result.length, 1);
      expect(result.first, isA<TreeDiffNodeUpdate>());
      expect(((result.first as TreeDiffNodeUpdate).data as IndexedTreeNode).key,
          'c1');
      expect(
          ((result.first as TreeDiffNodeUpdate).data as IndexedTreeNode).data,
          'CC2');
    });
  });
}
