import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:animated_tree_view/helpers/exceptions.dart';
import 'package:animated_tree_view/node/base/i_node.dart';
import 'package:animated_tree_view/tree_view/tree_node.dart';
import 'package:animated_tree_view/tree_view/tree_view.dart';
import 'package:animated_tree_view/listenable_node/base/i_listenable_node.dart';
import 'package:collection/collection.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

abstract class ListState<Tree> {
  void insertItem(int index,
      {Duration duration = const Duration(milliseconds: 300)});

  void removeItem(int index, Tree item,
      {Duration duration = const Duration(milliseconds: 300)});
}

class AnimatedListController<Tree> {
  static const TAG = "AnimatedListController";

  final ListState _listState;
  final ITreeNode<Tree> tree;
  final AutoScrollController scrollController;
  final bool showRootNode;
  ExpansionBehavior expansionBehavior;

  late List<ITreeNode<Tree>> _flatList;
  late Map<String, ITreeNode<Tree>> _itemsMap;
  late StreamSubscription<NodeAddEvent<INode>> _addedNodesSubscription;
  late StreamSubscription<NodeRemoveEvent<INode>> _removeNodesSubscription;
  StreamSubscription<NodeInsertEvent<INode>>? _insertNodesSubscription;

  AnimatedListController({
    required ListState listState,
    required this.tree,
    required this.scrollController,
    required this.expansionBehavior,
    this.showRootNode = true,
  }) : _listState = listState {
    _flatList = List.from(showRootNode ? [tree] : tree.root.childrenAsList);
    _itemsMap = <String, ITreeNode<Tree>>{
      for (final node in _flatList) node.path: node
    };

    _addedNodesSubscription = tree.addedNodes.listen(handleAddItemsEvent);
    _removeNodesSubscription = tree.removedNodes.listen(handleRemoveItemsEvent);

    try {
      _insertNodesSubscription =
          tree.insertedNodes.listen(handleInsertItemsEvent);
    } on ActionNotAllowedException catch (_) {}
  }

  List<ITreeNode<Tree>> get list => _flatList;

  int get length => _flatList.length;

  int indexOf(INode item) => _flatList.indexWhere(
      (e) => e.parent?.key == item.parent?.key && e.key == item.key);

  void insert(int index, ITreeNode<Tree> item) {
    _flatList.insert(index, item);
    _itemsMap[item.path] = item;
    _listState.insertItem(index);
  }

  void insertAll(int index, List<ITreeNode<Tree>> items) {
    for (int i = 0; i < items.length; i++) {
      insert(index + i, items[i]);
    }
  }

  ITreeNode<Tree> removeAt(int index) {
    if (index < 0 || index > _flatList.length)
      throw RangeError.index(index, _flatList);

    _itemsMap.remove(_flatList[index].path);
    final removedItem = _flatList.removeAt(index);
    _listState.removeItem(index, removedItem);

    return removedItem;
  }

  void remove(ITreeNode<Tree> item) {
    final index = indexOf(item);
    if (index >= 0) removeAt(indexOf(item));
  }

  void removeAll(List<ITreeNode<Tree>> items) {
    for (final item in items) {
      item.isExpanded = false;
      Future.microtask(() => remove(item));
    }
  }

  Future scrollToIndex(int index) async => scrollController.scrollToIndex(index,
      preferPosition: AutoScrollPosition.begin);

  Future scrollToItem(ITreeNode<Tree> item) async =>
      scrollToIndex(indexOf(item));

  void collapseNode(ITreeNode<Tree> item) {
    final removeItems = _flatList.where((element) =>
        (element.path).startsWith('${item.path}${INode.PATH_SEPARATOR}'));

    removeAll(removeItems.toList());
    item.isExpanded = false;
  }

  void expandNode(ITreeNode<Tree> item) {
    if (item.childrenAsList.isEmpty) return;
    insertAll(indexOf(item) + 1, List.from(item.childrenAsList));
    item.isExpanded = true;
  }

  void toggleExpansion(ITreeNode<Tree> item) {
    if (item.isExpanded)
      collapseNode(item);
    else {
      expandNode(item);
      applyExpansionBehavior(item);
    }
  }

  void applyExpansionBehavior(ITreeNode<Tree> item) {
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
    final lastChild = parent.childrenAsList.lastOrNull;
    if (lastChild == null) return;

    Future.delayed(Duration(milliseconds: 300), () {
      //get the index of the last child in the node
      final lastChildIndex = indexOf(lastChild);

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

  void snapToTop(ITreeNode<Tree> item,
      {Duration delay = const Duration(milliseconds: 300)}) {
    Future.delayed(delay, () {
      scrollController.scrollToIndex(indexOf(item),
          preferPosition: AutoScrollPosition.begin);
    });
  }

  void collapseAllOtherSiblingNodes(ITreeNode<Tree> node) {
    for (final siblingNode in node.parent?.childrenAsList ?? []) {
      if (siblingNode.key != node.key &&
          (siblingNode as ITreeNode).isExpanded) {
        collapseNode(siblingNode as ITreeNode<Tree>);
      }
    }
  }

  @visibleForTesting
  void handleAddItemsEvent(NodeAddEvent<INode> event) {
    for (final node in event.items) {
      if (_itemsMap.containsKey(node.path)) continue;

      if (node.isRoot || node.parent?.isRoot == true) {
        final root = node.root as ITreeNode<Tree>;
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
        if (!(node.root as ITreeNode<Tree>).isExpanded) {
          expandNode(node.root as ITreeNode<Tree>);
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
