import 'dart:async';

import 'package:animated_tree_view/constants/constants.dart';
import 'package:animated_tree_view/helpers/exceptions.dart';
import 'package:animated_tree_view/listenable_node/base/i_listenable_node.dart';
import 'package:animated_tree_view/node/base/i_node.dart';
import 'package:animated_tree_view/tree_view/tree_node.dart';
import 'package:animated_tree_view/tree_view/tree_view.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

abstract class ListState<Tree> {
  void insertItem(int index, {Duration duration = animationDuration});

  void removeItem(int index, Tree item,
      {Duration duration = animationDuration});
}

class TreeViewStateHelper<Data> {
  static const TAG = "TreeViewStateHelper";

  final ITreeNode<Data> tree;
  final AnimatedListStateController<Data> animatedListStateController;
  final TreeViewExpansionBehaviourController<Data> expansionBehaviourController;
  final bool focusToNewNode;

  late StreamSubscription<NodeAddEvent<INode>> _addedNodesSubscription;
  late StreamSubscription<NodeRemoveEvent<INode>> _removeNodesSubscription;
  StreamSubscription<NodeInsertEvent<INode>>? _insertNodesSubscription;

  TreeViewStateHelper({
    required this.animatedListStateController,
    required this.expansionBehaviourController,
    required this.tree,
    this.focusToNewNode = true,
  }) {
    _addedNodesSubscription = tree.addedNodes.listen(handleAddItemsEvent);
    _removeNodesSubscription = tree.removedNodes.listen(handleRemoveItemsEvent);

    try {
      _insertNodesSubscription =
          tree.insertedNodes.listen(handleInsertItemsEvent);
    } on ActionNotAllowedException catch (_) {}
  }

  @visibleForTesting
  void handleAddItemsEvent(NodeAddEvent<INode> event) {
    for (final node in event.items) {
      if (animatedListStateController.containsKey(node.path)) continue;

      if (node.isRoot || node.parent?.isRoot == true) {
        final root = node.root as ITreeNode<Data>;
        if (!root.isExpanded) {
          if (focusToNewNode) {
            expansionBehaviourController.expandNode(root);
          }
        } else {
          animatedListStateController.insertAll(
              animatedListStateController.list.length, List.from(event.items));
        }
        if (focusToNewNode) {
          expansionBehaviourController.scrollToLastVisibleChild(root);
        }
      } else {
        final parentIndex = animatedListStateController.list
            .indexWhere((element) => element.key == node.parent?.key);
        if (parentIndex < 0) continue;

        final parentNode = animatedListStateController.list[parentIndex];

        if (!parentNode.isExpanded) {
          expansionBehaviourController.expandNode(parentNode);
        } else {
          // if the node is expanded, add the items in the flatList and
          // the animatedList
          animatedListStateController.insertAll(
              parentIndex + parentNode.childrenAsList.length,
              List.from(event.items));
        }
        if (focusToNewNode) {
          expansionBehaviourController.scrollToLastVisibleChild(parentNode);
        }
      }
    }
  }

  @visibleForTesting
  void handleInsertItemsEvent(NodeInsertEvent<INode> event) {
    for (final node in event.items) {
      if (animatedListStateController.containsKey(node.path)) continue;

      if (node.isRoot || node.parent?.isRoot == true) {
        if (!(node.root as ITreeNode<Data>).isExpanded) {
          expansionBehaviourController.expandNode(node.root as ITreeNode<Data>);
        } else {
          animatedListStateController.insertAll(
              animatedListStateController.showRootNode
                  ? event.index + 1
                  : event.index,
              List.from(event.items));
        }
        if (focusToNewNode) {
          expansionBehaviourController.scrollToLastVisibleChild(node.root);
        }
      } else {
        final parentIndex = animatedListStateController.list
            .indexWhere((element) => element.key == node.parent?.key);
        if (parentIndex < 0) continue;

        final parentNode = animatedListStateController.list[parentIndex];

        if (!parentNode.isExpanded) {
          expansionBehaviourController.expandNode(parentNode);
        } else {
          animatedListStateController.insertAll(
              parentIndex + 1 + event.index, List.from(event.items));
        }
        if (focusToNewNode) {
          expansionBehaviourController.scrollToLastVisibleChild(parentNode);
        }
      }
    }
  }

  @visibleForTesting
  void handleRemoveItemsEvent(NodeRemoveEvent<INode> event) {
    for (final node in event.items) {
      if (!animatedListStateController.containsKey(node.path)) continue;

      //if item is in the root of the list, then remove the item
      if (animatedListStateController.list
          .any((item) => item.key == node.key)) {
        final index = animatedListStateController.indexOf(node);
        if (index < 0) continue;
        final removedItem = animatedListStateController.removeAt(index);

        if (removedItem.isExpanded) {
          //if the item is expanded, also remove its children
          animatedListStateController.removeAll(animatedListStateController.list
              .where((element) =>
                  !element.isRoot &&
                  (element.path).startsWith(removedItem.path))
              .toList());
        }
      }
    }
  }

  void dispose() {
    _addedNodesSubscription.cancel();
    _insertNodesSubscription?.cancel();
    _removeNodesSubscription.cancel();
  }
}

class AnimatedListStateController<Data> {
  final bool showRootNode;
  final ListState<ITreeNode<Data>> _listState;

  late final List<ITreeNode<Data>> _flatList;
  late final Map<String, ITreeNode<Data>> _itemsMap;

