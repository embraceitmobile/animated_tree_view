import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> testAllNodesAreRenderedOnTap(
    ITreeNode tree, WidgetTester tester) async {
  final node = find.byKey(ValueKey(tree.key));

  await tester.tap(node);
  await tester.pumpAndSettle();

  for (final childNode in tree.childrenAsList) {
    expect(find.byKey(ValueKey(childNode.key)), findsOneWidget);

    if (childNode.childrenAsList.isNotEmpty) {
      await testAllNodesAreRenderedOnTap(childNode as ITreeNode, tester);
    }
  }
}

Future<void> testAllNodesAreVisible(ITreeNode tree, WidgetTester tester) async {
  expect(find.byKey(ValueKey(tree.key)), findsOneWidget);

  for (final childNode in tree.childrenAsList) {
    expect(find.byKey(ValueKey(childNode.key)), findsOneWidget);

    if (childNode.childrenAsList.isNotEmpty) {
      await testAllNodesAreVisible(childNode as ITreeNode, tester);
    }
  }
}

Future<void> testChildNodesAreNotVisible(
    ITreeNode tree, WidgetTester tester) async {
  for (final childNode in tree.childrenAsList) {
    expect(find.byKey(ValueKey(childNode.key)), findsNothing);

    if (childNode.childrenAsList.isNotEmpty) {
      await testChildNodesAreNotVisible(childNode as ITreeNode, tester);
    }
  }
}
