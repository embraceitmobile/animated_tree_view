import 'package:flutter/material.dart';
import 'package:multi_level_list_view/listenables/listenable_list.dart';
import 'package:multi_level_list_view/models/entry.dart';
import 'package:multi_level_list_view/utils/utils.dart';

import 'multilevel_listview_controller.dart';

class AnimatedListController<T extends Entry<T>> {
  static const TAG = "AnimatedListController";

  final GlobalKey<AnimatedListState> _listKey;
  final MultiLevelListViewController<T> _listViewController;
  final dynamic _removedItemBuilder;
  ListenableList<T> _items = ListenableList();

  AnimatedListController(
      {@required GlobalKey<AnimatedListState> listKey,
      @required dynamic removedItemBuilder,
      MultiLevelListViewController listViewController,
      List<T> initialItems = const []})
      : _listKey = listKey,
        _removedItemBuilder = removedItemBuilder,
        _listViewController = listViewController,
        assert(listKey != null),
        assert(removedItemBuilder != null) {
    Utils.normalize<T>(initialItems).then((list) => _items.value = list);
    if (listViewController != null) {
      _listViewController.insertItemsStream.listen((event) {
        Utils.normalize<T>(event.items).then((list) {});
      });
      _listViewController.removeItemsStream.listen((event) {});
    }
  }

  ListenableList<T> get list => _items;

  int get length => _items.length;

  T operator [](int index) => _items[index];

  int indexOf(T item) => _items.indexOf(item);

  AnimatedListState get _animatedList => _listKey.currentState;

  void insert(int index, T item) {
    _items.insert(index, item);
    _animatedList.insertItem(index);
  }

  void insertAll(int index, List<T> items) {
    for (int i = 0; i < items.length; i++) {
      insert(index + i, items[i]);
    }
  }

  T removeAt(int index) {
    final T removedItem = _items.removeAt(index);
    if (removedItem != null) {
      _animatedList.removeItem(
        index,
        (BuildContext context, Animation<double> animation) =>
            _removedItemBuilder(removedItem, context, animation),
      );
    }
    return removedItem;
  }

  void removeAll(List<T> items) {
    for (final item in items) {
      item.isExpanded = false;
      Future.microtask(() => removeAt(indexOf(item)));
    }
  }

  void toggleExpansion(T item) {
    if (item.isExpanded) {
      final removeItems = _items.where((element) => element.entryPath
          .startsWith(
              '${item.entryPath}${Entry.PATH_SEPARATOR}${item.key}'));

      removeAll(removeItems.toList());
    } else {
      if (item.children.isEmpty) return;
      final index = _items.indexWhere(
              (e) => e.entryPath == item.entryPath && e.key == item.key) +
          1;
      insertAll(index, item.children);
    }

    item.isExpanded = !item.isExpanded;
  }
}