  AnimatedListStateController({
    required ListState<ITreeNode<Data>> listState,
    required this.showRootNode,
    required ITreeNode<Data> tree,
  }) : this._listState = listState {
    _flatList = List.from(showRootNode ? [tree] : tree.root.childrenAsList);
    _itemsMap = <String, ITreeNode<Data>>{
      for (final node in _flatList) node.path: node
    };
  }

  List<ITreeNode<Data>> get list => UnmodifiableListView(_flatList);

  int get length => _flatList.length;

  bool containsKey(String key) => _itemsMap.containsKey(key);

  int indexOf(INode item) => _flatList.indexWhere(
      (e) => e.parent?.key == item.parent?.key && e.key == item.key);

  void insert(int index, ITreeNode<Data> item) {
    _flatList.insert(index, item);
    _itemsMap[item.path] = item;
    _listState.insertItem(index);
  }

  void insertAll(int index, List<ITreeNode<Data>> items) {
    for (int i = 0; i < items.length; i++) {
      insert(index + i, items[i]);
    }
  }

  ITreeNode<Data> removeAt(int index) {
    if (index < 0 || index > _flatList.length)
      throw RangeError.index(index, _flatList);

    _itemsMap.remove(_flatList[index].path);
    final removedItem = _flatList.removeAt(index);
    _listState.removeItem(index, removedItem);

    return removedItem;
  }

  void remove(ITreeNode<Data> item) {
    final index = indexOf(item);
    if (index >= 0) removeAt(indexOf(item));
  }

  Future<void> removeAll(List<ITreeNode<Data>> items) async {
    await Future.wait(
      items.map((item) {
        item.expansionNotifier.value = false;
        return Future.microtask(() => remove(item));
      }),
    );
  }
}

class TreeViewExpansionBehaviourController<Data> {
  final AnimatedListStateController<Data> animatedListStateController;
  final AutoScrollController scrollController;
  ExpansionBehavior expansionBehavior;

  TreeViewExpansionBehaviourController({
    required this.scrollController,
    required this.expansionBehavior,
    required this.animatedListStateController,
  });

  Future scrollToIndex(int index) async => await scrollController.scrollToIndex(
        index,
        preferPosition: AutoScrollPosition.begin,
      );

  Future scrollToItem(ITreeNode<Data> item) async =>
      await scrollToIndex(animatedListStateController.indexOf(item));

  Future<void> collapseNode(ITreeNode<Data> item) async {
    final removeItems = animatedListStateController.list.where((element) =>
        (element.path).startsWith('${item.path}${INode.PATH_SEPARATOR}'));

    await animatedListStateController.removeAll(removeItems.toList());
    item.expansionNotifier.value = false;
  }

  void expandNode(ITreeNode<Data> item) {
    if (item.childrenAsList.isEmpty || item.isExpanded) return;

    animatedListStateController.insertAll(
      animatedListStateController.indexOf(item) + 1,
      List.from(item.childrenAsList),
    );

    item.expansionNotifier.value = true;
    item.cacheChildIndices();
  }

  Future<void> toggleExpansion(ITreeNode<Data> item) async {
    if (item.isExpanded)
      await collapseNode(item);
    else {
      expandNode(item);
      await applyExpansionBehavior(item);
    }
  }

  Future<void> applyExpansionBehavior(ITreeNode<Data> item) async {
    switch (expansionBehavior) {
      case ExpansionBehavior.none:
        break;
      case ExpansionBehavior.scrollToLastChild:
        await scrollToLastVisibleChild(item);
        break;
      case ExpansionBehavior.snapToTop:
        await snapToTop(item);
        break;
      case ExpansionBehavior.collapseOthers:
        await collapseAllOtherSiblingNodes(item);
        break;
      case ExpansionBehavior.collapseOthersAndSnapToTop:
        await collapseAllOtherSiblingNodes(item);
        await snapToTop(
          item,
          delay: animationDuration + Duration(milliseconds: 100),
        );
        break;
    }
  }

  Future<void> scrollToLastVisibleChild(INode parent) async {
    final lastChild = parent.childrenAsList.lastOrNull;
    if (lastChild == null) return;

    await Future.delayed(animationDuration);

    //get the index of the last child in the node
    final lastChildIndex = animatedListStateController.indexOf(lastChild);

    //scroll to the last child if it is not visible in the viewPort
    if (!scrollController.isIndexStateInLayoutRange(lastChildIndex +
        parent.level.clamp(1, 1000) +
        parent.childrenAsList.length)) {
      await scrollController.scrollToIndex(
          lastChildIndex < animatedListStateController.list.length - 1
              ? lastChildIndex + 1
              : lastChildIndex,
          preferPosition: AutoScrollPosition.end);
    }
  }

  Future<void> snapToTop(ITreeNode<Data> item,
      {Duration delay = animationDuration}) async {
    await Future.delayed(delay);

    await scrollController.scrollToIndex(
      animatedListStateController.indexOf(item),
      preferPosition: AutoScrollPosition.begin,
    );
  }

  Future<void> collapseAllOtherSiblingNodes(ITreeNode<Data> node) async {
    await Future.wait(
      (node.parent?.childrenAsList ?? []).map((siblingNode) {
        if (siblingNode.key != node.key &&
            (siblingNode as ITreeNode).isExpanded) {
          return collapseNode(siblingNode as ITreeNode<Data>);
        }
        return Future.value();
      }),
    );
  }
}
