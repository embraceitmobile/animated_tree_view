import 'package:flutter_test/flutter_test.dart';
import 'package:tree_structure_view/listenable_collections/listenable_tree.dart';
import 'package:tree_structure_view/node/map_node.dart';

import '../mocks/mocks.dart';

void main() {
  group('test new tree construction', () {
    test('On constructing a new tree, the value is not null', () async {
      final tree = ListenableTree(mockTreeWithIds);
      expect(tree, isNotNull);
    });
  });

  group('test adding nodes to a listenable tree', () {
    test('On adding nodes, the addedNodes event is fired', () async {
      final tree = ListenableTree(mockTreeWithIds);
      tree.addedNodes.listen(
          expectAsync1((event) => expect(event.items.length, isNonZero)));

      tree.add(MapNode());
    });

    test('On adding multiple nodes, respective items in the event are emitted',
        () async {
      final tree = ListenableTree(mockTreeWithIds);
      final nodesUnderTest = [MapNode(), MapNode(), MapNode()];
      tree.addedNodes.listen(expectAsync1((event) {
        print("AddEvent received: $event");
        expect(event.items.length, nodesUnderTest.length);
      }));

      tree.addAll(nodesUnderTest);
    });
  });

  group('test removing nodes from a listenable tree', () {
    test('On removing nodes, the removedNodes event is fired', () async {
      final tree = ListenableTree(mockTreeWithIds);
      tree.removedNodes.listen(
          expectAsync1((event) => expect(event.keys.length, isNonZero)));

      final nodeToRemove = tree.root.children.values.first;
      tree.remove(nodeToRemove.key);
    });

    test(
        'On removing multiple nodes, respective items in the event are emitted',
        () async {
      final tree = ListenableTree(mockTreeWithIds);
      final nodesCountToRemove = 2;
      final nodesToRemoveKeys = tree.root.children.values
          .take(nodesCountToRemove)
          .map((node) => node.key)
          .toList();

      tree.removedNodes.listen(expectAsync1(
          (event) => expect(event.keys.length, nodesToRemoveKeys.length)));

      tree.removeAll(nodesToRemoveKeys);
    });
  });
}
