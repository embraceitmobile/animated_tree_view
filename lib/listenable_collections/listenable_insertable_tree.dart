import 'package:flutter/foundation.dart';
import 'package:multi_level_list_view/tree_structures/insertable_tree.dart';
import 'package:multi_level_list_view/tree_structures/interfaces/i_listenable_tree.dart';
import 'package:multi_level_list_view/tree_structures/interfaces/i_tree.dart';
import 'package:multi_level_list_view/tree_structures/node.dart';
import 'package:multi_level_list_view/tree_structures/tree_update_provider.dart';

class ListenableInsertableTree<T> extends ChangeNotifier
    with TreeUpdateProvider<T>
    implements IInsertableTree<T>, IListenableIndexedTree<T> {
  ListenableInsertableTree._(InsertableTree<T> tree) : _value = tree;

  factory ListenableInsertableTree({List<ListNode<T>> children = const []}) =>
      ListenableInsertableTree._(InsertableTree<T>());

  factory ListenableInsertableTree.fromMap(Map<String, Node<T>> map) =>
      ListenableInsertableTree._(InsertableTree.fromMap(map));

  final InsertableTree<T> _value;

  @override
  T first;

  @override
  T last;

  @override
  T operator [](covariant at) {
    // TODO: implement []
    throw UnimplementedError();
  }

  @override
  void operator []=(covariant at, T value) {
    // TODO: implement []=
  }

  @override
  void add(T value, {String path}) {
    // TODO: implement add
  }

  @override
  void addAll(Iterable<T> iterable, {String path}) {
    // TODO: implement addAll
  }

  @override
  void clear({String path}) {
    // TODO: implement clear
  }

  @override
  T elementAt(String path) {
    // TODO: implement elementAt
    throw UnimplementedError();
  }

  @override
  T firstWhere(bool Function(T element) test, {T Function() orElse, String path}) {
    // TODO: implement firstWhere
    throw UnimplementedError();
  }

  @override
  int indexWhere(bool Function(T element) test, {int start = 0, String path}) {
    // TODO: implement indexWhere
    throw UnimplementedError();
  }

  @override
  void insert(int index, T element, {String path}) {
    // TODO: implement insert
  }

  @override
  void insertAfter(T element, {String path}) {
    // TODO: implement insertAfter
  }

  @override
  void insertAll(int index, Iterable<T> iterable, {String path}) {
    // TODO: implement insertAll
  }

  @override
  void insertBefore(T element, {String path}) {
    // TODO: implement insertBefore
  }

  @override
  T lastWhere(bool Function(T element) test, {T Function() orElse, String path}) {
    // TODO: implement lastWhere
    throw UnimplementedError();
  }

  @override
  // TODO: implement length
  int get length => throw UnimplementedError();

  @override
  void remove(T element, {String path}) {
    // TODO: implement remove
  }

  @override
  void removeAll(Iterable<T> iterable, {String path}) {
    // TODO: implement removeAll
  }

  @override
  T removeAt(int index, {String path}) {
    // TODO: implement removeAt
    throw UnimplementedError();
  }

  @override
  void removeWhere(bool Function(T element) test, {String path}) {
    // TODO: implement removeWhere
  }

  @override
  // TODO: implement root
  Node<T> get root => throw UnimplementedError();

  @override
  // TODO: implement value
  InsertableTree<T> get value => throw UnimplementedError();
}
