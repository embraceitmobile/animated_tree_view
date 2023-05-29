import 'dart:async';

import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'fakes/fake_tree_view_widget.dart';
import 'utils/test_utils.dart';

void main() {
  testWidgets('Simple tree root view is properly rendered', (tester) async {
    await tester.pumpWidget(FakeStatelessTreeView(tree: defaultTree));
    expect(find.byKey(ValueKey(defaultTree.root.key)), findsOneWidget);
  });

  testWidgets(
      'Children of simple tree are expanded on tapping the root tile,'
      'and are removed on tapping the tile again', (tester) async {
    final treeToTest = defaultTree;
    final rootNode = find.byKey(ValueKey(treeToTest.root.key));

    await tester.pumpWidget(FakeStatelessTreeView(tree: treeToTest));
    await testAllNodesAreRenderedOnTap(treeToTest, tester);

    await tester.tap(rootNode);
    await tester.pumpAndSettle();

    for (final node in treeToTest.childrenAsList) {
      expect(find.byKey(ValueKey(node.key)), findsNothing);
    }
  });

  testWidgets("TreeView is updated on adding a node in the tree",
      (tester) async {
    final treeToTest = defaultTree;

    await tester.pumpWidget(FakeStatelessTreeView(tree: treeToTest));
    await testAllNodesAreRenderedOnTap(treeToTest, tester);

    final nodeToAdd = TreeNode(key: "0B1A");
    treeToTest.elementAt("0B").add(nodeToAdd);
    await tester.pumpAndSettle();
    expect(find.byKey(ValueKey(nodeToAdd.key)), findsOneWidget);

    final node2ToAdd = TreeNode(key: "0C1C2A3C1A");
    treeToTest.elementAt("0C.0C1C.0C1C2A.0C1C2A3C").add(node2ToAdd);
    await tester.pumpAndSettle();
    expect(find.byKey(ValueKey(nodeToAdd.key)), findsOneWidget);
  });

  testWidgets("TreeView is updated on removing a node in the tree",
      (tester) async {
    final treeToTest = defaultTree;

    await tester.pumpWidget(FakeStatelessTreeView(tree: treeToTest));
    await testAllNodesAreRenderedOnTap(treeToTest, tester);

    final nodeToRemove = treeToTest.elementAt("0A.0A1A");
    treeToTest.elementAt("0A").remove(nodeToRemove);
    await tester.pumpAndSettle();
    expect(find.byKey(ValueKey(nodeToRemove.key)), findsNothing);
  });

  testWidgets("TreeView is updated on updating the tree", (tester) async {
    await tester.pumpWidget(FakeStatefulTreeView());

    for (final tree in testTrees) {
      final (treeToTest, removedNodes) = tree;
      final rootNode = find.byKey(ValueKey(treeToTest.root.key));
      await testAllNodesAreRenderedOnTap(treeToTest, tester);

      for (final removedNode in removedNodes) {
        expect(find.byKey(ValueKey(removedNode.key)), findsNothing);
      }

      await tester.tap(find.byKey(ValueKey("nextButton")));
      await tester.pumpAndSettle();

      await tester.tap(rootNode);
      await tester.pumpAndSettle();
      // break;
    }
  });

  group("TreeViewController tests", () {
    testWidgets(
        "TreeViewController is not null when onTreeReady callback is fired",
        (tester) async {
      late final completer = Completer<TreeViewController>();
      await tester.pumpWidget(
        FakeStatelessTreeView(
          tree: defaultTree,
          onTreeReady: (controller) {
            completer.complete(controller);
          },
        ),
      );

      final controller = await completer.future;
      expect(controller, isNotNull);
    });

    testWidgets(
        "On calling expand on a node with TreeViewController, the child nodes become visible",
        (tester) async {
      final completer = Completer<TreeViewController>();
      final tree = defaultTree;

      await tester.pumpWidget(
        FakeStatelessTreeView(
          tree: tree,
          onTreeReady: (controller) {
            completer.complete(controller);
          },
        ),
      );

      final controller = await completer.future;
      controller.expandNode(tree);

      await tester.pumpAndSettle();

      for (final childNode in tree.childrenAsList) {
        expect(find.byKey(ValueKey(childNode.key)), findsOneWidget);
      }
    });

    testWidgets(
        "On calling expandAllChildren on a node with TreeViewController, the child nodes become visible",
        (tester) async {
      final completer = Completer<TreeViewController>();
      final tree = defaultTree;

      await tester.pumpWidget(
        FakeStatelessTreeView(
          tree: tree,
          onTreeReady: (controller) {
            completer.complete(controller);
          },
        ),
      );

      final controller = await completer.future;
      controller.expandAllChildren(tree, recursive: true);

      await tester.pumpAndSettle();
      await testAllNodesAreVisible(tree, tester);
    });

    testWidgets(
        "On calling collapse on a node with TreeViewController, the child nodes are removed",
        (tester) async {
      final completer = Completer<TreeViewController>();
      final tree = defaultTree;

      await tester.pumpWidget(
        FakeStatelessTreeView(
          tree: tree,
          onTreeReady: (controller) {
            completer.complete(controller);
          },
        ),
      );

      final controller = await completer.future;
      controller.expandAllChildren(tree, recursive: true);

      await tester.pumpAndSettle();
      controller.collapseNode(tree);
      await tester.pumpAndSettle();

      expect(find.byKey(ValueKey(tree.key)), findsOneWidget);
      await testChildNodesAreNotVisible(tree, tester);
    });

    testWidgets(
        "On calling toggleExpansion on a node with TreeViewController, the child nodes become visible and hide successively",
        (tester) async {
      final completer = Completer<TreeViewController>();
      final tree = defaultTree;

      await tester.pumpWidget(
        FakeStatelessTreeView(
          tree: tree,
          onTreeReady: (controller) {
            completer.complete(controller);
          },
        ),
      );

      final controller = await completer.future;
      controller.toggleExpansion(tree);

      await tester.pumpAndSettle();

      for (final childNode in tree.childrenAsList) {
        expect(find.byKey(ValueKey(childNode.key)), findsOneWidget);
      }

      controller.toggleExpansion(tree);
      await tester.pumpAndSettle();

      expect(find.byKey(ValueKey(tree.key)), findsOneWidget);
      await testChildNodesAreNotVisible(tree, tester);
    });

    testWidgets(
        "On elementAt on TreeViewController, the correct node is returned",
        (tester) async {
      final completer = Completer<TreeViewController>();
      final tree = defaultTree;

      await tester.pumpWidget(
        FakeStatelessTreeView(
          tree: tree,
          onTreeReady: (controller) {
            completer.complete(controller);
          },
        ),
      );

      final controller = await completer.future;
      expect(controller.elementAt("0A").key, "0A");
      expect(controller.elementAt("0B").key, "0B");
      expect(controller.elementAt("0C.0C1C.0C1C2A.0C1C2A3C").key, "0C1C2A3C");
    });

    testWidgets(
        "On calling scrollToItem on TreeViewController, the correct node is visible on screen",
        (tester) async {
      final completer = Completer<TreeViewController>();
      final tree = longTree;

      await tester.pumpWidget(
        FakeStatelessTreeView(
          tree: tree,
          onTreeReady: (controller) {
            completer.complete(controller);
          },
        ),
      );

      final controller = await completer.future;
      final nodeUnderTest = tree.elementAt("0Z.0Z1Z.0Z1Z2A.0Z1Z2A3Z");

      expect(find.byKey(ValueKey(nodeUnderTest.key)), findsNothing);
      controller.expandAllChildren(tree, recursive: true);
      await tester.pumpAndSettle();
      expect(find.byKey(ValueKey(nodeUnderTest.key)), findsNothing);
      controller.scrollToItem(nodeUnderTest as TreeNode);
      await tester.pumpAndSettle();
      expect(find.byKey(ValueKey(nodeUnderTest.key)), findsOneWidget);
    });

    testWidgets(
        "On calling scrollToIndex on TreeViewController, the correct node is visible on screen",
        (tester) async {
      final completer = Completer<TreeViewController>();
      final tree = longTree;

      await tester.pumpWidget(
        FakeStatelessTreeView(
          tree: tree,
          onTreeReady: (controller) {
            completer.complete(controller);
          },
        ),
      );

      final controller = await completer.future;
      final nodeUnderTest = tree.elementAt("0Z.0Z1Z.0Z1Z2A.0Z1Z2A3Z");

      expect(find.byKey(ValueKey(nodeUnderTest.key)), findsNothing);
      controller.expandAllChildren(tree, recursive: true);
      await tester.pumpAndSettle();
      expect(find.byKey(ValueKey(nodeUnderTest.key)), findsNothing);
      controller.scrollToIndex(18);
      await tester.pumpAndSettle();
      expect(find.byKey(ValueKey(nodeUnderTest.key)), findsOneWidget);
    });
  });
}
