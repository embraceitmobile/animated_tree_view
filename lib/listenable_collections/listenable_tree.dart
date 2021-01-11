import 'package:flutter/foundation.dart';
import 'package:multi_level_list_view/node/node.dart';
import 'package:multi_level_list_view/tree/base/i_listenable_tree.dart';
import 'package:multi_level_list_view/tree/base/i_tree.dart';
import 'package:multi_level_list_view/tree/tree.dart';
import 'package:multi_level_list_view/tree/tree_update_provider.dart';

class ListenableTree<T> extends ChangeNotifier
    with TreeUpdateProvider<T>
    implements ITree<T>, IListenableTree<T> {
  ListenableTree(Tree<T> tree) : _value = tree;

  factory ListenableTree.fromList(List<Node<T>> list) =>
      ListenableTree(Tree<T>.fromList(list));

  factory ListenableTree.fromMap(Map<String, Node<T>> map) =>
      ListenableTree(Tree.fromMap(map));

  final Tree<T> _value;

  @override
  // TODO: implement value
  Tree<T> get value => _value;

  @override
  Node<T> operator [](covariant at) {
    // TODO: implement []
    throw UnimplementedError();
  }

  @override
  void operator []=(covariant at, Node<T> value) {
    // TODO: implement []=
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
  void removeWhere(bool Function(Node<T> element) test, {String path}) {
    // TODO: implement removeWhere
  }

  @override
  // TODO: implement root
  Node<T> get root => throw UnimplementedError();
}
