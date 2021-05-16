import 'package:flutter_test/flutter_test.dart';
import 'package:tree_structure_view/exceptions/exceptions.dart';
import 'package:tree_structure_view/node/node.dart';

import '../mocks/node_mocks.dart';

void main() {
  group('new node construction', () {
    test('On constructing a new Node, the value is not null', () async {
      expect(Node(), isNotNull);
    });

    test('On constructing a new Node, the children are not null', () async {
      final node = Node();
      expect(node, isNotNull);
      expect(node.children, isNotNull);
      expect(node.children.isEmpty, isTrue);
    });
  });

  group('test adding children to a node', () {
    test('On adding a node, the size of children increases correspondingly',
        () async {
      final node = Node();
      const count = 3;
      for (int i = 0; i < count; i++) {
        final nodeToAdd = Node();
        node.add(nodeToAdd);
      }
      expect(node.children.length, equals(count));
    });

    test(
        'On adding a list of nodes, the size of children increases correspondingly',
        () async {
      final node = Node();
      final nodesToAdd = [Node(), Node(), Node()];
      node.addAll(nodesToAdd);
      expect(node.children.length, equals(nodesToAdd.length));
    });
  });

  group('test removing children from the nodes', () {
    test('On removing a node, the size of children decreases correspondingly',
        () async {
      final node = Node();
      final nodeUnderTest = Node();
      node.add(nodeUnderTest);
      expect(node.children.length, equals(1));
      node.remove(nodeUnderTest);
      expect(node.children.length, equals(0));
    });

    test(
        'On removing a list of nodes, the size of children decreases correspondingly',
        () async {
      final node = Node();
      final nodesUnderTest = [Node(), Node(), Node()];
      node.addAll(nodesUnderTest);
      expect(node.children.length, equals(nodesUnderTest.length));
      node.removeAll(nodesUnderTest.sublist(1));
      expect(node.children.length, equals(1));
    });

    test('On clearing a node, the size of the children becomes zero', () async {
      final node = Node();
      final nodesUnderTest = [Node(), Node(), Node()];
      node.addAll(nodesUnderTest);
      expect(node.children.length, equals(nodesUnderTest.length));
      node.clear();
      expect(node.children.length, equals(0));
    });

    test(
        'On removeWhere method, the correct node matching the predicate is removed',
        () async {
      final node = Node();
      final nodesUnderTest = [Node(), Node(), Node()];
      final nodeToRemove = nodesUnderTest.first;
      node.addAll(nodesUnderTest);
      expect(node.children.length, equals(nodesUnderTest.length));
      node.removeWhere((node) => node.key == nodeToRemove.key);
      expect(node.children.length, equals(nodesUnderTest.length - 1));
    });
  });

  group('accessing nodes', () {
    test('Correct node is returned using the node keys', () async {
      final node = mockNode1;
      expect(node.children["0A"]!.key, equals("0A"));
    });

    test('Correct node is returned using elementAt method', () async {
      final node = mockNode1;
      expect(node.elementAt("0A").key, equals("0A"));
    });

    test('Correct node is returned using the [] operator', () async {
      final node = mockNode1;
      expect(node["0A"].key, equals("0A"));
    });

    test(
        'Correct nested node in hierarchy is returned using cascading of [] operator',
        () async {
      final node = mockNode1;
      expect(node["0A"]["0A1A"].key, equals("0A1A"));
      expect(node["0C"]["0C1C"]["0C1C2A"]["0C1C2A3A"].key, equals("0C1C2A3A"));
    });

    test('Correct node is returned using a path in the elementAt method',
        () async {
      final node = mockNode1;
      const _s = INode.PATH_SEPARATOR;
      expect(node.elementAt("0A${_s}0A1A").key, equals("0A1A"));
      expect(node.elementAt("0C${_s}0C1C${_s}0C1C2A${_s}0C1C2A3A").key,
          equals("0C1C2A3A"));
    });

    test('Correct node is returned using a path in the [] operator', () async {
      final node = mockNode1;
      const _s = INode.PATH_SEPARATOR;
      expect(node["0A${_s}0A1A"].key, equals("0A1A"));
      expect(
          node["0C${_s}0C1C${_s}0C1C2A${_s}0C1C2A3A"].key, equals("0C1C2A3A"));
    });

    test('Correct path is returned from a nested node', () async {
      final node = mockNode1;
      expect(node["0C"]["0C1C"]["0C1C2A"]["0C1C2A3A"].path,
          equals("/.0C.0C1C.0C1C2A.0C1C2A3A"));
    });

    test('Correct level is returned from a nested node', () async {
      final node = mockNode1;
      expect(node["0C"]["0C1C"]["0C1C2A"]["0C1C2A3A"].level, equals(4));
    });

    test('Correct root is returned using findRootMethod', () async {
      final node = mockNode1;
      final nodeToTest = node["0C"]["0C1C"]["0C1C2A"]["0C1C2A3A"];
      expect(nodeToTest.root.key, equals(INode.ROOT_KEY));
    });

    test(
        'Exception is thrown if an incorrect path is provided to elementAt method',
        () async {
      final node = mockNode1;
      const _s = INode.PATH_SEPARATOR;
      expect(() => node.elementAt("0A${_s}0C1A"),
          throwsA(isA<NodeNotFoundException>()));
    });

    test('Exception is thrown if an incorrect path is provided to [] operator',
        () async {
      final node = mockNode1;
      const _s = INode.PATH_SEPARATOR;
      expect(() => node["0A${_s}0C1A"], throwsA(isA<NodeNotFoundException>()));
    });
  });
}
