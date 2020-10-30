import 'package:flutter_test/flutter_test.dart';
import 'package:multi_level_list_view/multi_level_list_view.dart';
import 'package:multi_level_list_view/tree_list/node.dart';
import 'mocks.dart';

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

  test('tree list initializes from list and generates path for children',
      () async {
    final treeList = TreeList.from(List.of(itemsWithIds));
    final nodes = treeList.root.children;
    final _ = Node.PATH_SEPARATOR;
    final root = "$_$ROOT_KEY";

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
    final testNode =
        rootNode.children.at(2).children.at(2).children.firstNode.children.firstNode;
    final testPath = "0C${_}0C1C${_}0C1C2A${_}0C1C2A3A";
    final returnedNode = rootNode.getNodeAt(testPath);

    expect(returnedNode.key, equals(testNode.key));
  });
}
