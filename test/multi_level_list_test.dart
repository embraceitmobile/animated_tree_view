import 'package:flutter_test/flutter_test.dart';
import 'package:multi_level_list_view/utils/utils.dart';

import 'mocks.dart';

void main() {
  test('generate level aware ids', () async {
    final entries = Utils.generateLevelAwareEntries(items);
    expect(entries.first.id, equals("0A"));
    expect(entries.first.children.first.id, equals("0A.1A"));
    expect(entries[2].id, equals("0C"));
    expect(entries[2].children.first.id, equals("0C.0C1A"));
    expect(entries[2].children[2].id, equals("0C.0C1C"));
    expect(entries[2].children[2].children.first.id, equals("0C.0C1C.0C1C2A"));
    expect(entries[2].children[2].children.first.children.first.id,
        equals("0C.0C1C.0C1C2A.0C1C2A3A"));
  });
}
