import 'package:flutter_test/flutter_test.dart';
import 'package:tree_structure_view/tree_structure_view.dart';

import '../mocks/indexed_tree_mocks.dart';

void main() {
  group('new tree construction', () {
    test('On constructing a new ListNode, the value is not null', () async {
      expect(ListNode(), isNotNull);
    });

    test('On constructing a new ListNode, the children are not null', () async {
      final node = ListNode();
      expect(node, isNotNull);
      expect(node.children, isNotNull);
      expect(node.children.isEmpty, isTrue);
    });
  });

  group('test adding children to a node', () {
    test('On adding a node, the size of children increases correspondingly',
        () async {
      final node = ListNode();
      const count = 3;
      for (int i = 0; i < count; i++) {
        node.add(ListNode());
      }
      expect(node.children.length, equals(count));
    });

    test(
        'On adding a node asynchronously, the size of children increases correspondingly',
        () async {
      final node = ListNode();
      const count = 3;
      for (int i = 0; i < count; i++) {
        await node.addAsync(ListNode());
      }
      expect(node.children.length, equals(count));
    });

    test(
        'On adding a list of nodes, the size of children increases correspondingly',
        () async {
      final node = ListNode();
      final nodesToAdd = [ListNode(), ListNode(), ListNode()];
      node.addAll(nodesToAdd);
      expect(node.children.length, equals(nodesToAdd.length));
    });

    test(
        'On adding a list of nodes asynchronously, the size of children increases correspondingly',
        () async {
      final node = ListNode();
      final nodesToAdd = [ListNode(), ListNode(), ListNode()];
      await node.addAllAsync(nodesToAdd);
      expect(node.children.length, equals(nodesToAdd.length));
    });

    test(
        'On adding a node with children, all the children path across the length and breadth are updated',
        () async {
      final node = ListNode(Node.ROOT_KEY);
      node.add(mockListNode1);
      expect(node["M1"]["0C"]["0C1C"]["0C1C2A"]["0C1C2A3A"].path,
          equals("./.M1.0C.0C1C.0C1C2A"));
    });

    test(
        'On adding a node with children asynchronously, all the children path across the length and breadth are updated',
        () async {
      final node = ListNode(Node.ROOT_KEY);
      await node.addAsync(mockListNode1);
      expect(node["M1"]["0C"]["0C1C"]["0C1C2A"]["0C1C2A3A"].path,
          equals("./.M1.0C.0C1C.0C1C2A"));
    });

    test(
        'On adding a list of nodes node with children asynchronously, all the children path across the length and breadth are updated',
        () async {
      final node = ListNode(Node.ROOT_KEY);
      await node.addAllAsync([mockListNode1, mockListNode2, mockListNode3]);
      expect(node["M1"]["0C"]["0C1C"]["0C1C2A"]["0C1C2A3A"].path,
          equals("./.M1.0C.0C1C.0C1C2A"));
      expect(node["M2"]["0C"]["0C1C"]["0C1C2A"]["0C1C2A3A"].path,
          equals("./.M2.0C.0C1C.0C1C2A"));
      expect(node["M3"]["0C"]["0C1C"]["0C1C2A"]["0C1C2A3A"].path,
          equals("./.M3.0C.0C1C.0C1C2A"));
    });
  });

  group('test inserting children to a node', () {
    test(
        'On inserting a node, the node children size increases correspondingly',
        () {
      final node = ListNode();
      node.insert(0, node);
      expect(node.children.length, equals(1));
    });

    test(
        'On inserting a node, the correct node is inserted at the specified index',
        () async {
      final node = ListNode();
      const count = 3;
      for (int i = 0; i < count; i++) {
        node.add(ListNode());
      }

      const index = 2;
      final nodeToInsert = ListNode();
      node.insert(index, nodeToInsert);
      expect(nodeToInsert, equals(node.children[index]));
    });
  });

  group('test removing children from the nodes', () {
    test('On removing a node, the size of children decreases correspondingly',
        () async {
      final node = ListNode();
      final nodeUnderTest = ListNode();
      node.add(nodeUnderTest);
      expect(node.children.length, equals(1));
      node.remove(nodeUnderTest.key);
      expect(node.children.length, equals(0));
    });

    test(
        'On removing a list of nodes, the size of children decreases correspondingly',
        () async {
      final node = ListNode();
      final nodesUnderTest = [ListNode(), ListNode(), ListNode()];
      node.addAll(nodesUnderTest);
      expect(node.children.length, equals(nodesUnderTest.length));
      node.removeAll(nodesUnderTest.sublist(1).map((e) => e.key));
      expect(node.children.length, equals(1));
    });

    test('On clearing a node, the size of the children becomes zero', () async {
      final node = ListNode();
      final nodesUnderTest = [ListNode(), ListNode(), ListNode()];
      node.addAll(nodesUnderTest);
      expect(node.children.length, equals(nodesUnderTest.length));
      node.clear();
      expect(node.children.length, equals(0));
    });

    test(
        'On removeWhere method, the correct node matching the predicate is removed',
        () async {
      final node = ListNode();
      final nodesUnderTest = [ListNode(), ListNode(), ListNode()];
      final nodeToRemove = nodesUnderTest.first;
      node.addAll(nodesUnderTest);
      expect(node.children.length, equals(nodesUnderTest.length));
      node.removeWhere((node) => node.key == nodeToRemove.key);
      expect(node.children.length, equals(nodesUnderTest.length - 1));
    });
  });
}
