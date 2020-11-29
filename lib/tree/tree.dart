import 'package:flutter/material.dart';
import 'node.dart';
import 'i_tree.dart';

class Tree<T> implements ITree<T> {
  Tree._({this.children = const {}});

  factory Tree({Map<String, Node<T>> nodes}) => Tree._();

  factory Tree.fromList(List<ListNode<T>> list) => Tree._();

  final Map<String, Node<T>> children;

  @override
  int get length => children.length;

  @override
  // TODO: implement root
  Node<T> get root => throw UnimplementedError();

  T operator [](String at) {
    // TODO: implement []
    throw UnimplementedError();
  }

  void operator []=(String at, T value) {
    // TODO: implement []=
  }

  void add(T value, {String path}) {
    // TODO: implement add
  }

  void addAll(Iterable<T> iterable, {String path}) {
    // TODO: implement addAll
  }

  void clear({String path}) {
    // TODO: implement clear
  }

  T elementAt(String path) {
    // TODO: implement elementAt
    throw UnimplementedError();
  }

  void remove(T element, {String path}) {
    // TODO: implement remove
  }

  void removeAll(Iterable<T> iterable, {String path}) {
    // TODO: implement removeAll
  }

  void removeWhere(bool Function(T element) test, {String path}) {
    // TODO: implement removeWhere
  }
}
