import 'package:flutter/foundation.dart';
import 'package:multi_level_list_view/tree_list/i_tree_list.dart';
import 'package:multi_level_list_view/tree_list/node.dart';
import 'package:multi_level_list_view/tree_list/tree_list.dart';
import 'package:multi_level_list_view/tree_list/tree_list_update_provider.dart';

class ListenableTreeList<T extends Node<T>> extends ChangeNotifier
    with TreeListUpdateProvider<T>
    implements ITreeList<T>, ValueListenable<TreeList<T>> {
  ListenableTreeList._(TreeList<T> list) : _value = list;

  factory ListenableTreeList() => ListenableTreeList._(TreeList<T>());

  factory ListenableTreeList.from(List<Node<T>> list) =>
      ListenableTreeList._(TreeList.from(list));

  TreeList<T> _value;

  @protected
  @visibleForTesting
  @override
  TreeList<T> get value => _value;

  @override
  void add(T item, {String path}) {
    _value.add(item, path: path);
    notifyListeners();
    emitAddItems([item], path: path);
  }

  @override
  void addAll(Iterable<T> iterable, {String path}) {
    _value.addAll(iterable, path: path);
    notifyListeners();
    emitAddItems(iterable, path: path);
  }

  @override
  void insert(T item, int index, {String path}) {
    _value.insert(item, index, path: path);
    notifyListeners();
    emitInsertItems([item], index, path: path);
  }

  @override
  void insertAll(Iterable<T> iterable, int index, {String path}) {
    _value.insertAll(iterable, index, path: path);
    notifyListeners();
    emitInsertItems(iterable, index, path: path);
  }

  @override
  void remove(T value, {String path}) {
    _value.remove(value, path: path);
    notifyListeners();
    emitRemoveItems([value], path: path);
  }

  @override
  T removeAt(int index, {String path}) {
    final item = _value.removeAt(index, path: path);
    notifyListeners();
    emitRemoveItems([item], index: index, path: path);
    return item;
  }

  @override
  void removeItems(Iterable<Node<T>> iterable, {String path}) {
    _value.removeItems(iterable, path: path);
    notifyListeners();
    emitRemoveItems(iterable, path: path);
  }

  @override
  Iterable<Node<T>> clearAll({String path}) {
    final clearedItems = _value.clearAll(path: path);
    notifyListeners();
    emitRemoveItems(clearedItems, path: path);
    return clearedItems;
  }
}
