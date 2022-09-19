import 'dart:collection';
import 'dart:math';

import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:diffutil_dart/diffutil.dart';
import 'package:tuple/tuple.dart';

List<DataDiffUpdate<INode>> calculateTreeDiff(INode oldTree, INode newTree) {
  final updates = <DataDiffUpdate<INode>>[];

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

    updates.addAll(localUpdates);

    final changedNodeKeys = localUpdates
        .map<int?>((update) => update.when(
              insert: (pos, _) => pos,
              remove: (pos, _) => pos,
              change: (_, __, ___) => double.maxFinite.toInt(),
              move: (_, __, ___) => double.maxFinite.toInt(),
            ))
        .toSet();

    for (int i = 0;
        i < min(listsToCompare.item1.length, listsToCompare.item2.length);
        i++) {
      if (!changedNodeKeys.contains(i)) {
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
