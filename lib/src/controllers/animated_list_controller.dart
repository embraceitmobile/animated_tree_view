import 'dart:async';

import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:animated_tree_view/src/expandable_node/expandable_node.dart';
import 'package:animated_tree_view/src/listenable_node/base/i_listenable_node.dart';
import 'package:animated_tree_view/src/node/base/i_node.dart';
import 'package:animated_tree_view/src/tree_view.dart';
import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class AnimatedListController<T extends INode<T>> {
  static const TAG = "AnimatedListController";

  final GlobalKey<AnimatedListState> _listKey;
  final dynamic _removedItemBuilder;
  final NodeUpdateNotifier<T> _nodeUpdateNotifier;
  final List<T> _flatList;
  final AutoScrollController scrollController;
  final bool showRootNode;
  final ExpansionBehavior expansionBehavior;

  late StreamSubscription<NodeAddEvent<T>> _addedNodesSubscription;
  late StreamSubscription<NodeInsertEvent<T>>? _insertNodesSubscription;
  late StreamSubscription<NodeRemoveEvent<T>> _removeNodesSubscription;

  AnimatedListController(
      {required GlobalKey<AnimatedListState> listKey,
      required dynamic removedItemBuilder,
      required IListenableNode<T> listenableNode,
      required this.scrollController,
      required this.expansionBehavior,
      this.showRootNode = true})
      : _listKey = listKey,
        _nodeUpdateNotifier = listenableNode,
        _removedItemBuilder = removedItemBuilder,
        _flatList = List.from(showRootNode
            ? [listenableNode]
            : listenableNode.root.childrenAsList),
        assert(removedItemBuilder != null) {
    _addedNodesSubscription =
        _nodeUpdateNotifier.addedNodes.listen(handleAddItemsEvent);
    _removeNodesSubscription =
        _nodeUpdateNotifier.removedNodes.listen(handleRemoveItemsEvent);
    if (T is ListenableIndexedNode)
      _insertNodesSubscription =
          _nodeUpdateNotifier.insertedNodes.listen(handleInsertItemsEvent);
  }

  List<T> get list => _flatList;

  int get length => _flatList.length;

  AnimatedListState get _animatedList => _listKey.currentState!;

  int indexOf(T item) => _flatList.indexWhere(
      (e) => e.parent?.key == item.parent?.key && e.key == item.key);

  void insert(int index, T item) {
    _flatList.insert(index, item);
    _animatedList.insertItem(index);
  }

  void insertAll(int index, List<T> items) {
    for (int i = 0; i < items.length; i++) {
      insert(index + i, items[i]);
    }
  }

  T removeAt(int index) {
    if (index < 0 || index > _flatList.length)
      throw RangeError.index(index, _flatList);

    final removedItem = _flatList.removeAt(index);
    _animatedList.removeItem(
      index,
      (context, animation) =>
          _removedItemBuilder(removedItem, context, animation),
    );

    return removedItem;
  }

  void remove(T item) {
    final index = indexOf(item);
    if (index >= 0) removeAt(indexOf(item));
  }

  void removeAll(List<T> items) {
    for (final item in items) {
      item.setExpanded(false);
      Future.microtask(() => remove(item));
    }
  }

  Future scrollToIndex(int index) async => scrollController.scrollToIndex(index,
      preferPosition: AutoScrollPosition.begin);

  Future scrollToItem(T item) async => scrollToIndex(indexOf(item));

  void collapseNode(T item) {
    final removeItems = _flatList.where((element) =>
        (element.path).startsWith('${item.path}${INode.PATH_SEPARATOR}'));

    removeAll(removeItems.toList());
    item.setExpanded(false);
  }

  void expandNode(T item) {
    if (item.childrenAsList.isEmpty) return;
    insertAll(indexOf(item) + 1, List.from(item.childrenAsList));
    item.setExpanded(true);
  }

  void toggleExpansion(T item) {
    if (item.isExpanded)
      collapseNode(item);
    else {
      expandNode(item);
      applyExpansionBehavior(item);
    }
  }

  void applyExpansionBehavior(T item) {
    switch (expansionBehavior) {
      case ExpansionBehavior.none:
        break;
      case ExpansionBehavior.scrollToLastChild:
        scrollToLastVisibleChild(item);
        break;
      case ExpansionBehavior.snapToTop:
        snapToTop(item);
        break;
      case ExpansionBehavior.collapseOthers:
        collapseAllOtherSiblingNodes(item);
        break;
      case ExpansionBehavior.collapseOthersAndSnapToTop:
        collapseAllOtherSiblingNodes(item);
        snapToTop(item, delay: Duration(milliseconds: 400));
        break;
    }
  }

  void scrollToLastVisibleChild(T parent) {
    Future.delayed(Duration(milliseconds: 300), () {
      //get the index of the last child in the node
      final lastChildIndex = indexOf(parent.childrenAsList.last as T);

      //scroll to the last child if it is not visible in the viewPort
      if (!scrollController.isIndexStateInLayoutRange(lastChildIndex +
          parent.level.clamp(1, 1000) +
          parent.childrenAsList.length)) {
        scrollController.scrollToIndex(
            lastChildIndex < _flatList.length - 1
                ? lastChildIndex + 1
                : lastChildIndex,
            preferPosition: AutoScrollPosition.end);
      }
    });
  }

  void snapToTop(T item, {Duration delay = const Duration(milliseconds: 300)}) {
    Future.delayed(delay, () {
      scrollController.scrollToIndex(indexOf(item),
          preferPosition: AutoScrollPosition.begin);
    });
  }

  void collapseAllOtherSiblingNodes(T node) {
    for (final siblingNode in node.parent?.childrenAsList ?? []) {
      if (siblingNode.key != node.key) {
        collapseNode(siblingNode as T);
      }
    }
  }

  @visibleForTesting
  void handleAddItemsEvent(NodeAddEvent<T> event) {
    for (final node in event.items) {
      if (node.isRoot || node.parent?.isRoot == true) {
        if (!node.root.isExpanded) {
          expandNode(node.root as T);
        } else {
          insertAll(_flatList.length, event.items);
        }
        scrollToLastVisibleChild(node.root as T);
      } else {
        final parentIndex =
            _flatList.indexWhere((element) => element.key == node.parent?.key);
        if (parentIndex < 0) continue;

        final parentNode = _flatList[parentIndex];

        if (!parentNode.isExpanded) {
          expandNode(parentNode);
        } else {
          // if the node is expanded, add the items in the flatList and
          // the animatedList
          insertAll(
              parentIndex + parentNode.childrenAsList.length, event.items);
        }
        scrollToLastVisibleChild(parentNode);
      }
    }
  }

  @visibleForTesting
  void handleInsertItemsEvent(NodeInsertEvent<T> event) {
    for (final node in event.items) {
      if (node.isRoot || node.parent?.isRoot == true) {
        if (!node.root.isExpanded) {
          expandNode(node.root as T);
        } else {
          insertAll(showRootNode ? event.index + 1 : event.index, event.items);
        }
        scrollToLastVisibleChild(node.root as T);
      } else {
        final parentIndex =
            _flatList.indexWhere((element) => element.key == node.parent?.key);
        if (parentIndex < 0) continue;

        final parentNode = _flatList[parentIndex];

        if (!parentNode.isExpanded) {
          expandNode(parentNode);
        } else {
          insertAll(parentIndex + 1 + event.index, event.items);
        }
        scrollToLastVisibleChild(parentNode);
      }
    }
  }

  @visibleForTesting
  void handleRemoveItemsEvent(NodeRemoveEvent<T> event) {
    for (final node in event.items) {
      //if item is in the root of the list, then remove the item
      if (_flatList.any((item) => item.key == node.key)) {
        final index = indexOf(node);
        if (index < 0) continue;
        final removedItem = removeAt(index);

        if (removedItem.isExpanded) {
          //if the item is expanded, also remove its children
          removeAll(_flatList
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
