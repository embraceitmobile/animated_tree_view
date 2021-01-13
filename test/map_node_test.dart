import 'package:flutter_test/flutter_test.dart';
import 'package:multi_level_list_view/node/map_node.dart';

void main() {
  test('On constructing a new MapNode, the children are not null', () async {
    final node = MapNode();
    expect(node, isNotNull);
    expect(node.children, isNotNull);
    expect(node.children.isEmpty, isTrue);
  });

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

  test('On removing a node, the size of children decreases correspondingly',
      () async {
    final node = MapNode();
    final nodeUnderTest = MapNode();
    node.add(nodeUnderTest);
    expect(node.children.length, equals(1));
    node.remove(nodeUnderTest);
    expect(node.children.length, equals(0));
  });

  test(
      'On removing a list of nodes node, the size of children decreases correspondingly',
      () async {
    final node = MapNode();
    final nodesUnderTest = [MapNode(), MapNode(), MapNode()];
    node.addAll(nodesUnderTest);
    expect(node.children.length, equals(nodesUnderTest.length));
    node.removeAll(nodesUnderTest.sublist(1));
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
}
