import 'package:flutter_test/flutter_test.dart';
import 'package:multi_level_list_view/node/map_node.dart';
import 'package:multi_level_list_view/tree/tree.dart';

import '../mocks/mocks.dart';

void main() {
  group('new tree construction', () {
    test('On constructing a new tree, the value is not null', () async {
      final tree = Tree();
      expect(tree, isNotNull);
    });

    test('On constructing a new tree, the root is not null', () async {
      final tree = Tree();
      expect(tree.root, isNotNull);
    });

    test('On constructing a new tree, the root key is /', () async {
      final tree = Tree();
      expect(tree.root.key, Node.ROOT_KEY);
    });

    test('On constructing a new tree, the root children are not null',
        () async {
      final tree = Tree();
      expect(tree.root.children, isNotNull);
    });
  });

  group('adding nodes to the tree', () {
    test(
        'On adding a node to the root, the size of root children increases respectively',
        () async {
      final tree = Tree();
      tree.add(MapNode());
      expect(tree.root.children.length, equals(1));
    });

    test(
        'On adding a node to a child node, the size of the children increases respectively',
        () async {
      final tree = Tree();
      tree.add(MapNode());
      tree.root.children.values.first.add(MapNode());
      expect(tree.root.children.values.first.children.length, equals(1));
    });

    test(
        'On adding a collection of nodes to a child node, the size of the children increases respectively',
        () async {
      final tree = Tree();
      final nodesUnderTest = [MapNode(), MapNode(), MapNode()];
      tree.addAll(nodesUnderTest);
      expect(tree.root.children.length, equals(nodesUnderTest.length));
    });
  });

  group('removing nodes from the tree', () {
    test(
        'On removing a node from the root, the size of root children decreases respectively',
        () async {
      final tree = mockTreeWithIds;
      final nodeToRemove = tree.root.children.values.first;
      final nodeToRemoveKey = nodeToRemove.key;
      tree.remove(nodeToRemove.key);
      expect(tree.root.children.length, equals(2));
      expect(tree.root.children.containsKey(nodeToRemoveKey), false);
    });

    test(
        'On removing list of nodes from the root, the size of the root children decreases respectively',
        () async {
      final tree = mockTreeWithIds;
      final nodesCountToRemove = 2;
      final originalChildrenCount = tree.root.children.values.length;
      final nodesToRemoveKeys = tree.root.children.values
          .take(nodesCountToRemove)
          .map((node) => node.key)
          .toList();

      tree.removeAll(nodesToRemoveKeys);
      expect(tree.root.children.length,
          equals(originalChildrenCount - nodesCountToRemove));
      expect(tree.root.children.containsKey(nodesToRemoveKeys.first), false);
      expect(tree.root.children.containsKey(nodesToRemoveKeys.last), false);
    });

    test(
        'On removing a node using removeWhere method, the correct node matching the predicate is removed',
        () async {
      final tree = mockTreeWithIds;
      final originalTreeLength = tree.length;
      final nodeToRemove = tree.root.children.values.first;

      tree.removeWhere((node) => node.key == nodeToRemove.key);
      expect(tree.length, originalTreeLength - 1);
      expect(tree.root.children.containsKey(nodeToRemove.key), false);
    });

    test('On clearing a tree, the root children become empty', () async {
      final tree = mockTreeWithIds;
      expect(tree.root.children, isNotEmpty);
      tree.clear();
      expect(tree.root.children, isEmpty);
    });
  });

  group('accessing nodes', () {
    test('Correct node is returned using the node keys', () async {
      final tree = mockTreeWithIds;
      expect(tree.root.children["0A"].key, equals("0A"));
    });

    test('Correct node is returned elementAt method', () async {
      final tree = mockTreeWithIds;
      expect(tree.elementAt("0A").key, equals("0A"));
    });

    test('Correct node is returned using the [] operator', () async {
      final tree = mockTreeWithIds;
      expect(tree["0A"].key, equals("0A"));
    });

    test(
        'Correct nested node in hierarchy is returned using cascading of [] operator',
        () async {
      final tree = mockTreeWithIds;
      expect(tree["0A"]["0A1A"].key, equals("0A1A"));
      expect(tree["0C"]["0C1C"]["0C1C2A"]["0C1C2A3A"].key, equals("0C1C2A3A"));
    });

    test('Correct node is returned using a path in the elementAt method',
        () async {
      final tree = mockTreeWithIds;
      const _s = Node.PATH_SEPARATOR;
      expect(tree.elementAt("0A${_s}0A1A").key, equals("0A1A"));
      expect(tree.elementAt("0C${_s}0C1C${_s}0C1C2A${_s}0C1C2A3A").key,
          equals("0C1C2A3A"));
    });

    test('Correct node is returned using a path in the [] operator', () async {
      final tree = mockTreeWithIds;
      const _s = Node.PATH_SEPARATOR;
      expect(tree["0A${_s}0A1A"].key, equals("0A1A"));
      expect(
          tree["0C${_s}0C1C${_s}0C1C2A${_s}0C1C2A3A"].key, equals("0C1C2A3A"));
    });

    test(
        'Exception is thrown if an incorrect path is provided to elementAt method',
        () async {
      final tree = mockTreeWithIds;
      const _s = Node.PATH_SEPARATOR;
      expect(() => tree.elementAt("0A${_s}0C1A"), throwsException);
    });

    test('Exception is thrown if an incorrect path is provided to [] operator',
        () async {
      final tree = mockTreeWithIds;
      const _s = Node.PATH_SEPARATOR;
      expect(() => tree["0A${_s}0C1A"], throwsException);
    });
  });
}
