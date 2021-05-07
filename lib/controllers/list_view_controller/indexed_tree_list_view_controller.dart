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

  @override
  void scrollToIndex(int index) {
    // TODO: implement scrollToIndex
  }

  @override
  void scrollToItem(T item) {
    // TODO: implement scrollToItem
  }

  @override
  void toggleNodeExpandCollapse(T item) {
    // TODO: implement toggleNodeExpandCollapse
  }

  @override
  ListNode<T>? first;

  @override
  ListNode<T>? last;

  @override
  Node<T> operator [](covariant at) {
    // TODO: implement []
    throw UnimplementedError();
  }

  @override
  void add(Node<T> value, {String? path}) {
    // TODO: implement add
  }

  @override
  void addAll(Iterable<Node<T>> iterable, {String? path}) {
    // TODO: implement addAll
  }

  @override
  void clear({String? path}) {
    // TODO: implement clear
  }

  @override
  Node<T> elementAt(String path) {
    // TODO: implement elementAt
    throw UnimplementedError();
  }

  @override
  Node<T> firstWhere(bool Function(Node<T> element) test,
      {Node<T> Function()? orElse, String? path}) {
    // TODO: implement firstWhere
    throw UnimplementedError();
  }

  @override
  int indexWhere(bool Function(Node<T> element) test,
      {int start = 0, String? path}) {
    // TODO: implement indexWhere
    throw UnimplementedError();
  }

  @override
  void insert(int index, Node<T> element, {String? path}) {
    // TODO: implement insert
  }

  @override
  void insertAfter(Node<T> element, {String? path}) {
    // TODO: implement insertAfter
  }

  @override
  void insertAll(int index, Iterable<Node<T>> iterable, {String? path}) {
    // TODO: implement insertAll
  }

  @override
  void insertBefore(Node<T> element, {String? path}) {
    // TODO: implement insertBefore
  }

  @override
  Node<T> lastWhere(bool Function(Node<T> element) test,
      {Node<T> Function()? orElse, String? path}) {
    // TODO: implement lastWhere
    throw UnimplementedError();
  }

  @override
  // TODO: implement length
  int get length => throw UnimplementedError();

  @override
  void remove(String key, {String? path}) {
    // TODO: implement remove
  }

  @override
  void removeAll(Iterable<String> keys, {String? path}) {
    // TODO: implement removeAll
  }

  @override
  Node<T> removeAt(int index, {String? path}) {
    // TODO: implement removeAt
    throw UnimplementedError();
  }

  @override
  void removeWhere(bool Function(Node<T> element) test, {String? path}) {
    // TODO: implement removeWhere
  }

  @override
  // TODO: implement root
  Node<T> get root => throw UnimplementedError();
}
