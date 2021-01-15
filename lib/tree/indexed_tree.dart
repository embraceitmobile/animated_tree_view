import 'package:flutter/material.dart';
import 'package:multi_level_list_view/node/list_node.dart';
import 'base/i_tree.dart';
import '../node/node.dart';

class IndexedTree<T> implements ITree<T>, IIndexedTree<T> {
  IndexedTree() : children = <ListNode<T>>[];

  factory IndexedTree.fromMap(Map<String, Node<T>> map) => IndexedTree();

  factory IndexedTree.fromList(List<Node<T>> list) => IndexedTree();

  final List<ListNode<T>> children;

  @override
  int get length => children.length;

  @override
  // TODO: implement root
  ListNode<T> get root => throw UnimplementedError();

  ListNode<T> operator [](int at) {
    // TODO: implement []
    throw UnimplementedError();
  }


  void add(Node<T> value, {String path}) {
    // TODO: implement add
  }

  void addAll(Iterable<Node<T>> iterable, {String path}) {
    // TODO: implement addAll
  }

  void clear({String path}) {
    // TODO: implement clear
  }

  ListNode<T> elementAt(String path) {
    // TODO: implement elementAt
    throw UnimplementedError();
  }

  void remove(String key, {String path}) {
    // TODO: implement remove
  }

  void removeAll(Iterable<String> keys, {String path}) {
    // TODO: implement removeAll
  }

  void removeWhere(bool Function(Node<T> element) test, {String path}) {
    // TODO: implement removeWhere
  }

  @override
  ListNode<T> first;

  @override
  ListNode<T> last;

  @override
  ListNode<T> firstWhere(bool Function(ListNode<T> element) test,
      {Node<T> Function() orElse, String path}) {
    // TODO: implement firstWhere
    throw UnimplementedError();
  }

  @override
  int indexWhere(bool Function(ListNode<T> element) test, {int start = 0, String path}) {
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
  ListNode<T> lastWhere(bool Function(Node<T> element) test,
      {Node<T> Function() orElse, String path}) {
    // TODO: implement lastWhere
    throw UnimplementedError();
  }

  @override
  ListNode<T> removeAt(int index, {String path}) {
    // TODO: implement removeAt
    throw UnimplementedError();
  }
}
