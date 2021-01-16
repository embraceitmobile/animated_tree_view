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
      ListenableTree(Tree<T>.fromMap(map));

  final Tree<T> _value;

  @override
  Tree<T> get value => _value;

  @override
  Node<T> get root => _value.root;

  @override
  int get length => _value.length;

  @override
  Node<T> elementAt(String path) => _value.elementAt(path);

  @override
  Node<T> operator [](String at) => _value[at];

  @override
  void add(Node<T> value, {String path}) {
    _value.add(value, path: path);
    notifyListeners();
  }

  @override
  void addAll(Iterable<Node<T>> iterable, {String path}) {
    _value.addAll(iterable, path: path);
    notifyListeners();
  }

  @override
  void clear({String path}) {
    _value.clear(path: path);
    notifyListeners();
  }

  @override
  void removeWhere(bool Function(Node<T> element) test, {String path}) {
    _value.removeWhere(test, path: path);
    notifyListeners();
  }

  @override
  void remove(String key, {String path}) {
    _value.remove(key, path: path);
    notifyListeners();
  }

  @override
  void removeAll(Iterable<String> keys, {String path}) {
    _value.removeAll(keys, path: path);
    notifyListeners();
  }
}
