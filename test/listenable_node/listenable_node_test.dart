import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:tree_structure_view/exceptions/exceptions.dart';
import 'package:tree_structure_view/listenable_node/listenable_node.dart';
import 'package:tree_structure_view/node/base/i_node.dart';

import '../mocks/listenable_node_mocks.dart';

void main() {
  group('new node construction', () {
    test('On constructing a new ListenableNode, the value is not null',
        () async {
      expect(ListenableNode(), isNotNull);
    });

    test('On constructing a new ListenableNode, the children are not null',
        () async {
      final node = ListenableNode();
      expect(node, isNotNull);
      expect(node.children, isNotNull);
      expect(node.children.isEmpty, isTrue);
    });
  });

  group('test adding children to a ListenableNodes', () {
    test(
        'On adding a ListenableNode, the size of children increases correspondingly',
        () async {
      final node = ListenableNode();
      const count = 3;
      for (int i = 0; i < count; i++) {
        final nodeToAdd = ListenableNode();
        node.add(nodeToAdd);
      }
      expect(node.children.length, equals(count));
    });

    test(
        'On adding a list of ListenableNodes, the size of children increases correspondingly',
        () async {
      final node = ListenableNode();
      final nodesToAdd = [ListenableNode(), ListenableNode(), ListenableNode()];
      node.addAll(nodesToAdd);
      expect(node.children.length, equals(nodesToAdd.length));
    });

    test('On adding a ListenableNode, the listeners are notified', () async {
      final completer = Completer<int>();
      final node = ListenableNode();
      node.addListener(() {
        completer.complete(node.children.length);
      });

      node.add(ListenableNode());
      expect(await completer.future, equals(1));
    });

    test('On adding a list of ListenableNodes, the listeners are notified',
        () async {
      final completer = Completer<int>();
      final node = ListenableNode();
      final nodesToAdd = [ListenableNode(), ListenableNode(), ListenableNode()];
      node.addListener(() {
        completer.complete(node.children.length);
      });

      node.addAll(nodesToAdd);
      expect(await completer.future, equals(nodesToAdd.length));
    });
  });

  group('test removing children from the ListenableNodes', () {
    test(
        'On removing a ListenableNode, the size of children decreases correspondingly',
        () async {
      final node = ListenableNode();
      final nodeUnderTest = ListenableNode();
      node.add(nodeUnderTest);
      expect(node.children.length, equals(1));
      node.remove(nodeUnderTest);
      expect(node.children.length, equals(0));
    });

    test('On removing a ListenableNode, the listeners are notified', () async {
      final completer = Completer<int>();
      final node = ListenableNode();
      final nodeUnderTest = ListenableNode();
      node.add(nodeUnderTest);
      node.addListener(() {
        completer.complete(node.children.length);
      });

      node.remove(nodeUnderTest);
      expect(await completer.future, equals(0));
    });

    test('On removing a list of ListenableNode, the listeners are notified',
        () async {
      final completer = Completer<int>();
      final node = ListenableNode();
      final nodesUnderTest = [
        ListenableNode(),
        ListenableNode(),
        ListenableNode()
      ];
      node.addAll(nodesUnderTest);
      expect(node.children.length, equals(nodesUnderTest.length));
      node.addListener(() {
        completer.complete(node.children.length);
      });

      node.removeAll(nodesUnderTest.sublist(1));
      expect(await completer.future, equals(1));
    });

    test('On clearing a ListenableNode, the size of the children becomes zero',
        () async {
      final node = ListenableNode();
      final nodesUnderTest = [
        ListenableNode(),
        ListenableNode(),
        ListenableNode()
      ];
      node.addAll(nodesUnderTest);
      expect(node.children.length, equals(nodesUnderTest.length));
      node.clear();
      expect(node.children.length, equals(0));
    });

    test('On clearing a ListenableNode, the listeners are notified', () async {
      final completer = Completer<int>();
      final node = ListenableNode();
      final nodesUnderTest = [
        ListenableNode(),
        ListenableNode(),
        ListenableNode()
      ];
      node.addAll(nodesUnderTest);
      expect(node.children.length, equals(nodesUnderTest.length));
      node.addListener(() {
        completer.complete(node.children.length);
      });
      node.clear();
      expect(await completer.future, equals(0));
    });

    test(
        'On removeWhere method, the correct node matching the predicate is removed',
        () async {
      final node = ListenableNode();
      final nodesUnderTest = [
        ListenableNode(),
        ListenableNode(),
        ListenableNode()
      ];
      final nodeToRemove = nodesUnderTest.first;
      node.addAll(nodesUnderTest);
      expect(node.children.length, equals(nodesUnderTest.length));
      node.removeWhere((node) => node.key == nodeToRemove.key);
      expect(node.children.length, equals(nodesUnderTest.length - 1));
    });

    test('On removeWhere method, the listeners are notified', () async {
      final completer = Completer<int>();
      final node = ListenableNode();
      final nodesUnderTest = [
        ListenableNode(),
        ListenableNode(),
        ListenableNode()
      ];
      final nodeToRemove = nodesUnderTest.first;
      node.addAll(nodesUnderTest);
      expect(node.children.length, equals(nodesUnderTest.length));
      node.addListener(() {
        completer.complete(node.children.length);
      });
      node.removeWhere((node) => node.key == nodeToRemove.key);
      expect(await completer.future, equals(nodesUnderTest.length - 1));
    });
  });

  group('accessing nodes', () {
    test('Correct node is returned using the node keys', () async {
      final node = mockListenableNode1;
      expect(node.children["0A"]!.key, equals("0A"));
    });

    test('Correct node is returned using elementAt method', () async {
      final node = mockListenableNode1;
      expect(node.elementAt("0A").key, equals("0A"));
    });

    test('Correct node is returned using the [] operator', () async {
      final node = mockListenableNode1;
      expect(node["0A"].key, equals("0A"));
    });

    test(
        'Correct nested node in hierarchy is returned using cascading of [] operator',
        () async {
      final node = mockListenableNode1;
      expect(node["0A"]["0A1A"].key, equals("0A1A"));
      expect(node["0C"]["0C1C"]["0C1C2A"]["0C1C2A3A"].key, equals("0C1C2A3A"));
    });

    test('Correct node is returned using a path in the elementAt method',
        () async {
      final node = mockListenableNode1;
      const _s = INode.PATH_SEPARATOR;
      expect(node.elementAt("0A${_s}0A1A").key, equals("0A1A"));
      expect(node.elementAt("0C${_s}0C1C${_s}0C1C2A${_s}0C1C2A3A").key,
          equals("0C1C2A3A"));
    });

    test('Correct node is returned using a path in the [] operator', () async {
      final node = mockListenableNode1;
      const _s = INode.PATH_SEPARATOR;
      expect(node["0A${_s}0A1A"].key, equals("0A1A"));
      expect(
          node["0C${_s}0C1C${_s}0C1C2A${_s}0C1C2A3A"].key, equals("0C1C2A3A"));
    });

    test('Correct path is returned from a nested node', () async {
      final node = mockListenableNode1;
      expect(node["0C"]["0C1C"]["0C1C2A"]["0C1C2A3A"].path,
          equals("/.0C.0C1C.0C1C2A.0C1C2A3A"));
    });

    test('Correct level is returned from a nested node', () async {
      final node = mockListenableNode1;
      expect(node["0C"]["0C1C"]["0C1C2A"]["0C1C2A3A"].level, equals(4));
    });

    test('Correct root is returned using findRootMethod', () async {
      final node = mockListenableNode1;
      final nodeToTest = node["0C"]["0C1C"]["0C1C2A"]["0C1C2A3A"];
      expect(nodeToTest.root.key, equals(INode.ROOT_KEY));
    });

    test(
        'Exception is thrown if an incorrect path is provided to elementAt method',
        () async {
      final node = mockListenableNode1;
      const _s = INode.PATH_SEPARATOR;
      expect(() => node.elementAt("0A${_s}0C1A"),
          throwsA(isA<NodeNotFoundException>()));
    });

    test('Exception is thrown if an incorrect path is provided to [] operator',
        () async {
      final node = mockListenableNode1;
      const _s = INode.PATH_SEPARATOR;
      expect(() => node["0A${_s}0C1A"], throwsA(isA<NodeNotFoundException>()));
    });
  });
}
