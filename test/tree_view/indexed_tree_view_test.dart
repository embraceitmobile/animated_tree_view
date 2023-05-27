import 'dart:async';

import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'fakes/fake_indexed_tree_view_widget.dart';
import 'fakes/fake_tree_view_widget.dart';
import 'utils/test_utils.dart';

void main() {
  testWidgets('Indexed tree root view is properly rendered', (tester) async {
    await tester
        .pumpWidget(FakeStatelessIndexedTreeView(tree: defaultIndexedTree));
    expect(find.byKey(ValueKey(defaultTree.root.key)), findsOneWidget);
  });

  testWidgets(
      'Children of indexed tree are expanded on tapping the root tile,'
      'and are removed on tapping the tile again', (tester) async {
    final treeToTest = defaultIndexedTree;
    final rootNode = find.byKey(ValueKey(treeToTest.root.key));

    await tester.pumpWidget(FakeStatelessIndexedTreeView(tree: treeToTest));
    await testAllNodesAreRenderedOnTap(treeToTest, tester);

    await tester.tap(rootNode);
    await tester.pumpAndSettle();

    for (final node in treeToTest.childrenAsList) {
      expect(find.byKey(ValueKey(node.key)), findsNothing);
    }
  });

  testWidgets("IndexedTreeView is updated on adding a node in the tree",
      (tester) async {
    final treeToTest = defaultIndexedTree;

    await tester.pumpWidget(FakeStatelessIndexedTreeView(tree: treeToTest));
    await testAllNodesAreRenderedOnTap(treeToTest, tester);

    final nodeToAdd = IndexedTreeNode(key: "0B1A");
    treeToTest.elementAt("0B").add(nodeToAdd);
    await tester.pumpAndSettle();
    expect(find.byKey(ValueKey(nodeToAdd.key)), findsOneWidget);

    final node2ToAdd = IndexedTreeNode(key: "0C1C2A3C1A");
    treeToTest.elementAt("0C.0C1C.0C1C2A.0C1C2A3C").add(node2ToAdd);
    await tester.pumpAndSettle();
    expect(find.byKey(ValueKey(nodeToAdd.key)), findsOneWidget);
  });

  testWidgets("IndexedTreeView is updated on removing a node in the tree",
      (tester) async {
    final treeToTest = defaultIndexedTree;

    await tester.pumpWidget(FakeStatelessIndexedTreeView(tree: treeToTest));
    await testAllNodesAreRenderedOnTap(treeToTest, tester);

    final nodeToRemove = treeToTest.elementAt("0A.0A1A");
    treeToTest.elementAt("0A").remove(nodeToRemove);
    await tester.pumpAndSettle();
    expect(find.byKey(ValueKey(nodeToRemove.key)), findsNothing);
  });

  testWidgets("IndexedTreeView is updated on updating the tree",
      (tester) async {
    await tester.pumpWidget(FakeStatefulIndexedTreeView());

    for (final tree in testIndexedTrees) {
      final treeToTest = tree.item1;
      final rootNode = find.byKey(ValueKey(treeToTest.root.key));
      await testAllNodesAreRenderedOnTap(treeToTest, tester);

      for (final removedNodes in tree.item2) {
        expect(find.byKey(ValueKey(removedNodes.key)), findsNothing);
      }

      await tester.tap(find.byKey(ValueKey("nextButton")));
      await tester.pumpAndSettle();

      await tester.tap(rootNode);
      await tester.pumpAndSettle();
      // break;
    }
  });

  testWidgets(
      "TreeViewController is not null when onTreeReady callback is fired",
      (tester) async {
    late final completer = Completer<TreeViewController>();
    await tester.pumpWidget(
      FakeStatelessIndexedTreeView(
        tree: defaultIndexedTree,
        onTreeReady: (controller) {
          completer.complete(controller);
        },
      ),
    );

    final controller = await completer.future;
    expect(controller, isNotNull);
  });
}
