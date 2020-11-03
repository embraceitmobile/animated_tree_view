
import 'package:multi_level_list_view/collections/node_collections.dart';

abstract class IterableTree<T extends Node<T>> {
  external factory IterableTree();

  external factory IterableTree.from(List<Node<T>> list);

  Node<T> get root;

  void add(T item, {String path});

  void addAll(Iterable<T> items, {String path});

  void insert(T item, int index, {String path});

  void insertAll(Iterable<T> iterable, int index, {String path});

  void remove(T value, {String path});

  void removeItems(Iterable<Node<T>> iterable, {String path});

  T removeAt(int index, {String path});

  Iterable<Node<T>> clearAll({String path});
}
