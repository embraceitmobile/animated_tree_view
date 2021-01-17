import 'package:flutter/foundation.dart';
import 'package:multi_level_list_view/node/map_node.dart';
import 'package:multi_level_list_view/node/node.dart';
import 'package:multi_level_list_view/tree/base/i_listenable_tree.dart';
import 'package:multi_level_list_view/tree/base/i_tree.dart';
import 'package:multi_level_list_view/tree/tree.dart';
import 'package:multi_level_list_view/tree/tree_change_notifier.dart';

class ListenableTree<T> extends IListenableTree<T> implements ITree<T> {
  ListenableTree(Tree<T> tree) : _value = tree;

  factory ListenableTree.fromList(List<Node<T>> list) =>
      ListenableTree(Tree<T>.fromList(list));

  factory ListenableTree.fromMap(Map<String, Node<T>> map) =>
      ListenableTree(Tree<T>.fromMap(map));

  final Tree<T> _value;
  NodeAddEvent<T> _addNodes;
  NodeInsertEvent<T> _insertedNodes;
  NodeRemoveEvent _removedNodes;

  @override
  Tree<T> get value => _value;

  @override
  MapNode<T> get root => _value.root;

  @override
  int get length => _value.length;

  @override
  NodeAddEvent<T> get addedNodes => _addNodes;

  @override
  NodeInsertEvent<T> get insertedNodes => _insertedNodes;

  @override
  NodeRemoveEvent get removedNodes => _removedNodes;

  @override
  MapNode<T> elementAt(String path) =>
      path == null ? root : _value.elementAt(path);

  @override
  MapNode<T> operator [](String at) => _value[at];

  @override
  void add(Node<T> value, {String path}) {
    _value.add(value, path: path);
    _notifyNodesAdded([value], path: path);
  }

  @override
  void addAll(Iterable<Node<T>> iterable, {String path}) {
    _value.addAll(iterable, path: path);
    _notifyNodesAdded(iterable, path: path);
  }

  @override
  void remove(String key, {String path}) {
    _value.remove(key, path: path);
    _notifyNodesRemoved([key], path: path);
  }

  @override
  void removeAll(Iterable<String> keys, {String path}) {
    _value.removeAll(keys, path: path);
    _notifyNodesRemoved(keys, path: path);
  }

  @override
  void removeWhere(bool Function(Node<T> element) test, {String path}) {
    final allKeysInPath = elementAt(path).children.keys.toSet();

    _value.removeWhere(test, path: path);

    final remainingKeysInPath = elementAt(path).children.keys.toSet();
    allKeysInPath.removeAll(remainingKeysInPath);
    if (allKeysInPath.isNotEmpty) _notifyNodesRemoved(allKeysInPath);
  }

  @override
  void clear({String path}) {
    final allKeys = elementAt(path).children.keys;
    _value.clear(path: path);
    _notifyNodesRemoved(allKeys, path: path);
    notifyListeners();
  }

  void _notifyNodesAdded(Iterable<Node<T>> iterable, {String path}) {
    _addNodes = NodeAddEvent(iterable, path: path);
    notifyListeners();
    Future.delayed(Duration(milliseconds: 300), () => _addNodes = null);
  }

  void _notifyNodesRemoved(Iterable<String> keys, {String path}) {
    _removedNodes = NodeRemoveEvent(keys, path: path);
    notifyListeners();
    Future.delayed(Duration(milliseconds: 300), () => _removedNodes = null);
  }
}
