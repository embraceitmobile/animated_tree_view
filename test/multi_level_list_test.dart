import 'package:flutter_test/flutter_test.dart';
import 'package:multi_level_list_view/tree_list/node.dart';
import 'package:multi_level_list_view/utils/utils.dart';
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

  test('correct entry path are generated', () async {
    final entries = itemsWithIds;
    final _ = Node.PATH_SEPARATOR;
    expect(entries.firstNode.key, equals("0A"));
    expect(entries.firstNode.children.firstNode.path, equals("${_}0A"));
    expect(entries.at(2).key, equals("0C"));
    expect(entries.at(2).children.first.path, equals("${_}0C"));
    expect(entries.at(2).children.at(2).path, equals("${_}0C"));
    expect(entries.at(2).children.at(2).children.firstNode.path,
        equals("${_}0C${_}0C1C"));
    expect(entries.at(2).children.at(2).children.firstNode.children.firstNode.path,
        equals("${_}0C${_}0C1C${_}0C1C2A"));
  });
}
