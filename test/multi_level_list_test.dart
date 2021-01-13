import 'package:flutter_test/flutter_test.dart';
import 'package:multi_level_list_view/multi_level_list_view.dart';
import 'mocks/mocks.dart';

void main() {
  test('same Uuid is returned for every call if ids are not overridden',
      () async {
    final id = itemsWithoutIds.firstNode.key;
    expect(itemsWithoutIds.firstNode.key, equals(id));
    expect(itemsWithoutIds.at(0).key, equals(id));
    expect(itemsWithoutIds.firstNode.key, equals(id));
  });

  test('children are correctly assigned', () async {
    expect(itemsWithoutIds.firstNode.children.length, equals(1));
    expect(itemsWithoutIds.at(2).children.length, equals(3));
  });

  test('child paths are assigned when a TreeList is initialized', () async {
    final treeList = TreeList.from(List.of(itemsWithoutIds));
    expect(treeList.children.firstNode.path!.isNotEmpty, isTrue);
    expect(treeList.children.at(2).children.firstNode.path!.isNotEmpty,
        isTrue);
  });

  test('tree list initializes from list and generates path for children',
      () async {
    final treeList = TreeList.from(List.of(itemsWithIds));
    final nodes = treeList.children;
    final _ = Node.PATH_SEPARATOR;
    final root = "$_${Node.ROOT_KEY}";

    expect(nodes.firstNode.key, equals("0A"));
    expect(nodes.firstNode.children.firstNode.path, equals("$root${_}0A"));
    expect(nodes.at(2).key, equals("0C"));
    expect(nodes.at(2).children.first.path, equals("$root${_}0C"));
    expect(nodes.at(2).children.at(2).path, equals("$root${_}0C"));
    expect(nodes.at(2).children.at(2).children.firstNode.path,
        equals("$root${_}0C${_}0C1C"));
    expect(
        nodes.at(2).children.at(2).children.firstNode.children.firstNode.path,
        equals("$root${_}0C${_}0C1C${_}0C1C2A"));
  });

  test('get the correct node from path', () async {
    final treeList = TreeList.from(List.of(itemsWithIds));
    final rootNode = treeList.root;
    final _ = Node.PATH_SEPARATOR;
    final testNode = treeList.children
        .at(2)
        .children
        .at(2)
        .children
        .firstNode
        .children
        .firstNode;

    final testPath = "$_${Node.ROOT_KEY}${_}0C${_}0C1C${_}0C1C2A${_}0C1C2A3A";
    final returnedNode = rootNode.getNodeAt(testPath);

    expect(returnedNode.key, equals(testNode.key),
        reason:
            "getNodeAt handles path starting with PATH_SEPARATOR = $_ and ROOT_KEY = ${Node.ROOT_KEY}");

    final testPath2 = "${Node.ROOT_KEY}${_}0C${_}0C1C${_}0C1C2A${_}0C1C2A3A";
    final returnedNode2 = rootNode.getNodeAt(testPath2);
    expect(returnedNode2.key, equals(testNode.key),
        reason: "getNodeAt handles path starting with ROOT_KEY = ${Node.ROOT_KEY}");

    final testPath3 = "0C${_}0C1C${_}0C1C2A${_}0C1C2A3A";
    final returnedNode3 = rootNode.getNodeAt(testPath3);
    expect(returnedNode3.key, equals(testNode.key),
        reason:
            "getNodeAt handles path starting without ROOT_KEY = ${Node.ROOT_KEY} and PATH_SEPARATOR = $_");
  });
}
