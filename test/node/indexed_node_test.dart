import 'package:flutter_test/flutter_test.dart';
import 'package:tree_structure_view/helpers/exceptions.dart';
import 'package:tree_structure_view/tree_structure_view.dart';

import '../mocks/indexed_node_mocks.dart';

void main() {
  group('test new list node construction', () {
    test('On constructing a new IndexedNode, the value is not null', () async {
      expect(IndexedNode(), isNotNull);
    });

    test('On constructing a new IndexedNode, the children are not null',
        () async {
      final node = IndexedNode();
      expect(node, isNotNull);
      expect(node.children, isNotNull);
      expect(node.children.isEmpty, isTrue);
    });
  });

  group('test adding children to a node', () {
    test('On adding a node, the size of children increases correspondingly',
        () async {
      final node = IndexedNode();
      const count = 3;
      for (int i = 0; i < count; i++) {
        node.add(IndexedNode());
      }
      expect(node.children.length, equals(count));
    });

    test(
        'On adding a list of nodes, the size of children increases correspondingly',
        () async {
      final node = IndexedNode();
      final nodesToAdd = [IndexedNode(), IndexedNode(), IndexedNode()];
      node.addAll(nodesToAdd);
      expect(node.children.length, equals(nodesToAdd.length));
    });
  });

  group('test inserting children to a node', () {
    test(
        'On inserting a node, the node children size increases correspondingly',
        () {
      final node = IndexedNode();
      node.insert(0, IndexedNode());
      expect(node.children.length, equals(1));
    });

    test(
        'On inserting a node, the correct node is inserted at the specified index',
        () async {
      final node = IndexedNode();
      const count = 3;
      for (int i = 0; i < count; i++) {
        node.add(IndexedNode());
      }

      const index = 2;
      final nodeToInsert = IndexedNode();
      node.insert(index, nodeToInsert);
      expect(nodeToInsert, equals(node.children[index]));
    });

    test(
        'On inserting a node after a specified node, the correct node is inserted at the index',
        () async {
      final node = IndexedNode();
      final childrenToAdd = [IndexedNode(), IndexedNode(), IndexedNode()];
      node.addAll(childrenToAdd);

      const index = 1;
      final nodeToInsert = IndexedNode();
      final insertedAt = node.insertAfter(childrenToAdd[index], nodeToInsert);
      expect(nodeToInsert, equals(node.children[index + 1]));
      expect(insertedAt, equals(index + 1));
    });

    test(
        'On inserting a node before a specified node, the correct node is inserted at the index',
        () async {
      final node = IndexedNode();
      final childrenToAdd = [IndexedNode(), IndexedNode(), IndexedNode()];
      node.addAll(childrenToAdd);

      const index = 1;
      final nodeToInsert = IndexedNode();
      final insertedAt = node.insertBefore(childrenToAdd[index], nodeToInsert);
      expect(nodeToInsert, equals(node.children[index]));
      expect(insertedAt, equals(index));
    });

    test(
        'On inserting a list of nodes, the size of children increases correspondingly',
        () async {
      final node = IndexedNode();
      final nodesToAdd = [IndexedNode(), IndexedNode(), IndexedNode()];
      node.addAll(nodesToAdd);

      final childrenBeforeInsertion = node.children.length;

      final index = 1;
      final nodesToInsert = [IndexedNode(), IndexedNode(), IndexedNode()];
      node.insertAll(index, nodesToInsert);
      expect(node.children.length,
          equals(childrenBeforeInsertion + nodesToInsert.length));
    });

    test(
        'On inserting a list of nodes, the nodes are inserted at the correct index position',
        () async {
      final node = IndexedNode();
      final nodesToAdd = [
        IndexedNode(key: "A1"),
        IndexedNode(key: "A2"),
        IndexedNode(key: "A3")
      ];
      node.addAll(nodesToAdd);

      final index = 1;
      final nodesToInsert = [
        IndexedNode(key: "I1"),
        IndexedNode(key: "I2"),
        IndexedNode(key: "I3")
      ];
      node.insertAll(index, nodesToInsert);
      for (int i = 0; i < nodesToInsert.length; i++) {
        expect(nodesToInsert[i].key, equals(node.children[index + i].key));
      }
    });

    test(
        'On inserting a node with children, all the children path across the length '
        'and breadth are updated', () async {
      final node = IndexedNode.root();
      final nodesToAdd = [
        IndexedNode(key: "C1"),
        IndexedNode(key: "C2"),
        IndexedNode(key: "C3")
      ];
      node.addAll(nodesToAdd);

      final index = 1;
      node.insert(index, IndexedNode(key: "C4")..add(IndexedNode(key: "C4A0")));

      expect(node["C4"]["C4A0"].path, equals("/.C4.C4A0"));
    });

    test(
        'On inserting a list of nodes node with children, '
        'all the children path across the length and breadth are updated',
        () async {
      final node = IndexedNode.root();
      node.addAll([
        mockNoRootIndexedNode1,
        mockNoRootIndexedNode2,
        mockNoRootIndexedNode3
      ]);
      expect(node["M1"]["0C"]["0C1C"]["0C1C2A"]["0C1C2A3A"].path,
          equals("/.M1.0C.0C1C.0C1C2A.0C1C2A3A"));
      expect(node["M2"]["0C"]["0C1C"]["0C1C2A"]["0C1C2A3A"].path,
          equals("/.M2.0C.0C1C.0C1C2A.0C1C2A3A"));
      expect(node["M3"]["0C"]["0C1C"]["0C1C2A"]["0C1C2A3A"].path,
          equals("/.M3.0C.0C1C.0C1C2A.0C1C2A3A"));
    });
  });

  group('test removing children from the nodes', () {
    test('On removing a node, the size of children decreases correspondingly',
        () async {
      final node = IndexedNode();
      final nodeUnderTest = IndexedNode();
      node.add(nodeUnderTest);
      expect(node.children.length, equals(1));
      node.remove(nodeUnderTest);
      expect(node.children.length, equals(0));
    });

    test(
        'On removing a list of nodes, the size of children decreases correspondingly',
        () async {
      final node = IndexedNode();
      final nodesUnderTest = [IndexedNode(), IndexedNode(), IndexedNode()];
      node.addAll(nodesUnderTest);
      expect(node.children.length, equals(nodesUnderTest.length));
      node.removeAll(nodesUnderTest.sublist(1));
      expect(node.children.length, equals(1));
    });

    test('On selfDelete, the node is removed from the parent', () async {
      final root = IndexedNode();
      final nodesUnderTest = [IndexedNode(), IndexedNode(), IndexedNode()];
      root.addAll(nodesUnderTest);
      expect(root.children.length, equals(nodesUnderTest.length));
      final nodeToRemove = nodesUnderTest.first;
      nodeToRemove.delete();
      expect(root.children.length, 2);
    });

    test('On clearing a node, the size of the children becomes zero', () async {
      final node = IndexedNode();
      final nodesUnderTest = [IndexedNode(), IndexedNode(), IndexedNode()];
      node.addAll(nodesUnderTest);
      expect(node.children.length, equals(nodesUnderTest.length));
      node.clear();
      expect(node.children.length, equals(0));
    });

    test(
        'On removeWhere method, the correct node matching the predicate is removed',
        () async {
      final node = IndexedNode();
      final nodesUnderTest = [IndexedNode(), IndexedNode(), IndexedNode()];
      final nodeToRemove = nodesUnderTest.first;
      node.addAll(nodesUnderTest);
      expect(node.children.length, equals(nodesUnderTest.length));
      node.removeWhere((node) => node.key == nodeToRemove.key);
      expect(node.children.length, equals(nodesUnderTest.length - 1));
    });
  });

  group('test node accessor methods', () {
    test('Correct node is returned using the node keys', () async {
      final indexedNode = mockIndexedNode1;
      expect(indexedNode.children[0].key, equals("0A"));
    });

    test('Correct node is returned using elementAt method', () async {
      final indexedNode = mockIndexedNode1;
      expect(indexedNode.elementAt("0A").key, equals("0A"));
    });

    test('Correct node is returned using at method', () async {
      final indexedNode = mockIndexedNode1;
      expect(indexedNode.at(0).key, equals("0A"));
    });

    test('Correct node is returned using the [] operator', () async {
      final indexedNode = mockIndexedNode1;
      expect(indexedNode["0A"].key, equals("0A"));
    });

    test('Correct node is returned using the first getter', () async {
      final indexedNode = mockIndexedNode1;
      expect(indexedNode.first.key, equals("0A"));
    });

    test('Correct node is returned using the last getter', () async {
      final indexedNode = mockIndexedNode1;
      expect(indexedNode.last.key, equals("0C"));
    });

    test(
        'Correct nested node in hierarchy is returned using cascading of [] operator',
        () async {
      final indexedNode = mockIndexedNode1;
      expect(indexedNode["0A"]["0A1A"].key, equals("0A1A"));
      expect(indexedNode["0C"]["0C1C"]["0C1C2A"]["0C1C2A3A"].key,
          equals("0C1C2A3A"));
    });

    test(
        'Correct node in hierarchy is returned using a path in the elementAt method',
        () async {
      final indexedNode = mockIndexedNode1;
      const _s = INode.PATH_SEPARATOR;
      expect(indexedNode.elementAt("0A${_s}0A1A").key, equals("0A1A"));
      expect(indexedNode.elementAt("0C${_s}0C1C${_s}0C1C2A${_s}0C1C2A3A").key,
          equals("0C1C2A3A"));
    });

    test(
        'Correct node in hierarchy is returned using a path in the [] operator',
        () async {
      final indexedNode = mockIndexedNode1;
      const _s = INode.PATH_SEPARATOR;
      expect(indexedNode["0A${_s}0A1A"].key, equals("0A1A"));
      expect(indexedNode["0C${_s}0C1C${_s}0C1C2A${_s}0C1C2A3A"].key,
          equals("0C1C2A3A"));
    });

    test(
        'Correct nested node in hierarchy is returned using cascading of at method',
        () async {
      final indexedNode = mockIndexedNode1;
      expect(indexedNode.at(0).at(0).key, equals("0A1A"));
      expect(indexedNode.at(2).at(2).at(0).at(0).key, equals("0C1C2A3A"));
    });

    test(
        'Correct nested node in hierarchy is returned using cascading of first getter',
        () async {
      final indexedNode = mockIndexedNode1;
      expect(indexedNode.first.first.key, equals("0A1A"));
    });

    test(
        'Correct nested node in hierarchy is returned using cascading of last getter',
        () async {
      final indexedNode = mockIndexedNode1;
      expect(indexedNode.last.last.last.last.key, equals("0C1C2A3C"));
    });

    test('Correct path is returned from a nested node', () async {
      final node = mockIndexedNode1;
      expect(node["0C"]["0C1C"]["0C1C2A"]["0C1C2A3A"].path,
          equals("/.0C.0C1C.0C1C2A.0C1C2A3A"));
    });

    test('Correct level is returned from a nested node', () async {
      final node = mockIndexedNode1;
      expect(node["0C"]["0C1C"]["0C1C2A"]["0C1C2A3A"].level, equals(4));
    });

    test('Correct root is returned using findRootMethod', () async {
      final node = mockIndexedNode1;
      final nodeToTest = node["0C"]["0C1C"]["0C1C2A"]["0C1C2A3A"];
      expect(nodeToTest.root.key, equals(INode.ROOT_KEY));
    });

    test(
        'Exception is thrown if an incorrect path is provided to elementAt method',
        () async {
      final indexedNode = mockIndexedNode1;
      const _s = INode.PATH_SEPARATOR;
      expect(() => indexedNode.elementAt("0A${_s}0C1A"),
          throwsA(isA<NodeNotFoundException>()));
    });

    test('Exception is thrown if an incorrect path is provided to [] operator',
        () async {
      final indexedNode = mockIndexedNode1;
      const _s = INode.PATH_SEPARATOR;
      expect(() => indexedNode["0A${_s}0C1A"],
          throwsA(isA<NodeNotFoundException>()));
    });

    test('Exception is thrown if a wrong index is provided to the at method',
        () async {
      final indexedNode = mockIndexedNode1;
      expect(() => indexedNode.at(4), throwsA(isA<RangeError>()));
    });

    test('Exception is thrown if first getter is used on an empty node',
        () async {
      final indexedNode = IndexedNode();
      expect(
          () => indexedNode.first, throwsA(isA<ChildrenNotFoundException>()));
    });

    test(
        'Exception is thrown if an element is assigned using first setter to an empty node',
        () async {
      final indexedNode = IndexedNode();
      expect(() => indexedNode.first = IndexedNode(),
          throwsA(isA<ChildrenNotFoundException>()));
    });

    test('Exception is thrown if last getter is used on an empty node',
        () async {
      final indexedNode = IndexedNode();
      expect(() => indexedNode.last, throwsA(isA<ChildrenNotFoundException>()));
    });

    test(
        'Exception is thrown if an element is assigned using last setter to an empty node',
        () async {
      final indexedNode = IndexedNode();
      expect(() => indexedNode.last = IndexedNode(),
          throwsA(isA<ChildrenNotFoundException>()));
    });
  });
}
