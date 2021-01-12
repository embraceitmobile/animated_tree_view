import 'package:flutter/foundation.dart';
import 'package:multi_level_list_view/node/list_node.dart';
import 'package:multi_level_list_view/node/node.dart';
import 'package:multi_level_list_view/tree/base/i_listenable_tree.dart';
import 'package:multi_level_list_view/tree/base/i_tree.dart';
import 'package:multi_level_list_view/tree/indexed_tree.dart';
import 'package:multi_level_list_view/tree/tree_update_provider.dart';

class ListenableIndexedTree<T> extends ChangeNotifier
    with TreeUpdateProvider<T>
    implements IIndexedTree<T>, IListenableIndexedTree<T> {
  ListenableIndexedTree(IndexedTree<T> tree) : _value = tree;

  factory ListenableIndexedTree.fromList(List<Node<T>> list) =>
      ListenableIndexedTree(IndexedTree<T>.fromList(list));

  factory ListenableIndexedTree.fromMap(Map<String, Node<T>> map) =>
      ListenableIndexedTree(IndexedTree.fromMap(map));

  final IndexedTree<T> _value;

  @override
  ListNode<T> first;

  @override
  ListNode<T> last;

  @override
  Node<T> operator [](covariant at) {
    // TODO: implement []
    throw UnimplementedError();
  }

  @override
  void add(Node<T> value, {String path}) {
    // TODO: implement add
  }

  @override
  void addAll(Iterable<Node<T>> iterable, {String path}) {
    // TODO: implement addAll
  }

  @override
  void clear({String path}) {
    // TODO: implement clear
  }

  @override
  Node<T> elementAt(String path) {
    // TODO: implement elementAt
    throw UnimplementedError();
  }

  @override
  Node<T> firstWhere(bool Function(Node<T> element) test, {Node<T> Function() orElse, String path}) {
    // TODO: implement firstWhere
    throw UnimplementedError();
  }

  @override
  int indexWhere(bool Function(Node<T> element) test, {int start = 0, String path}) {
    // TODO: implement indexWhere
    throw UnimplementedError();
  }

  @override
  void insert(int index, Node<T> element, {String path}) {
    // TODO: implement insert
  }

  @override
  void insertAfter(Node<T> element, {String path}) {
    // TODO: implement insertAfter
  }

  @override
  void insertAll(int index, Iterable<Node<T>> iterable, {String path}) {
    // TODO: implement insertAll
  }

  @override
  void insertBefore(Node<T> element, {String path}) {
    // TODO: implement insertBefore
  }

  @override
  Node<T> lastWhere(bool Function(Node<T> element) test, {Node<T> Function() orElse, String path}) {
    // TODO: implement lastWhere
    throw UnimplementedError();
  }

  @override
  // TODO: implement length
  int get length => throw UnimplementedError();

  @override
  void remove(Node<T> element, {String path}) {
    // TODO: implement remove
  }

  @override
  void removeAll(Iterable<Node<T>> iterable, {String path}) {
    // TODO: implement removeAll
  }

  @override
  Node<T> removeAt(int index, {String path}) {
    // TODO: implement removeAt
    throw UnimplementedError();
  }

  @override
  void removeWhere(bool Function(Node<T> element) test, {String path}) {
    // TODO: implement removeWhere
  }

  @override
  // TODO: implement root
  Node<T> get root => throw UnimplementedError();

  @override
  // TODO: implement value
  IndexedTree<T> get value => throw UnimplementedError();




}
