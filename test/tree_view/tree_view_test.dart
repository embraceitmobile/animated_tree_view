import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_tree_view_widget.dart';

void main() {
  group("TreeView tests", () {
    testWidgets('Simple tree root view is properly rendered', (tester) async {
      await tester.pumpWidget(MockTreeView());
      expect(find.byKey(ValueKey(defaultTree.root.key)), findsOneWidget);
    });

    testWidgets(
        'Children of simple tree are expanded on tapping the root tile,'
        'and are removed on tapping the tile again', (tester) async {
      await tester.pumpWidget(MockTreeView());
      final rootNode = find.byKey(ValueKey(defaultTree.root.key));

      await tester.tap(rootNode);
      await tester.pumpAndSettle();

      for (final node in defaultTree.childrenAsList) {
        expect(find.byKey(ValueKey(node.key)), findsOneWidget);
      }

      await tester.tap(rootNode);
      await tester.pumpAndSettle();

      for (final node in defaultTree.childrenAsList) {
        expect(find.byKey(ValueKey(node.key)), findsNothing);
      }
    });
  });
}
