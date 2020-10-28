import 'package:flutter/material.dart';
import 'package:multi_level_list_view/listenables/listenable_list.dart';
import 'package:multi_level_list_view/models/entry.dart';
import 'package:multi_level_list_view/utils/utils.dart';

class AnimatedListController<T extends MultiLevelEntry<T>> {
  static const TAG = "AnimatedListController";

  final GlobalKey<AnimatedListState> listKey;
  final dynamic removedItemBuilder;
  ListenableList<T> _items = ListenableList();

  AnimatedListController(
      {@required this.listKey,
      @required this.removedItemBuilder,
      List<T> initialItems = const []})
      : assert(listKey != null),
        assert(removedItemBuilder != null) {
    Utils.normalize<T>(initialItems).then((list) => _items.value = list);
  }

  ListenableList<T> get list => _items;

  int get length => _items.length;

  T operator [](int index) => _items[index];

  int indexOf(T item) => _items.indexOf(item);

  AnimatedListState get _animatedList => listKey.currentState;

  void insert(int index, T item) {
    _items.insert(index, item);
    _animatedList.insertItem(index);
  }

  T removeAt(int index) {
    final T removedItem = _items.removeAt(index);
    if (removedItem != null) {
      _animatedList.removeItem(
        index,
        (BuildContext context, Animation<double> animation) =>
            removedItemBuilder(removedItem, context, animation),
      );
    }
    return removedItem;
  }

  void toggleExpansion(T item) {
    if (item.isExpanded) {
      final removeItems = _items.where((element) => element.entryPath
          .startsWith(
              '${item.entryPath}${MultiLevelEntry.PATH_SEPARATOR}${item.id}'));

      for (final item in removeItems) {
        item.isExpanded = false;
        Future.microtask(() => removeAt(indexOf(item)));
      }
    } else {
      if (item.children.isEmpty) return;
      final index = _items.indexWhere(
              (e) => e.entryPath == item.entryPath && e.id == item.id) +
          1;
      for (int i = 0; i < item.children.length; i++) {
        insert(index + i, item.children[i]);
      }
    }

    item.isExpanded = !item.isExpanded;
  }
}
