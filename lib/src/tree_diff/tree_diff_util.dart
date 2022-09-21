import 'dart:collection';
import 'dart:math';

import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:animated_tree_view/src/helpers/collection_utils.dart';
import 'package:animated_tree_view/src/tree_diff/tree_diff_update.dart';
import 'package:diffutil_dart/diffutil.dart';
import 'package:flutter/widgets.dart';
import 'package:tuple/tuple.dart';

List<TreeDiffUpdate> calculateTreeDiff<T extends INode>(T oldTree, T newTree) {
  final updates = <TreeDiffUpdate>[];

  final queue = ListQueue<Tuple2<INode, INode>>();
  queue.add(Tuple2(oldTree, newTree));

  while (queue.isNotEmpty) {
    final nodesToCompare = queue.removeFirst();

    if (nodesToCompare.item1.childrenAsList.isEmpty &&
        nodesToCompare.item2.childrenAsList.isEmpty) continue;

    final localUpdates = TreeDiff(
      oldTree: nodesToCompare.item1,
      newTree: nodesToCompare.item2,
    );

    updates.addAll(localUpdates.allUpdates);
    queue.addAll(localUpdates.nodesUnchanged);
  }

  return updates;
}

class TreeDiff {
  final Iterable<NodeAdd> nodesAdded;
  final Iterable<NodeRemove> nodesRemoved;
  final Iterable<NodeInsert> nodesInserted;
  final Iterable<Tuple2<INode, INode>> nodesUnchanged;

  final INode oldTree;
  final INode newTree;

  Iterable<TreeDiffUpdate> get allUpdates => [
        ...nodesAdded,
        ...nodesInserted,
        ...nodesRemoved,
      ];

  const TreeDiff._({
    required this.oldTree,
    required this.newTree,
    this.nodesAdded = const [],
    this.nodesRemoved = const [],
    this.nodesInserted = const [],
    this.nodesUnchanged = const [],
  });

  factory TreeDiff({required INode oldTree, required INode newTree}) {
    if (oldTree is Node && newTree is Node)
      return forTree(oldTree: oldTree, newTree: newTree);

    if (oldTree is IndexedNode && newTree is IndexedNode)
      return forIndexedTree(oldTree: oldTree, newTree: newTree);

    return TreeDiff._(oldTree: oldTree, newTree: newTree);
  }

  @visibleForTesting
  static TreeDiff forTree({required Node oldTree, required Node newTree}) {
    final oldKeys = oldTree.children.keys.toSet();
    final newKeys = newTree.children.keys.toSet();

    final nodesAdded = newKeys.difference(oldKeys).map((nodeKey) {
      final node = newTree.children[nodeKey];
      return node == null ? null : NodeAdd(node);
    }).filterNotNull();

    final nodesRemoved = oldKeys.difference(newKeys).map((nodeKey) {
      final node = oldTree.children[nodeKey];
      return node == null ? null : NodeRemove(data: node);
    }).filterNotNull();

    final nodesUnchanged = oldKeys.intersection(newKeys).map(
          (nodeKey) => Tuple2<Node, Node>(
            oldTree.children[nodeKey]!,
            newTree.children[nodeKey]!,
          ),
        );

    return TreeDiff._(
      oldTree: oldTree,
      newTree: newTree,
      nodesAdded: nodesAdded,
      nodesRemoved: nodesRemoved,
      nodesUnchanged: nodesUnchanged,
    );
  }

  @visibleForTesting
  static TreeDiff forIndexedTree(
      {required IndexedNode oldTree, required IndexedNode newTree}) {
    final localUpdates = calculateListDiff<INode>(
      oldTree.children,
      newTree.children,
      equalityChecker: (n1, n2) => n1.key == n2.key,
      detectMoves: false,
    ).getUpdatesWithData();

    final nodesInserted = <NodeInsert>[];
    final nodesRemoved = <NodeRemove>[];

    for (final update in localUpdates) {
      update.when(
        insert: (pos, data) {
          nodesInserted.add(NodeInsert(position: pos, data: data));
        },
        remove: (pos, data) {
          nodesRemoved.add(NodeRemove(data: data, position: pos));
        },
        change: (_, __, ___) {},
        move: (_, __, ___) {},
      );
    }

    final oldTreeMap = <String, IndexedNode>{
      for (final node in oldTree.children) node.key: node
    };

    final newTreeMap = <String, IndexedNode>{
      for (final node in newTree.children) node.key: node
    };

    final nodesUnchanged = oldTreeMap.keys
        .toSet()
        .intersection(newTreeMap.keys.toSet())
        .map((nodeKey) => Tuple2(oldTreeMap[nodeKey]!, newTreeMap[nodeKey]!));

    return TreeDiff._(
      oldTree: oldTree,
      newTree: newTree,
      nodesInserted: nodesInserted,
      nodesRemoved: nodesRemoved,
      nodesUnchanged: nodesUnchanged,
    );
  }
}
