import 'dart:async';
import 'package:flutter/material.dart';
import 'package:animated_tree_view/src/listenable_node/base/i_listenable_node.dart';
import 'package:animated_tree_view/animated_tree_view.dart';

class AnimatedListController<T> {
  static const TAG = "AnimatedListController";

  final GlobalKey<AnimatedListState> _listKey;
  final dynamic _removedItemBuilder;
  final ITreeNode<T> tree;
  final AutoScrollController scrollController;
  final bool showRootNode;
  ExpansionBehavior expansionBehavior;

  late List<ITreeNode<T>> _flatList;
  late Map<String, ITreeNode<T>> _itemsMap;
  late StreamSubscription<NodeAddEvent<INode>> _addedNodesSubscription;
  late StreamSubscription<NodeRemoveEvent<INode>> _removeNodesSubscription;
  StreamSubscription<NodeInsertEvent<INode>>? _insertNodesSubscription;

  AnimatedListController({
    required GlobalKey<AnimatedListState> listKey,
    required dynamic removedItemBuilder,
    required this.tree,
    required this.scrollController,
    required this.expansionBehavior,
    this.showRootNode = true,
  })  : _listKey = listKey,
        _removedItemBuilder = removedItemBuilder,
        assert(removedItemBuilder != null) {
    _flatList = List.from(showRootNode ? [tree] : tree.root.childrenAsList);
    _itemsMap = <String, ITreeNode<T>>{
      for (final node in _flatList) node.path: node
    };

    _addedNodesSubscription = tree.addedNodes.listen(handleAddItemsEvent);
    _removeNodesSubscription = tree.removedNodes.listen(handleRemoveItemsEvent);

    try {
      _insertNodesSubscription =
          tree.insertedNodes.listen(handleInsertItemsEvent);
    } on ActionNotAllowedException catch (_) {}
  }

  List<ITreeNode<T>> get list => _flatList;

  int get length => _flatList.length;

  AnimatedListState get _animatedList => _listKey.currentState!;

  int indexOf(INode item) => _flatList.indexWhere(
      (e) => e.parent?.key == item.parent?.key && e.key == item.key);

  void insert(int index, ITreeNode<T> item) {
    _flatList.insert(index, item);
    _itemsMap[item.path] = item;
    _animatedList.insertItem(index);
  }

  void insertAll(int index, List<ITreeNode<T>> items) {
    for (int i = 0; i < items.length; i++) {
      insert(index + i, items[i]);
    }
  }

  ITreeNode<T> removeAt(int index) {
    if (index < 0 || index > _flatList.length)
      throw RangeError.index(index, _flatList);

    _itemsMap.remove(_flatList[index].path);
    final removedItem = _flatList.removeAt(index);
    _animatedList.removeItem(
      index,
      (context, animation) =>
          _removedItemBuilder(removedItem, context, animation),
    );

    return removedItem;
  }

  void remove(ITreeNode<T> item) {
    final index = indexOf(item);
    if (index >= 0) removeAt(indexOf(item));
  }

  void removeAll(List<ITreeNode<T>> items) {
    for (final item in items) {
      item.isExpanded = false;
      Future.microtask(() => remove(item));
    }
  }

  Future scrollToIndex(int index) async => scrollController.scrollToIndex(index,
      preferPosition: AutoScrollPosition.begin);

  Future scrollToItem(ITreeNode<T> item) async => scrollToIndex(indexOf(item));

  void collapseNode(ITreeNode<T> item) {
    final removeItems = _flatList.where((element) =>
        (element.path).startsWith('${item.path}${INode.PATH_SEPARATOR}'));

    removeAll(removeItems.toList());
    item.isExpanded = false;
  }

  void expandNode(ITreeNode<T> item) {
    if (item.childrenAsList.isEmpty) return;
    insertAll(indexOf(item) + 1, List.from(item.childrenAsList));
    item.isExpanded = true;
  }

  void toggleExpansion(ITreeNode<T> item) {
    if (item.isExpanded)
      collapseNode(item);
    else {
      expandNode(item);
      applyExpansionBehavior(item);
    }
  }

  void applyExpansionBehavior(ITreeNode<T> item) {
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

  void scrollToLastVisibleChild(INode parent) {
    Future.delayed(Duration(milliseconds: 300), () {
      //get the index of the last child in the node
      final lastChildIndex = indexOf(parent.childrenAsList.last);

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

  void snapToTop(ITreeNode<T> item,
      {Duration delay = const Duration(milliseconds: 300)}) {
    Future.delayed(delay, () {
      scrollController.scrollToIndex(indexOf(item),
          preferPosition: AutoScrollPosition.begin);
    });
  }

  void collapseAllOtherSiblingNodes(ITreeNode<T> node) {
    for (final siblingNode in node.parent?.childrenAsList ?? []) {
      if (siblingNode.key != node.key &&
          (siblingNode as ITreeNode).isExpanded) {
        collapseNode(siblingNode as ITreeNode<T>);
      }
    }
  }

  @visibleForTesting
  void handleAddItemsEvent(NodeAddEvent<INode> event) {
    for (final node in event.items) {
      if (_itemsMap.containsKey(node.path)) continue;

      if (node.isRoot || node.parent?.isRoot == true) {
        final root = node.root as ITreeNode<T>;
        if (!root.isExpanded) {
          expandNode(root);
        } else {
          insertAll(_flatList.length, List.from(event.items));
        }
        scrollToLastVisibleChild(root);
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
          insertAll(parentIndex + parentNode.childrenAsList.length,
              List.from(event.items));
        }
        scrollToLastVisibleChild(parentNode);
      }
    }
  }

  @visibleForTesting
  void handleInsertItemsEvent(NodeInsertEvent<INode> event) {
    for (final node in event.items) {
      if (_itemsMap.containsKey(node.path)) continue;

      if (node.isRoot || node.parent?.isRoot == true) {
        if (!(node.root as ITreeNode<T>).isExpanded) {
          expandNode(node.root as ITreeNode<T>);
        } else {
          insertAll(showRootNode ? event.index + 1 : event.index,
              List.from(event.items));
        }
        scrollToLastVisibleChild(node.root);
      } else {
        final parentIndex =
            _flatList.indexWhere((element) => element.key == node.parent?.key);
        if (parentIndex < 0) continue;

        final parentNode = _flatList[parentIndex];

        if (!parentNode.isExpanded) {
          expandNode(parentNode);
        } else {
          insertAll(parentIndex + 1 + event.index, List.from(event.items));
        }
        scrollToLastVisibleChild(parentNode);
      }
    }
  }

  @visibleForTesting
  void handleRemoveItemsEvent(NodeRemoveEvent<INode> event) {
    for (final node in event.items) {
      if (!_itemsMap.containsKey(node.path)) continue;

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
