import 'package:flutter_test/flutter_test.dart';
import 'package:tree_structure_view/exceptions/exceptions.dart';
import 'package:tree_structure_view/node/indexed_node.dart';
import 'package:tree_structure_view/node/node.dart';
import 'package:tree_structure_view/tree/indexed_tree.dart';

import '../mocks/indexed_tree_mocks.dart';

void main() {
  group('test new indexed tree construction', () {
    test('On constructing a new tree, the value is not null', () async {
      final tree = IndexedTree();
      expect(tree, isNotNull);
    });

    test('On constructing a new indexed tree, the root is not null', () async {
      final tree = IndexedTree();
      expect(tree.root, isNotNull);
    });

    test('On constructing a new indexed tree, the root key is /', () async {
      final tree = IndexedTree();
      expect(tree.root.key, INode.ROOT_KEY);
    });

    test('On constructing a new indexed tree, the root children are not null',
        () async {
      final tree = IndexedTree();
      expect(tree.root.children, isNotNull);
    });
  });

  group('test adding nodes to a tree', () {
    test(
        'On adding a node to the root, the size of root children increases respectively',
        () async {
      final tree = IndexedTree();
      tree.add(IndexedNode());
      expect(tree.length, equals(1));
    });

    test(
        'On adding a node to a child node, the size of the children increases respectively',
        () async {
      final tree = IndexedTree();
      tree.add(IndexedNode());
      tree.first.add(IndexedNode());
      expect(tree.first.children.length, equals(1));
    });

    test(
        'On adding a collection of nodes to a child node, the size of the '
        'children increases respectively', () async {
      final tree = IndexedTree();
      final nodesUnderTest = [IndexedNode(), IndexedNode(), IndexedNode()];
      tree.addAll(nodesUnderTest);
      expect(tree.length, equals(nodesUnderTest.length));
    });

    test(
        'On adding a node to a child node at a specified path, the correct node'
        'is updated', () async {
      final tree = mockIndexedTreeWithIds;
      tree.add(IndexedNode(), path: "0C.0C1A");
      expect(tree["0C"]["0C1A"].length, equals(1));
    });

    test(
        'On adding a collection of nodes at a specified, the correct node is updated'
        'with the respective node collection', () async {
      final tree = mockIndexedTreeWithIds;
      final nodesUnderTest = [IndexedNode(), IndexedNode(), IndexedNode()];
      tree.addAll(nodesUnderTest, path: "0C.0C1A");
      expect(tree["0C"]["0C1A"].length, equals(nodesUnderTest.length));
    });
  });

  group('test removing nodes from a tree', () {
    test(
        'On removing a node from the root, the size of root children decreases respectively',
        () async {
      final tree = mockIndexedTreeWithIds;
      final nodeToRemove = tree.first;
      final nodeToRemoveKey = nodeToRemove.key;
      tree.remove(nodeToRemove.key);
      expect(tree.length, equals(2));
      expect(tree.children.contains(nodeToRemoveKey), false);
    });

    test(
        'On removing list of nodes from the root, the size of the root children decreases respectively',
        () async {
      final tree = mockIndexedTreeWithIds;
      final nodesCountToRemove = 2;
      final originalChildrenCount = tree.length;
      final nodesToRemoveKeys = tree.children
          .take(nodesCountToRemove)
          .map((node) => node.key)
          .toList();

      tree.removeAll(nodesToRemoveKeys);
      expect(tree.length, equals(originalChildrenCount - nodesCountToRemove));
      expect(tree.root.children.contains(nodesToRemoveKeys.first), false);
      expect(tree.root.children.contains(nodesToRemoveKeys.last), false);
    });

    test(
        'On removing a node using removeWhere method, the correct node matching the predicate is removed',
        () async {
      final tree = mockIndexedTreeWithIds;
      final originalTreeLength = tree.length;
      final nodeToRemove = tree.first;

      tree.removeWhere((node) => node.key == nodeToRemove.key);
      expect(tree.length, originalTreeLength - 1);
      expect(tree.children.contains(nodeToRemove.key), false);
    });

    test('On clearing a tree, the root children become empty', () async {
      final tree = mockIndexedTreeWithIds;
      expect(tree.children, isNotEmpty);
      tree.clear();
      expect(tree.children, isEmpty);
    });
  });

  group('test accessing nodes', () {
    test('Correct node is returned using the node keys', () async {
      final tree = mockIndexedTreeWithIds;
      expect(tree.children[0].key, equals("0A"));
    });

    test('Correct node is returned elementAt method', () async {
      final tree = mockIndexedTreeWithIds;
      expect(tree.elementAt("0A").key, equals("0A"));
    });

    test('Correct node is returned using the [] operator', () async {
      final tree = mockIndexedTreeWithIds;
      expect(tree["0A"].key, equals("0A"));
    });

    test('Correct node is returned using at method', () async {
      final tree = mockIndexedTreeWithIds;
      expect(tree.at(0).key, equals("0A"));
    });

    test('Correct node is returned using the first getter', () async {
      final tree = mockIndexedTreeWithIds;
      expect(tree.first.key, equals("0A"));
    });

    test('Correct node is returned using the last getter', () async {
      final tree = mockIndexedTreeWithIds;
      expect(tree.last.key, equals("0C"));
    });

    test(
        'Correct nested node in hierarchy is returned using cascading of [] operator',
        () async {
      final tree = mockIndexedTreeWithIds;
      expect(tree["0A"]["0A1A"].key, equals("0A1A"));
      expect(tree["0C"]["0C1C"]["0C1C2A"]["0C1C2A3A"].key, equals("0C1C2A3A"));
    });

    test('Correct node is returned using a path in the elementAt method',
        () async {
      final tree = mockIndexedTreeWithIds;
      const _s = INode.PATH_SEPARATOR;
      expect(tree.elementAt("0A${_s}0A1A").key, equals("0A1A"));
      expect(tree.elementAt("0C${_s}0C1C${_s}0C1C2A${_s}0C1C2A3A").key,
          equals("0C1C2A3A"));
    });

    test('Correct node is returned using a path in the [] operator', () async {
      final tree = mockIndexedTreeWithIds;
      const _s = INode.PATH_SEPARATOR;
      expect(tree["0A${_s}0A1A"].key, equals("0A1A"));
      expect(
          tree["0C${_s}0C1C${_s}0C1C2A${_s}0C1C2A3A"].key, equals("0C1C2A3A"));
    });

    test(
        'Correct nested node in hierarchy is returned using cascading of at method',
        () async {
      final tree = mockIndexedTreeWithIds;
      expect(tree.at(0).at(0).key, equals("0A1A"));
      expect(tree.at(2).at(2).at(0).at(0).key, equals("0C1C2A3A"));
    });

    test(
        'Correct nested node in hierarchy is returned using cascading of first getter',
        () async {
      final tree = mockIndexedTreeWithIds;
      expect(tree.first.first.key, equals("0A1A"));
    });

    test(
        'Correct nested node in hierarchy is returned using cascading of last getter',
        () async {
      final tree = mockIndexedTreeWithIds;
      expect(tree.last.last.last.last.key, equals("0C1C2A3C"));
    });

    test(
        'Exception is thrown if an incorrect path is provided to elementAt method',
        () async {
      final tree = mockIndexedTreeWithIds;
      const _s = INode.PATH_SEPARATOR;
      expect(() => tree.elementAt("0A${_s}0C1A"), throwsException);
    });

    test('Exception is thrown if an incorrect path is provided to [] operator',
        () async {
      final tree = mockIndexedTreeWithIds;
      const _s = INode.PATH_SEPARATOR;
      expect(() => tree["0A${_s}0C1A"], throwsException);
    });

    test('Exception is thrown if a wrong index is provided to the at method',
        () async {
      final tree = mockIndexedTreeWithIds;
      expect(() => tree.at(4), throwsA(isA<RangeError>()));
    });

    test('Exception is thrown if first getter is used on an empty tree',
        () async {
      final tree = IndexedTree();
      expect(() => tree.first, throwsA(isA<ChildrenNotFoundException>()));
    });

    test(
        'Exception is thrown if an element is assigned using first setter to an empty tree',
        () async {
      final tree = IndexedTree();
      expect(() => tree.first = IndexedNode(),
          throwsA(isA<ChildrenNotFoundException>()));
    });

    test('Exception is thrown if last getter is used on an empty tree',
        () async {
      final tree = IndexedTree();
      expect(() => tree.last, throwsA(isA<ChildrenNotFoundException>()));
    });

    test(
        'Exception is thrown if an element is assigned using last setter to an empty tree',
        () async {
      final tree = IndexedTree();
      expect(() => tree.last = IndexedNode(),
          throwsA(isA<ChildrenNotFoundException>()));
    });
  });
}
