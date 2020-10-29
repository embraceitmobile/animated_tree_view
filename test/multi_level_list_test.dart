import 'package:flutter_test/flutter_test.dart';
import 'package:multi_level_list_view/models/entry.dart';
import 'package:multi_level_list_view/utils/utils.dart';

import 'mocks.dart';

void main() {
  test('same Uuid is returned for every call if ids are not overridden',
      () async {
    final id = itemsWithoutIds.first.key;
    expect(itemsWithoutIds.first.key, equals(id));
    expect(itemsWithoutIds.first.key, equals(id));
    expect(itemsWithoutIds.first.key, equals(id));
  });

  test('correct entry path are generated', () async {
    final entries = Utils.generateLevelAwareEntries(itemsWithIds);
    final _ = Entry.PATH_SEPARATOR;
    expect(entries.first.key, equals("0A"));
    expect(entries.first.children.first.entryPath, equals("${_}0A"));
    expect(entries[2].key, equals("0C"));
    expect(entries[2].children.first.entryPath, equals("${_}0C"));
    expect(entries[2].children[2].entryPath, equals("${_}0C"));
    expect(entries[2].children[2].children.first.entryPath,
        equals("${_}0C${_}0C1C"));
    expect(entries[2].children[2].children.first.children.first.entryPath,
        equals("${_}0C${_}0C1C${_}0C1C2A"));
  });
}
