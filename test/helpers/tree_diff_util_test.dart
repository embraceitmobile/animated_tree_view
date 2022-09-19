import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:animated_tree_view/src/helpers/tree_diff_util.dart';
import 'package:diffutil_dart/diffutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
      "Correct position and data is notified on inserting a new node at single level",
      () {
    final tree1 = SimpleNode.root()
      ..addAll([SimpleNode("a"), SimpleNode("b"), SimpleNode("c")]);
    final tree2 = SimpleNode.root()
      ..addAll(
          [SimpleNode("a"), SimpleNode("b"), SimpleNode("c"), SimpleNode("d")]);

    final result = calculateTreeDiff(tree1, tree2);
    expect(result.length, 1);
    expect(result.first, isA<DataInsert>());
    expect((result.first as DataInsert).position, 3);
  });

  test(
      "Correct position and data is notified on removing a new node at single level",
      () {
    final tree1 = SimpleNode.root()
      ..addAll(
          [SimpleNode("a"), SimpleNode("b"), SimpleNode("c"), SimpleNode("d")]);
    final tree2 = SimpleNode.root()
      ..addAll([SimpleNode("a"), SimpleNode("b"), SimpleNode("c")]);

    final result = calculateTreeDiff(tree1, tree2);
    expect(result.length, 1);
    expect(result.first, isA<DataRemove>());
    expect((result.first as DataRemove).position, 3);
  });

  test(
      "Correct position and data is notified on simultaneous inserting and removing a new node at single level",
      () {
    final tree1 = SimpleNode.root()
      ..addAll([SimpleNode("a"), SimpleNode("b"), SimpleNode("c")]);
    final tree2 = SimpleNode.root()
      ..addAll([SimpleNode("b"), SimpleNode("c"), SimpleNode("d")]);

    final result = calculateTreeDiff(tree1, tree2);
    expect(result.length, 2);

    expect(result.first, isA<DataInsert>());
    expect((result.first as DataInsert).position, 3);
    expect(result.last, isA<DataRemove>());
    expect((result.last as DataRemove).position, 0);
  });

  test(
      "Correct position and data is notified on inserting a new node at double level",
      () {
    final tree1 = SimpleNode.root()
      ..addAll([SimpleNode("a"), SimpleNode("b"), SimpleNode("c")]);

    final tree2 = SimpleNode.root()
      ..addAll([
        SimpleNode("a"),
        SimpleNode("b"),
        SimpleNode("c")..addAll([SimpleNode("c1")]),
      ]);

    final result = calculateTreeDiff(tree1, tree2);
    expect(result.length, 1);
    expect(result.first, isA<DataInsert>());
    expect(((result.first as DataInsert).data as SimpleNode).path, "/.c.c1");
  });
}
