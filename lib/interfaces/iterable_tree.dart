import 'package:multi_level_list_view/tree_structures/node.dart';

abstract class IterableTree<T extends Node<T>> {
  external factory IterableTree();

  external factory IterableTree.from(List<Node<T>> list);

  Node<T> get root;

  void add(T value, {String path});

  void addAll(Iterable<T> iterable, {String path});

  void remove(T value, {String path});

  void removeItems(Iterable<Node<T>> iterable, {String path});

  Iterable<Node<T>> clearAll({String path});
}

abstract class InsertableIterableTree<T extends Node<T>>
    with IterableTree<T> {
  external factory InsertableIterableTree();

  external factory InsertableIterableTree.from(List<Node<T>> list);

  void insert(T value, int index, {String path});

  void insertAll(Iterable<T> iterable, int index, {String path});

  T removeAt(int index, {String path});
}
