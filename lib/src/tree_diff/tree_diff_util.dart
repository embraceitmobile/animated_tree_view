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

  final queue = ListQueue<Tuple2<IndexedNode, IndexedNode>>();
  queue.add(Tuple2(oldTree, newTree));

  while (queue.isNotEmpty) {
    final nodesToCompare = queue.removeFirst();

    if (nodesToCompare.item1.children.isEmpty &&
        nodesToCompare.item2.children.isEmpty) continue;

    final localUpdates = calculateListDiff<INode>(
      nodesToCompare.item1.children,
      nodesToCompare.item2.children,
      equalityChecker: (n1, n2) => n1.key == n2.key,
    ).getUpdatesWithData();

    for (final update in localUpdates) {
      update.when(
        insert: (pos, data) {
          updates.add(NodeInsert(position: pos, data: data));
        },
        remove: (pos, data) {
          updates.add(NodeRemove(data, position: pos));
        },
        change: (_, __, ___) {},
        move: (_, __, ___) {},
      );
    }

    final oldTreeMap = <String, IndexedNode>{
      for (final node in nodesToCompare.item1.children) node.key: node
    };

    final newTreeMap = <String, IndexedNode>{
      for (final node in nodesToCompare.item2.children) node.key: node
    };

    final nodesUnchanged = oldTreeMap.keys
        .toSet()
        .intersection(newTreeMap.keys.toSet())
        .map((nodeKey) => Tuple2(oldTreeMap[nodeKey]!, newTreeMap[nodeKey]!));

    queue.addAll(nodesUnchanged);
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
