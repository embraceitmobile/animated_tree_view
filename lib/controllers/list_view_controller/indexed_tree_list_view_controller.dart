import 'package:tree_structure_view/controllers/animated_list_controller.dart';
import 'package:tree_structure_view/listenable_collections/listenable_indexed_tree.dart';
import 'package:tree_structure_view/node/indexed_node.dart';
import 'package:tree_structure_view/node/base/i_node.dart';
import 'package:tree_structure_view/tree/base/i_tree.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:tree_structure_view/tree_structure_view.dart';
import 'base/i_tree_list_view_controller.dart';

class IndexedTreeListViewController<T extends INode<T>>
    implements ITreeListViewController<T>, IIndexedTree<T> {
  late ListenableIndexedTree<T> _listenableTree;
  late AnimatedListController _listController;
  late AutoScrollController _scrollController;

  IndexedTreeListViewController();

  void attach(
      {required IIndexedTree<T> tree,
      required AnimatedListController listController,
      required AutoScrollController scrollController}) {
    _listenableTree = ListenableIndexedTree(tree as IndexedTree<T>);
    _listController = listController;
    _scrollController = scrollController;
  }

  void scrollToIndex(int index) => _scrollController.scrollToIndex(index);

  void scrollToItem(T item) =>
      _scrollController.scrollToIndex(_listController.indexOf(item));

  void toggleNodeExpandCollapse(INode<T> item) =>
      _listController.toggleExpansion(item);

  INode<T> get root => _listenableTree.root;

  int get length => _listenableTree.length;

  INode<T> elementAt(String? path) => _listenableTree.elementAt(path);

  INode<T> operator [](String at) => _listenableTree[at];

  IndexedNode<T> at(int index) => _listenableTree.at(index);

  IndexedNode<T> get first => _listenableTree.first;

  set first(IndexedNode<T> value) {
    _listenableTree.first = value;
  }

  IndexedNode<T> get last => _listenableTree.last;

  set last(IndexedNode<T> value) {
    _listenableTree.last = value;
  }

  IndexedNode<T> firstWhere(bool Function(IndexedNode<T> element) test,
      {IndexedNode<T> orElse()?, String? path}) {
    return _listenableTree.firstWhere(test, orElse: orElse);
  }

  IndexedNode<T> lastWhere(bool Function(IndexedNode<T> element) test,
      {IndexedNode<T> orElse()?, String? path}) {
    return _listenableTree.lastWhere(test, orElse: orElse);
  }

  int indexWhere(bool Function(INode<T> element) test,
      {int start = 0, String? path}) {
    return _listenableTree.indexWhere(test, start: start, path: path);
  }

  void add(INode<T> value, {String? path}) =>
      _listenableTree.add(value, path: path);

  void addAll(Iterable<INode<T>> iterable, {String? path}) =>
      _listenableTree.addAll(iterable, path: path);

  void insert(int index, IndexedNode<T> element, {String? path}) {
    _listenableTree.insert(index, element, path: path);
  }

  int insertAfter(IndexedNode<T> after, IndexedNode<T> element, {String? path}) {
    return _listenableTree.insertAfter(after, element, path: path);
  }

  void insertAll(int index, Iterable<IndexedNode<T>> iterable, {String? path}) {
    _listenableTree.insertAll(index, iterable, path: path);
  }

  int insertBefore(IndexedNode<T> before, IndexedNode<T> element, {String? path}) {
    return _listenableTree.insertBefore(before, element, path: path);
  }

  void remove(String key, {String? path}) =>
      _listenableTree.remove(key, path: path);

  INode<T> removeAt(int index, {String? path}) {
    return _listenableTree.removeAt(index, path: path);
  }

  void removeAll(Iterable<String> keys, {String? path}) =>
      _listenableTree.removeAll(keys, path: path);

  void removeWhere(bool Function(INode<T> element) test, {String? path}) =>
      _listenableTree.removeWhere(test, path: path);

  void clear({String? path}) => _listenableTree.clear(path: path);
}
