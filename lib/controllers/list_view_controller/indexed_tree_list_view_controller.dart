import 'package:tree_structure_view/controllers/animated_list_controller.dart';
import 'package:tree_structure_view/listenable_collections/listenable_indexed_tree.dart';
import 'package:tree_structure_view/node/list_node.dart';
import 'package:tree_structure_view/node/node.dart';
import 'package:tree_structure_view/tree/base/i_tree.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:tree_structure_view/tree_structure_view.dart';
import 'base/i_tree_list_view_controller.dart';

class IndexedTreeListViewController<T extends Node<T>>
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

  void toggleNodeExpandCollapse(Node<T> item) =>
      _listController.toggleExpansion(item);

  Node<T> get root => _listenableTree.root;

  int get length => _listenableTree.length;

  Node<T> elementAt(String? path) => _listenableTree.elementAt(path);

  Node<T> operator [](String at) => _listenableTree[at];

  ListNode<T> get first => _listenableTree.first;

  set first(ListNode<T> value) {
    _listenableTree.first = value;
  }

  ListNode<T> get last => _listenableTree.last;

  set last(ListNode<T> value) {
    _listenableTree.last = value;
  }

  ListNode<T> firstWhere(bool Function(ListNode<T> element) test,
      {ListNode<T> orElse()?, String? path}) {
    return _listenableTree.firstWhere(test, orElse: orElse);
  }

  ListNode<T> lastWhere(bool Function(ListNode<T> element) test,
      {ListNode<T> orElse()?, String? path}) {
    return _listenableTree.lastWhere(test, orElse: orElse);
  }

  int indexWhere(bool Function(Node<T> element) test,
      {int start = 0, String? path}) {
    return _listenableTree.indexWhere(test, start: start, path: path);
  }

  void add(Node<T> value, {String? path}) =>
      _listenableTree.add(value, path: path);

  void addAll(Iterable<Node<T>> iterable, {String? path}) =>
      _listenableTree.addAll(iterable, path: path);

  void insert(int index, Node<T> element, {String? path}) {
    _listenableTree.insert(index, element, path: path);
  }

  int insertAfter(Node<T> element, {String? path}) {
    return _listenableTree.insertAfter(element, path: path);
  }

  void insertAll(int index, Iterable<Node<T>> iterable, {String? path}) {
    _listenableTree.insertAll(index, iterable, path: path);
  }

  int insertBefore(Node<T> element, {String? path}) {
    return _listenableTree.insertBefore(element, path: path);
  }

  void remove(String key, {String? path}) =>
      _listenableTree.remove(key, path: path);

  Node<T> removeAt(int index, {String? path}) {
    return _listenableTree.removeAt(index, path: path);
  }

  void removeAll(Iterable<String> keys, {String? path}) =>
      _listenableTree.removeAll(keys, path: path);

  void removeWhere(bool Function(Node<T> element) test, {String? path}) =>
      _listenableTree.removeWhere(test, path: path);

  void clear({String? path}) => _listenableTree.clear(path: path);
}
