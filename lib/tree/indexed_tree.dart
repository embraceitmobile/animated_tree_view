import 'package:flutter/material.dart';
import 'base/i_tree.dart';
import '../node/node.dart';

class IndexedTree<T> implements ITree<T>, IIndexedTree<T> {
  IndexedTree() : children = <Node<T>>[];

  factory IndexedTree.fromMap(Map<String, Node<T>> map) => IndexedTree();

  factory IndexedTree.fromList(List<Node<T>> list) => IndexedTree();

  final List<Node<T>> children;

  @override
  int get length => children.length;

  @override
  // TODO: implement root
  Node<T> get root => throw UnimplementedError();

  Node<T> operator [](int at) {
    // TODO: implement []
    throw UnimplementedError();
  }

  void operator []=(int at, Node<T> value) {
    // TODO: implement []=
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

  Node<T> elementAt(String path) {
    // TODO: implement elementAt
    throw UnimplementedError();
  }

  void remove(Node<T> element, {String path}) {
    // TODO: implement remove
  }

  void removeAll(Iterable<Node<T>> iterable, {String path}) {
    // TODO: implement removeAll
  }

  void removeWhere(bool Function(Node<T> element) test, {String path}) {
    // TODO: implement removeWhere
  }

  @override
  Node<T> first;

  @override
  Node<T> last;

  @override
  Node<T> firstWhere(bool Function(Node<T> element) test,
      {Node<T> Function() orElse, String path}) {
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
  Node<T> lastWhere(bool Function(Node<T> element) test,
      {Node<T> Function() orElse, String path}) {
    // TODO: implement lastWhere
    throw UnimplementedError();
  }

  @override
  Node<T> removeAt(int index, {String path}) {
    // TODO: implement removeAt
    throw UnimplementedError();
  }
}
