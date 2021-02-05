import 'package:flutter_test/flutter_test.dart';
import 'package:multi_level_list_view/listenable_collections/listenable_tree.dart';
import 'package:multi_level_list_view/node/map_node.dart';
import 'package:multi_level_list_view/tree/tree.dart';

import '../mocks/mocks.dart';

void main() {
  group('test new tree construction', () {
    test('On constructing a new tree, the value is not null', () async {
      final tree = ListenableTree(mockTreeWithIds);
      expect(tree, isNotNull);
    });
  });
}
