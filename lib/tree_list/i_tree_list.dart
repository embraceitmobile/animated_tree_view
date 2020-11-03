import 'package:multi_level_list_view/tree_list/node.dart';

abstract class ITreeList<T extends Node<T>> {
  external factory ITreeList();

  external factory ITreeList.from(List<Node<T>> list);

  void add(T item, {String path});

  void addAll(Iterable<T> items, {String path});

  void insert(T item, int index, {String path});

  void insertAll(Iterable<T> iterable, int index, {String path});

  void remove(T value, {String path});

  void removeItems(Iterable<Node<T>> iterable, {String path});

  T removeAt(int index, {String path});

  Iterable<Node<T>> clearAll({String path});
}
