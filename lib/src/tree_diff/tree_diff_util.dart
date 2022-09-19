import 'dart:collection';
import 'dart:math';

import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:animated_tree_view/src/helpers/collection_utils.dart';
import 'package:animated_tree_view/src/tree_diff/tree_diff_update.dart';
import 'package:diffutil_dart/diffutil.dart';
import 'package:flutter/widgets.dart';
import 'package:tuple/tuple.dart';

List<TreeDiffUpdate> calculateTreeDiff(INode oldTree, INode newTree) {
  if (oldTree is Node && newTree is Node)
    return calculateMapTreeDiff(oldTree, newTree);

  if (oldTree is IndexedNode && newTree is IndexedNode)
    return calculateIndexedTreeDiff(oldTree, newTree);

  return [];
}

@visibleForTesting
List<TreeDiffUpdate> calculateMapTreeDiff(Node oldTree, Node newTree) {
  final updates = <TreeDiffUpdate>[];

  final queue = ListQueue<Tuple2<Node, Node>>();
  queue.add(Tuple2(oldTree, newTree));

  while (queue.isNotEmpty) {
    final mapsToCompare = queue.removeFirst();

    if (mapsToCompare.item1.children.isEmpty &&
        mapsToCompare.item2.children.isEmpty) continue;

    final localUpdates = TreeDiff(
      oldTree: mapsToCompare.item1,
      newTree: mapsToCompare.item2,
    );

    updates.addAll(localUpdates.asUpdates());
    queue.addAll(localUpdates.nodesUnchanged);
  }

  return updates;
}

@visibleForTesting
List<TreeDiffUpdate> calculateIndexedTreeDiff(
    IndexedNode oldTree, IndexedNode newTree) {
  final updates = <TreeDiffUpdate>[];

  final queue = ListQueue<Tuple2<List<INode>, List<INode>>>();
  queue.add(Tuple2(oldTree.childrenAsList, newTree.childrenAsList));

  while (queue.isNotEmpty) {
    final listsToCompare = queue.removeFirst();
    if (listsToCompare.item1.isEmpty && listsToCompare.item2.isEmpty) continue;

    final localUpdates = calculateListDiff<INode>(
      listsToCompare.item1,
      listsToCompare.item2,
      equalityChecker: (n1, n2) => n1.key == n2.key,
    ).getUpdatesWithData();

    final changedNodeIndices = <int>{};

    for (final update in localUpdates) {
      update.when(
        insert: (pos, data) {
          updates.add(NodeInsert(position: pos, data: data));
          changedNodeIndices.add(pos);
        },
        remove: (pos, data) {
          updates.add(NodeRemove(data, position: pos));
          changedNodeIndices.add(pos);
        },
        change: (_, __, ___) {},
        move: (_, __, ___) {},
      );
    }

    for (int i = 0;
        i < min(listsToCompare.item1.length, listsToCompare.item2.length);
        i++) {
      if (!changedNodeIndices.contains(i)) {
        queue.add(
          Tuple2(
            listsToCompare.item1[i].childrenAsList,
            listsToCompare.item2[i].childrenAsList,
          ),
        );
      }
    }
  }

  return updates;
}

class TreeDiff {
  late final Iterable<Node> nodesAdded;
  late final Iterable<Node> nodesRemoved;
  late final Iterable<Tuple2<Node, Node>> nodesUnchanged;

  final Node oldTree;
  final Node newTree;

  TreeDiff({required this.oldTree, required this.newTree}) {
    final oldKeys = oldTree.children.keys.toSet();
    final newKeys = newTree.children.keys.toSet();

    this.nodesAdded = newKeys
        .difference(oldKeys)
        .map((nodeKey) => newTree.children[nodeKey])
        .filterNotNull();

    this.nodesRemoved = oldKeys
        .difference(newKeys)
        .map((nodeKey) => oldTree.children[nodeKey])
        .filterNotNull();

    this.nodesUnchanged = oldKeys.intersection(newKeys).map((nodeKey) =>
        Tuple2(oldTree.children[nodeKey]!, newTree.children[nodeKey]!));
  }

  Iterable<TreeDiffUpdate> asUpdates() {
    final updates = <TreeDiffUpdate>[];
    updates.addAll(nodesAdded.map((node) => NodeAdd(node)));
    updates.addAll(nodesRemoved.map((node) => NodeRemove(node)));

    return updates;
  }
}
