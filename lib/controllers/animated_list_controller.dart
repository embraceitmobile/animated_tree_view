import 'package:flutter/material.dart';
import 'package:multi_level_list_view/collections/node_collections.dart';
import 'package:multi_level_list_view/iterable_tree/listenable_iterable_tree.dart';
import 'package:multi_level_list_view/listenables/listenable_list.dart';

class AnimatedListController<T extends Node<T>> {
  static const TAG = "AnimatedListController";

  final GlobalKey<AnimatedListState> _listKey;
  final ListenableIterableTree<T> _listenableIterableTree;
  final dynamic _removedItemBuilder;
  final ListenableList<Node<T>> _items;

  AnimatedListController(
      {@required GlobalKey<AnimatedListState> listKey,
      @required dynamic removedItemBuilder,
      ListenableIterableTree<T> tree})
      : _listKey = listKey,
        _items = ListenableList.from(tree.root.children),
        _removedItemBuilder = removedItemBuilder,
        _listenableIterableTree = tree,
        assert(listKey != null),
        assert(removedItemBuilder != null) {
    if (tree != null) {
      _listenableIterableTree.addedItems.listen((event) {
        //TODO: add items to animated list
      });
      _listenableIterableTree.insertedItems.listen((event) {
        //TODO: insert items in animated list
      });
      _listenableIterableTree.removedItems.listen((event) {
        //TODO: remove items from animated list
      });
    }
  }

  ListenableList<Node<T>> get list => _items;

  int get length => _items.length;

  T operator [](int index) => _items[index];

  int indexOf(T item) => _items.indexOf(item);

  AnimatedListState get _animatedList => _listKey.currentState;

  void insert(int index, Node<T> item) {
    _items.insert(index, item);
    _animatedList.insertItem(index);
  }

  void insertAll(int index, List<Node<T>> items) {
    for (int i = 0; i < items.length; i++) {
      insert(index + i, items[i]);
    }
  }

  Node<T> removeAt(int index) {
    final removedItem = _items.removeAt(index);
    if (removedItem != null) {
      _animatedList.removeItem(
        index,
        (BuildContext context, Animation<double> animation) =>
            _removedItemBuilder(removedItem, context, animation),
      );
    }
    return removedItem;
  }

  void removeAll(List<Node<T>> items) {
    for (final item in items) {
      item.isExpanded = false;
      Future.microtask(() => removeAt(indexOf(item)));
    }
  }

  void toggleExpansion(Node<T> item) {
    if (item.isExpanded) {
      final removeItems = _items.where((element) => element.path
          .startsWith('${item.path}${Node.PATH_SEPARATOR}${item.key}'));

      removeAll(removeItems.toList());
    } else {
      if (item.children.isEmpty) return;
      item.populateChildrenPath();

      final index =
          _items.indexWhere((e) => e.path == item.path && e.key == item.key) +
              1;
      insertAll(index, item.children);
    }

    item.isExpanded = !item.isExpanded;
  }
}
