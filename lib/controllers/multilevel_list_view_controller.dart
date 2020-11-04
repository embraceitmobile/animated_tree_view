import 'package:multi_level_list_view/interfaces/iterable_tree.dart';
import 'package:multi_level_list_view/interfaces/listenable_iterable_tree.dart';
import 'package:multi_level_list_view/tree_structures/node.dart';

abstract class MultiLevelListViewController<T extends Node<T>>
    implements IterableTree<T> {
  void attachTree(IterableTree<T> listenableTree);
}

class EfficientMultiLevelListViewController<T extends Node<T>>
    implements MultiLevelListViewController<T> {
  ListenableIterableTree<T> _listenableTree;

  EfficientMultiLevelListViewController();

  void attachTree(IterableTree<T> listenableTree) =>
      this._listenableTree = listenableTree;

  @override
  Node<T> get root => _listenableTree.root;

  @override
  void add(T value, {String path}) => _listenableTree.add(value, path: path);

  @override
  void addAll(Iterable<T> iterable, {String path}) =>
      _listenableTree.addAll(iterable, path: path);

  @override
  Iterable<Node<T>> clearAll({String path}) =>
      _listenableTree.clearAll(path: path);

  @override
  void remove(T value) => _listenableTree.remove(value);

  @override
  void removeItems(Iterable<Node<T>> iterable) =>
      _listenableTree.removeItems(iterable);
}

class InsertableMultiLevelListViewController<T extends Node<T>>
    implements MultiLevelListViewController<T>, InsertableIterableTree<T> {
  ListenableInsertableIterableTree<T> _listenableTree;

  InsertableMultiLevelListViewController();

  void attachTree(IterableTree<T> listenableTree) =>
      this._listenableTree = listenableTree;

  @override
  Node<T> get root => _listenableTree.root;

  @override
  void add(T value, {String path}) => _listenableTree.add(value, path: path);

  @override
  void addAll(Iterable<T> iterable, {String path}) =>
      _listenableTree.addAll(iterable, path: path);

  @override
  Iterable<Node<T>> clearAll({String path}) =>
      _listenableTree.clearAll(path: path);

  @override
  void remove(T value) => _listenableTree.remove(value);

  @override
  void removeItems(Iterable<Node<T>> iterable) =>
      _listenableTree.removeItems(iterable);

  @override
  void insert(T value, int index, {String path}) =>
      _listenableTree.insert(value, index, path: path);

  @override
  void insertAll(Iterable<T> iterable, int index, {String path}) =>
      _listenableTree.insertAll(iterable, index, path: path);

  @override
  T removeAt(int index, {String path}) =>
      _listenableTree.removeAt(index, path: path);
}
