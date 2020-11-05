import 'package:multi_level_list_view/controllers/animated_list_controller.dart';
import 'package:multi_level_list_view/interfaces/iterable_tree.dart';
import 'package:multi_level_list_view/interfaces/listenable_iterable_tree.dart';
import 'package:multi_level_list_view/tree_structures/node.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

abstract class MultiLevelListViewController<T extends Node<T>>
    implements IterableTree<T> {
  void attach(
      {IterableTree<T> tree,
      AnimatedListController listController,
      AutoScrollController scrollController});

  void scrollToItem(T item);

  void scrollToIndex(int index);

  void toggleNodeExpandCollapse(T item);
}

class EfficientMultiLevelListViewController<T extends Node<T>>
    implements MultiLevelListViewController<T> {
  ListenableIterableTree<T> _listenableTree;
  AnimatedListController _listController;
  AutoScrollController _scrollController;

  EfficientMultiLevelListViewController();

  void attach(
      {IterableTree<T> tree,
      AnimatedListController listController,
      AutoScrollController scrollController}) {
    _listenableTree = tree;
    _listController = listController;
    _scrollController = scrollController;
  }

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
  void scrollToIndex(int index) => _scrollController.scrollToIndex(index);

  @override
  void scrollToItem(T item) =>
      _scrollController.scrollToIndex(_listController.indexOf(item));

  @override
  void toggleNodeExpandCollapse(T item) =>
      _listController.toggleExpansion(item);
}

class InsertableMultiLevelListViewController<T extends Node<T>>
    implements MultiLevelListViewController<T>, InsertableIterableTree<T> {
  ListenableInsertableIterableTree<T> _listenableTree;
  AnimatedListController _listController;
  AutoScrollController _scrollController;

  InsertableMultiLevelListViewController();

  void attach(
      {IterableTree<T> tree,
      AnimatedListController listController,
      AutoScrollController scrollController}) {
    _listenableTree = tree;
    _listController = listController;
    _scrollController = scrollController;
  }

  @override
  Node<T> get root => _listenableTree.root;

  @override
  void add(T value, {String path}) => _listenableTree.add(value, path: path);

  @override
  void addAll(Iterable<T> iterable, {String path}) =>
      _listenableTree.addAll(iterable, path: path);

  @override
  void insert(T value, int index, {String path}) =>
      _listenableTree.insert(value, index, path: path);

  @override
  int insertBefore(T value, T itemBefore, {String path}) =>
      _listenableTree.insertBefore(value, itemBefore, path: path);

  @override
  int insertAfter(T value, T itemAfter, {String path}) =>
      _listenableTree.insertAfter(value, itemAfter, path: path);

  @override
  void insertAll(Iterable<T> iterable, int index, {String path}) =>
      _listenableTree.insertAll(iterable, index, path: path);

  @override
  int insertAllBefore(Iterable<T> iterable, T itemBefore, {String path}) =>
      _listenableTree.insertAllBefore(iterable, itemBefore, path: path);

  @override
  int insertAllAfter(Iterable<T> iterable, T itemAfter, {String path}) =>
      _listenableTree.insertAllAfter(iterable, itemAfter, path: path);

  @override
  void remove(T value) => _listenableTree.remove(value);

  @override
  T removeAt(int index, {String path}) =>
      _listenableTree.removeAt(index, path: path);

  @override
  void removeItems(Iterable<Node<T>> iterable) =>
      _listenableTree.removeItems(iterable);

  @override
  Iterable<Node<T>> clearAll({String path}) =>
      _listenableTree.clearAll(path: path);

  @override
  void scrollToIndex(int index) => _scrollController.scrollToIndex(index);

  @override
  void scrollToItem(T item) =>
      _scrollController.scrollToIndex(_listController.indexOf(item));

  @override
  void toggleNodeExpandCollapse(T item) =>
      _listController.toggleExpansion(item);
}
