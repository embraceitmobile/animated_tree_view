import 'package:flutter_test/flutter_test.dart';
import 'package:multi_level_list_view/node/map_node.dart';

import '../mocks/mocks.dart';

void main() {
  group('new tree construction', () {
    test('On constructing a new MapNode, the value is not null', () async {
      expect(MapNode(), isNotNull);
    });

    test('On constructing a new MapNode, the children are not null', () async {
      final node = MapNode();
      expect(node, isNotNull);
      expect(node.children, isNotNull);
      expect(node.children.isEmpty, isTrue);
    });
  });

  group('test adding nodes to the tree', () {
    test('On adding a node, the size of children increases correspondingly',
        () async {
      final node = MapNode();
      const count = 3;
      for (int i = 0; i < count; i++) {
        node.add(MapNode());
      }
      expect(node.children.length, equals(count));
    });

    test(
        'On adding a node asynchronously, the size of children increases correspondingly',
        () async {
      final node = MapNode();
      const count = 3;
      for (int i = 0; i < count; i++) {
        await node.addAsync(MapNode());
      }
      expect(node.children.length, equals(count));
    });

    test(
        'On adding a list of nodes, the size of children increases correspondingly',
        () async {
      final node = MapNode();
      final nodesToAdd = [MapNode(), MapNode(), MapNode()];
      node.addAll(nodesToAdd);
      expect(node.children.length, equals(nodesToAdd.length));
    });

    test(
        'On adding a list of nodes asynchronously, the size of children increases correspondingly',
        () async {
      final node = MapNode();
      final nodesToAdd = [MapNode(), MapNode(), MapNode()];
      await node.addAllAsync(nodesToAdd);
      expect(node.children.length, equals(nodesToAdd.length));
    });
  });

  group('test removing nodes from the tree', () {
    test('On removing a node, the size of children decreases correspondingly',
        () async {
      final node = MapNode();
      final nodeUnderTest = MapNode();
      node.add(nodeUnderTest);
      expect(node.children.length, equals(1));
      node.remove(nodeUnderTest.key);
      expect(node.children.length, equals(0));
    });

    test(
        'On removing a list of nodes, the size of children decreases correspondingly',
        () async {
      final node = MapNode();
      final nodesUnderTest = [MapNode(), MapNode(), MapNode()];
      node.addAll(nodesUnderTest);
      expect(node.children.length, equals(nodesUnderTest.length));
      node.removeAll(nodesUnderTest.sublist(1).map((e) => e.key));
      expect(node.children.length, equals(1));
    });

    test('On clearing a node, the size of the children becomes zero', () async {
      final node = MapNode();
      final nodesUnderTest = [MapNode(), MapNode(), MapNode()];
      node.addAll(nodesUnderTest);
      expect(node.children.length, equals(nodesUnderTest.length));
      node.clear();
      expect(node.children.length, equals(0));
    });

    test(
        'On removeWhere method, the correct node matching the predicate is removed',
        () async {
      final node = MapNode();
      final nodesUnderTest = [MapNode(), MapNode(), MapNode()];
      final nodeToRemove = nodesUnderTest.first;
      node.addAll(nodesUnderTest);
      expect(node.children.length, equals(nodesUnderTest.length));
      node.removeWhere((node) => node.key == nodeToRemove.key);
      expect(node.children.length, equals(nodesUnderTest.length - 1));
    });
  });

  group('accessing nodes', () {
    test('Correct node is returned using the node keys', () async {
      final mapNode = mockMapNode;
      expect(mapNode.children["0A"].key, equals("0A"));
    });

    test('Correct node is returned elementAt method', () async {
      final mapNode = mockMapNode;
      expect(mapNode.elementAt("0A").key, equals("0A"));
    });

    test('Correct node is returned using the [] operator', () async {
      final mapNode = mockMapNode;
      expect(mapNode["0A"].key, equals("0A"));
    });

    test(
        'Correct nested node in hierarchy is returned using cascading of [] operator',
        () async {
      final mapNode = mockMapNode;
      expect(mapNode["0A"]["0A1A"].key, equals("0A1A"));
      expect(
          mapNode["0C"]["0C1C"]["0C1C2A"]["0C1C2A3A"].key, equals("0C1C2A3A"));
    });

    test('Correct node is returned using a path in the elementAt method',
        () async {
      final mapNode = mockMapNode;
      const _s = Node.PATH_SEPARATOR;
      expect(mapNode.elementAt("0A${_s}0A1A").key, equals("0A1A"));
      expect(mapNode.elementAt("0C${_s}0C1C${_s}0C1C2A${_s}0C1C2A3A").key,
          equals("0C1C2A3A"));
    });

    test('Correct node is returned using a path in the [] operator', () async {
      final mapNode = mockMapNode;
      const _s = Node.PATH_SEPARATOR;
      expect(mapNode["0A${_s}0A1A"].key, equals("0A1A"));
      expect(mapNode["0C${_s}0C1C${_s}0C1C2A${_s}0C1C2A3A"].key,
          equals("0C1C2A3A"));
    });

    test(
        'Exception is thrown if an incorrect path is provided to elementAt method',
        () async {
      final mapNode = mockMapNode;
      const _s = Node.PATH_SEPARATOR;
      expect(() => mapNode.elementAt("0A${_s}0C1A"), throwsException);
    });

    test('Exception is thrown if an incorrect path is provided to [] operator',
        () async {
      final mapNode = mockMapNode;
      const _s = Node.PATH_SEPARATOR;
      expect(() => mapNode["0A${_s}0C1A"], throwsException);
    });
  });
}
