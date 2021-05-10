import 'dart:async';

import 'package:tree_structure_view/node/map_node.dart';
import 'package:tree_structure_view/node/node.dart';
import 'package:tree_structure_view/tree/base/i_listenable_tree.dart';
import 'package:tree_structure_view/tree/base/i_tree.dart';
import 'package:tree_structure_view/tree/tree.dart';
import 'package:tree_structure_view/tree/tree_update_notifier.dart';

class ListenableTree<T> extends IListenableTree<T> implements ITree<T> {
  ListenableTree([Tree<T>? tree]) : _value = tree ?? Tree<T>();

  factory ListenableTree.fromMap(Map<String, MapNode<T>> map) =>
      ListenableTree(Tree<T>.fromMap(map));

  final Tree<T> _value;

  final StreamController<NodeAddEvent<T>> _addedNodes =
      StreamController<NodeAddEvent<T>>.broadcast();

  final StreamController<NodeRemoveEvent> _removedNodes =
      StreamController<NodeRemoveEvent>.broadcast();

  Tree<T> get value => _value;

  MapNode<T> get root => _value.root;

  int get length => _value.length;

  Stream<NodeAddEvent<T>> get addedNodes => _addedNodes.stream;

  Stream<NodeRemoveEvent> get removedNodes => _removedNodes.stream;

  Stream<NodeInsertEvent<T>> get insertedNodes =>
      StreamController<NodeInsertEvent<T>>().stream;

  MapNode<T> elementAt(String? path) =>
      path == null ? root : _value.elementAt(path);

  MapNode<T> operator [](String at) => _value[at];

  void add(Node<T> value, {String? path}) {
    _value.add(value, path: path);
    _notifyNodesAdded([value], path: path);
  }

  void addAll(Iterable<Node<T>> iterable, {String? path}) {
    _value.addAll(iterable, path: path);
    _notifyNodesAdded(iterable, path: path);
  }

  void remove(String key, {String? path}) {
    _value.remove(key, path: path);
    _notifyNodesRemoved([key], path: path);
  }

  void removeAll(Iterable<String> keys, {String? path}) {
    _value.removeAll(keys, path: path);
    _notifyNodesRemoved(keys, path: path);
  }

  void removeWhere(bool Function(Node<T> element) test, {String? path}) {
    final allKeysInPath = elementAt(path).children.keys.toSet();

    _value.removeWhere(test, path: path);

    final remainingKeysInPath = elementAt(path).children.keys.toSet();
    allKeysInPath.removeAll(remainingKeysInPath);
    if (allKeysInPath.isNotEmpty) _notifyNodesRemoved(allKeysInPath);
  }

  void clear({String? path}) {
    final allKeys = elementAt(path).children.keys;
    _value.clear(path: path);
    _notifyNodesRemoved(allKeys, path: path);
  }

  void _notifyNodesAdded(Iterable<Node<T>> iterable, {String? path}) {
    _addedNodes.sink.add(NodeAddEvent(iterable, path: path));
    notifyListeners();
  }

  void _notifyNodesRemoved(Iterable<String> keys, {String? path}) {
    _removedNodes.sink.add(NodeRemoveEvent(keys, path: path));
    notifyListeners();
  }

  void dispose() {
    _addedNodes.close();
    _removedNodes.close();
    super.dispose();
  }
}
