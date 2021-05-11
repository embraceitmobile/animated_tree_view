import 'package:flutter_test/flutter_test.dart';
import 'package:tree_structure_view/tree_structure_view.dart';

import '../mocks/indexed_tree_mocks.dart';

void main() {
  group('test new list node construction', () {
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
        'On inserting a node asynchronously, the size of children increases correspondingly',
        () async {
      final node = ListNode();
      await node.insertAsync(0, node);
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

    test(
        'On inserting a node asynchronously, the correct node is inserted at the specified index',
        () async {
      final node = ListNode();
      const count = 3;
      for (int i = 0; i < count; i++) {
        node.add(ListNode());
      }

      const index = 2;
      final nodeToInsert = ListNode();
      await node.insertAsync(index, nodeToInsert);
      expect(nodeToInsert.key, equals(node.children[index].key));
    });

    test(
        'On inserting a node after a specified node, the correct node is inserted at the index',
        () async {
      final node = ListNode();
      final childrenToAdd = [ListNode(), ListNode(), ListNode()];
      node.addAll(childrenToAdd);

      const index = 1;
      final nodeToInsert = ListNode();
      final insertedAt = node.insertAfter(childrenToAdd[index], nodeToInsert);
      expect(nodeToInsert, equals(node.children[index + 1]));
      expect(insertedAt, equals(index + 1));
    });

    test(
        'On inserting a node after a specified node asynchronously, '
        'the correct node is inserted at the index', () async {
      final node = ListNode();
      final childrenToAdd = [ListNode(), ListNode(), ListNode()];
      node.addAll(childrenToAdd);

      const index = 1;
      final nodeToInsert = ListNode();
      final insertedAt =
          await node.insertAfterAsync(childrenToAdd[index], nodeToInsert);
      expect(nodeToInsert.key, equals(node.children[index + 1].key));
      expect(insertedAt, equals(index + 1));
    });

    test(
        'On inserting a node before a specified node, the correct node is inserted at the index',
        () async {
      final node = ListNode();
      final childrenToAdd = [ListNode(), ListNode(), ListNode()];
      node.addAll(childrenToAdd);

      const index = 1;
      final nodeToInsert = ListNode();
      final insertedAt = node.insertBefore(childrenToAdd[index], nodeToInsert);
      expect(nodeToInsert, equals(node.children[index]));
      expect(insertedAt, equals(index));
    });

    test(
        'On inserting a node before a specified node asynchronously, '
        'the correct node is inserted at the index', () async {
      final node = ListNode();
      final childrenToAdd = [ListNode(), ListNode(), ListNode()];
      node.addAll(childrenToAdd);

      const index = 1;
      final nodeToInsert = ListNode();
      final insertedAt =
          await node.insertBeforeAsync(childrenToAdd[index], nodeToInsert);
      expect(nodeToInsert.key, equals(node.children[index].key));
      expect(insertedAt, equals(index));
    });

    test(
        'On inserting a list of nodes, the size of children increases correspondingly',
        () async {
      final node = ListNode();
      final nodesToAdd = [ListNode(), ListNode(), ListNode()];
      node.addAll(nodesToAdd);

      final childrenBeforeInsertion = node.children.length;

      final index = 1;
      final nodesToInsert = [ListNode(), ListNode(), ListNode()];
      node.insertAll(index, nodesToInsert);
      expect(node.children.length,
          equals(childrenBeforeInsertion + nodesToInsert.length));
    });

    test(
        'On inserting a list of nodes asynchronously, '
        'the size of children increases correspondingly', () async {
      final node = ListNode();
      final nodesToAdd = [ListNode(), ListNode(), ListNode()];
      node.addAll(nodesToAdd);

      final childrenBeforeInsertion = node.children.length;

      final index = 1;
      final nodesToInsert = [ListNode(), ListNode(), ListNode()];
      await node.insertAllAsync(index, nodesToInsert);
      expect(node.children.length,
          equals(childrenBeforeInsertion + nodesToInsert.length));
    });

    test(
        'On inserting a list of nodes, the nodes are inserted at the correct index position',
        () async {
      final node = ListNode();
      final nodesToAdd = [ListNode(), ListNode(), ListNode()];
      node.addAll(nodesToAdd);

      final index = 1;
      final nodesToInsert = [ListNode(), ListNode(), ListNode()];
      node.insertAll(index, nodesToInsert);
      for (int i = 0; i < nodesToInsert.length; i++) {
        expect(nodesToInsert[i], equals(node.children[index + i]));
      }
    });

    test(
        'On inserting a list of nodes asynchronously, the nodes are inserted at the correct index position',
        () async {
      final node = ListNode();
      final nodesToAdd = [ListNode(), ListNode(), ListNode()];
      node.addAll(nodesToAdd);

      final index = 1;
      final nodesToInsert = [ListNode(), ListNode(), ListNode()];
      await node.insertAllAsync(index, nodesToInsert);
      for (int i = 0; i < nodesToInsert.length; i++) {
        expect(nodesToInsert[i].key, equals(node.children[index + i].key));
      }
    });

    test(
        'On inserting a node with children, all the children path across the length '
            'and breadth are updated',
            () async {
          final node = ListNode(Node.ROOT_KEY);
          final nodesToAdd = [ListNode("C1"), ListNode("C2"), ListNode("C3")];
          node.addAll(nodesToAdd);

          final index = 1;
          node.insert(index, mockListNode1);

          expect(node["M1"]["0C"]["0C1C"]["0C1C2A"]["0C1C2A3A"].path,
              equals("./.M1.0C.0C1C.0C1C2A"));
        });

    test(
        'On inserting a node with children asynchronously, all the children path across the length '
            'and breadth are updated',
            () async {
          final node = ListNode(Node.ROOT_KEY);
          final nodesToAdd = [ListNode("C1"), ListNode("C2"), ListNode("C3")];
          node.addAll(nodesToAdd);

          final index = 1;
          await node.insertAsync(index, mockListNode1);

          expect(node["M1"]["0C"]["0C1C"]["0C1C2A"]["0C1C2A3A"].path,
              equals("./.M1.0C.0C1C.0C1C2A"));
        });

    test(
        'On inserting a list of nodes node with children, '
            'all the children path across the length and breadth are updated',
            () async {
          final node = ListNode(Node.ROOT_KEY);
          node.addAll([mockListNode1, mockListNode2, mockListNode3]);
          expect(node["M1"]["0C"]["0C1C"]["0C1C2A"]["0C1C2A3A"].path,
              equals("./.M1.0C.0C1C.0C1C2A"));
          expect(node["M2"]["0C"]["0C1C"]["0C1C2A"]["0C1C2A3A"].path,
              equals("./.M2.0C.0C1C.0C1C2A"));
          expect(node["M3"]["0C"]["0C1C"]["0C1C2A"]["0C1C2A3A"].path,
              equals("./.M3.0C.0C1C.0C1C2A"));
        });

    test(
        'On inserting a list of nodes node with children asynchronously, '
            'all the children path across the length and breadth are updated',
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
