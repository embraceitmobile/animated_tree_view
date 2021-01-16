import 'dart:collection';
import 'package:flutter/material.dart';
import 'base/i_node_actions.dart';
import 'node.dart';

export 'node.dart';

class ListNode<T> with NodeViewData<T> implements Node<T>, IListNodeActions<T> {
  final List<Node<T>> children;
  final String key;
  String path;

  @mustCallSuper
  ListNode([String key])
      : children = <Node<T>>[],
        key = key ?? UniqueKey().toString();

  UnmodifiableListView<Node<T>> toList() => children;

  @override
  void add(Node<T> value) {
    // TODO: implement add
  }

  @override
  void addAll(Iterable<Node<T>> iterable) {
    // TODO: implement addAll
  }

  @override
  void clear() {
    // TODO: implement clear
  }

  @override
  void insert(int index, Node<T> element) {
    // TODO: implement insert
  }

  @override
  void insertAfter(Node<T> element) {
    // TODO: implement insertAfter
  }

  @override
  void insertAll(int index, Iterable<Node<T>> iterable) {
    // TODO: implement insertAll
  }

  @override
  void insertBefore(Node<T> element) {
    // TODO: implement insertBefore
  }

  @override
  Node<T> removeAt(int index) {
    // TODO: implement removeAt
    throw UnimplementedError();
  }

  @override
  void removeWhere(bool Function(Node<T> element) test) {
    // TODO: implement removeWhere
  }

  @override
  Future<void> addAllAsync(Iterable<Node<T>> iterable) {
    // TODO: implement addAllAsync
    throw UnimplementedError();
  }

  @override
  Future<void> addAsync(Node<T> value) {
    // TODO: implement addAsync
    throw UnimplementedError();
  }

  @override
  Future<void> insertAfterAsync(Node<T> element) {
    // TODO: implement insertAfterAsync
    throw UnimplementedError();
  }

  @override
  Future<void> insertAllAsync(int index, Iterable<Node<T>> iterable) {
    // TODO: implement insertAllAsync
    throw UnimplementedError();
  }

  @override
  Future<void> insertAsync(int index, Node<T> element) {
    // TODO: implement insertAsync
    throw UnimplementedError();
  }

  @override
  Future<void> insertBeforeAsync(Node<T> element) {
    // TODO: implement insertBeforeAsync
    throw UnimplementedError();
  }

  @override
  Future<Node<T>> removeAtAsync(int index) {
    // TODO: implement removeAtAsync
    throw UnimplementedError();
  }

  @override
  ListNode<T> operator [](String path) {
    // TODO: implement removeAtAsync
    throw UnimplementedError();
  }

  @override
  void remove(String key) {
    // TODO: implement remove
  }

  @override
  void removeAll(Iterable<String> keys) {
    // TODO: implement removeAll
  }

  @override
  Node<T> elementAt(String path) {
    // TODO: implement elementAt
    throw UnimplementedError();
  }
}
