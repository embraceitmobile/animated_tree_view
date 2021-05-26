import 'dart:async';

import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:flutter_test/flutter_test.dart';

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

  group('test adding children to a ListenableNodes ', () {
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
  });

  group('test listeners are notified on adding children', () {
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

  group('test addedNodes event on adding children', () {
    test('On adding nodes, the addedNodes event is fired', () async {
      final node = ListenableNode();
      node.addedNodes.listen(
          expectAsync1((event) => expect(event.items.length, isNonZero)));

      node.add(ListenableNode());
    });

    test('On adding multiple nodes, respective items in the event are emitted',
        () async {
      final node = ListenableNode();
      final nodesUnderTest = [
        ListenableNode(),
        ListenableNode(),
        ListenableNode()
      ];
      node.addedNodes.listen(expectAsync1((event) {
        expect(event.items.length, nodesUnderTest.length);
      }));

      node.addAll(nodesUnderTest);
    });

    test('Exception is thrown on accessing addEvent stream on a non-root node',
        () async {
      final node = ListenableNode();
      final nodesUnderTest = ListenableNode();
      node.add(nodesUnderTest);
      expect(() => nodesUnderTest.addedNodes,
          throwsA(isA<ActionNotAllowedException>()));
    });

    test(
        'On adding a node on a non-root node, event is emitted on the root node',
        () async {
      final rootNode = ListenableNode();
      final nodeUnderTest = ListenableNode();
      rootNode.add(nodeUnderTest);
      rootNode.addedNodes.listen(
          expectAsync1((event) => expect(event.items.length, isNonZero)));

      nodeUnderTest.add(ListenableNode());
    });

    test(
        'On adding a node on list of nodes a non-root node, event is emitted on the root node',
        () async {
      final nodesToAdd = [ListenableNode(), ListenableNode(), ListenableNode()];
      final rootNode = ListenableNode();
      final nodeUnderTest = ListenableNode();
      rootNode.add(nodeUnderTest);
      rootNode.addedNodes.listen(expectAsync1(
          (event) => expect(event.items.length, nodesToAdd.length)));

      nodeUnderTest.addAll(nodesToAdd);
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

    test(
        'On removing a list of ListenableNode, the size of children decreases correspondingly',
        () async {
      final node = ListenableNode();
      final nodesUnderTest = [
        ListenableNode(),
        ListenableNode(),
        ListenableNode()
      ];
      node.addAll(nodesUnderTest);
      expect(node.children.length, equals(nodesUnderTest.length));
      node.removeAll(nodesUnderTest.sublist(1));
      expect(node.children.length, equals(1));
    });

    test('On selfDelete, the node is removed from the parent', () async {
      final root = ListenableNode();
      final nodesUnderTest = [
        ListenableNode(),
        ListenableNode(),
        ListenableNode()
      ];
      root.addAll(nodesUnderTest);
      expect(root.children.length, equals(nodesUnderTest.length));
      final nodeToRemove = nodesUnderTest.first;
      nodeToRemove.delete();
      expect(root.children.length, 2);
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
  });

  group('test listeners are notified on removing children', () {
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

    test('On selfDelete, the node is removed from the parent', () async {
      final completer = Completer<int>();
      final root = ListenableNode();
      final nodesUnderTest = [
        ListenableNode(),
        ListenableNode(),
        ListenableNode()
      ];
      root.addAll(nodesUnderTest);
      expect(root.children.length, equals(nodesUnderTest.length));
      final nodeToRemove = nodesUnderTest.first;
      root.addListener(() {
        if (!completer.isCompleted) completer.complete(root.children.length);
      });
      nodeToRemove.delete();
      expect(await completer.future, 2);
    });

    test('On selfDelete, the node is removed from the parent', () async {
      final completer = Completer<int>();
      final root = ListenableNode();
      final nodesUnderTest = [
        ListenableNode(),
        ListenableNode(),
        ListenableNode()
      ];
      final childNodesUnderTest = [
        ListenableNode(),
        ListenableNode(),
        ListenableNode()
      ];
      root.addAll(nodesUnderTest);
      expect(root.children.length, equals(nodesUnderTest.length));
      nodesUnderTest.first.addAll(childNodesUnderTest);
      final nodeToRemove = childNodesUnderTest.first;
      root.addListener(() {
        if (!completer.isCompleted)
          completer.complete(nodesUnderTest.first.children.length);
      });
      nodeToRemove.delete();
      expect(await completer.future, 2);
      expect(root.children.length, 3);
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

  group('test removedNodes event on removing children', () {
    test(
        'On removing a node, the removedNodes event is fired with the corresponding removed node data',
        () async {
      final node = ListenableNode();
      final nodeUnderTest = ListenableNode();
      node.add(nodeUnderTest);
      node.removedNodes.listen(expectAsync1((event) {
        expect(event.items.length, 1);
        expect(event.items.first.key, nodeUnderTest.key);
      }));

      node.remove(nodeUnderTest);
    });

    test(
        'On clearing a node, the removedNodes event is fired containing the correct number of removed nodes',
        () async {
      final node = ListenableNode();
      final nodesUnderTest = [
        ListenableNode(),
        ListenableNode(),
        ListenableNode()
      ];
      node.addAll(nodesUnderTest);

      node.removedNodes.listen(expectAsync1((event) {
        expect(event.items.length, nodesUnderTest.length);
      }));

      node.clear();
    });

    test(
        'On removeWhere method, the removedNodes event is fired containing the correct number of removed nodes',
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
      node.removedNodes.listen(expectAsync1((event) {
        expect(event.items.length, 1);
        expect(event.items.first.key, nodeToRemove.key);
      }));
      node.removeWhere((node) => node.key == nodeToRemove.key);
    });

    test(
        'Exception is thrown on accessing removedNodes stream on a non-root node',
        () async {
      final node = ListenableNode();
      final nodesUnderTest = ListenableNode();
      node.add(nodesUnderTest);
      expect(() => nodesUnderTest.removedNodes,
          throwsA(isA<ActionNotAllowedException>()));
    });

    test(
        'On removing a node on a non-root node, event is emitted on the root node',
        () async {
      final rootNode = ListenableNode();
      final nodeUnderTest = ListenableNode();
      final nodeToRemove = ListenableNode();
      rootNode.add(nodeUnderTest);
      rootNode.removedNodes.listen(expectAsync1((event) {
        expect(event.items.length, 1);
        expect(event.items.first.key, nodeToRemove.key);
      }));

      nodeUnderTest.add(nodeToRemove);
      nodeUnderTest.remove(nodeToRemove);
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
