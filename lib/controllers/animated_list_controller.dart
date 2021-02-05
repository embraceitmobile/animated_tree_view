import 'package:flutter/material.dart';
import 'package:multi_level_list_view/interfaces/iterable_tree_update_provider.dart';
import 'package:multi_level_list_view/interfaces/listenable_iterable_tree.dart';
import 'package:multi_level_list_view/listenables/listenable_list.dart';
import 'package:multi_level_list_view/tree_structures/node.dart';

class AnimatedListController<T extends Node<T>> {
  static const TAG = "AnimatedListController";

  final GlobalKey<AnimatedListState> _listKey;
  final ListenableIterableTree<T> _listenableIterableTree;
  final dynamic _removedItemBuilder;
  final ListenableList<Node<T>> _items;

  AnimatedListController(
      {required GlobalKey<AnimatedListState> listKey,
      required dynamic removedItemBuilder,
      required ListenableIterableTree<T> tree})
      : _listKey = listKey,
        _items = ListenableList.from(tree.root.children),
        _removedItemBuilder = removedItemBuilder,
        _listenableIterableTree = tree,
        assert(listKey != null),
        assert(removedItemBuilder != null) {
    if (tree != null) {
      _listenableIterableTree.addedItems.listen(handleAddItemsEvent);
      _listenableIterableTree.insertedItems.listen(handleInsertItemsEvent);
      _listenableIterableTree.removedItems.listen(handleRemoveItemsEvent);
    }
  }

  ListenableList<Node<T>> get list => _items;

  int get length => _items.length;

  AnimatedListState? get _animatedList => _listKey.currentState;

  int indexOf(T item) =>
      _items.nodeIndexWhere((e) => e.path == item.path && e.key == item.key);

  void insert(int index, Node<T> item) {
    _items.insert(index, item);
    _animatedList!.insertItem(index);
  }

  void insertAll(int index, List<Node<T>> items) {
    for (int i = 0; i < items.length; i++) {
      insert(index + i, items[i]);
    }
  }

  Node<T> removeAt(int index) {
    final removedItem = _items.removeAt(index);
    if (removedItem != null) {
      _animatedList!.removeItem(
        index,
        (BuildContext context, Animation<double> animation) =>
            _removedItemBuilder(removedItem, context, animation),
      );
    }
    return removedItem;
  }

  void remove(Node<T> item) => removeAt(indexOf(item as T));

  void removeAll(List<Node<T>> items) {
    for (final item in items) {
      item.isExpanded = false;
      Future.microtask(() => removeAt(indexOf(item as T)));
    }
  }

  List<Node<T>> childrenAt([String? path]) {
    if (path?.isEmpty ?? true) return _items.value;
    var children = _items.value;
    var nodes = Node.normalizePath(path).split(Node.PATH_SEPARATOR);
    for (final node in nodes) {
      children = children.firstWhere((element) => node == element.key).children;
    }
    return children;
  }

  void collapseNode(Node<T> item) {
    final removeItems = _items.where((element) => element.path!
        .startsWith('${item.path}${Node.PATH_SEPARATOR}${item.key}'));

    removeAll(removeItems.toList());
    item.isExpanded = false;
  }

  void expandNode(Node<T> item) {
    if (item.children.isEmpty) return;
    insertAll(indexOf(item as T) + 1, item.children);
    item.isExpanded = true;
  }

  void toggleExpansion(T item) {
    if (item.isExpanded)
      collapseNode(item);
    else
      expandNode(item);
  }

  @visibleForTesting
  void handleAddItemsEvent(NodeEvent<T> event) {
    final parentKey = event.path!.split(Node.PATH_SEPARATOR).last;
    final parentIndex =
        _items.indexWhere((element) => element.key == parentKey);
    if (parentIndex < 0) return;

    final parentNode = _items[parentIndex];
    for (final item in event.items) {
      item.path = event.path;
    }

    if (!parentNode.isExpanded) {
      expandNode(parentNode);
    } else {
      // if the node is expanded, add the items in the flatList and
      // the animatedList
      insertAll(parentIndex + parentNode.children.length, event.items);
    }
  }

  @visibleForTesting
  void handleInsertItemsEvent(NodeEvent<T> event) {
    //check if the path is visible in the animatedList
    if (_items.any((item) => item.path == event.path)) {
      // get the last child in the path
      final firstChild =
          _items.firstWhere((element) => element.path == event.path);
      // for visible path, add the items in the flatList and the animatedList
      insertAll(indexOf(firstChild as T) + event.index!, event.items);
    }
  }

  @visibleForTesting
  void handleRemoveItemsEvent(NodeEvent<T> event) {
    for (final item in event.items) {
      //if item is in the root of the list, then remove the item
      if (_items.contains(item)) {
        remove(item);

        if (item.isExpanded) {
          //if the item is expanded, also remove its children
          removeAll(_items
              .where((element) => element.path!.startsWith(item.childrenPath))
              .toList());
        }
      }
      // if item is not in the root list, then remove its value from the _items
      if (Node.normalizePath(item.path).isNotEmpty ?? false) {
        childrenAt(item.path).remove(item);
      }
    }
  }
}
