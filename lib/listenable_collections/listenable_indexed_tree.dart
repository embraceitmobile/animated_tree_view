import 'dart:async';

import 'package:tree_structure_view/node/list_node.dart';
import 'package:tree_structure_view/node/node.dart';
import 'package:tree_structure_view/tree/base/i_listenable_tree.dart';
import 'package:tree_structure_view/tree/base/i_tree.dart';
import 'package:tree_structure_view/tree/indexed_tree.dart';
import 'package:tree_structure_view/tree/tree_update_notifier.dart';

class ListenableIndexedTree<T> extends IListenableIndexedTree<T>
    implements IIndexedTree<T> {
  ListenableIndexedTree(IndexedTree<T> tree) : _value = tree;

  factory ListenableIndexedTree.fromList(List<ListNode<T>> list) =>
      ListenableIndexedTree(IndexedTree<T>.fromList(list));

  final IndexedTree<T> _value;

  final StreamController<NodeAddEvent<T>> _addedNodes =
      StreamController<NodeAddEvent<T>>.broadcast();

  final StreamController<NodeRemoveEvent> _removedNodes =
      StreamController<NodeRemoveEvent>.broadcast();

  final StreamController<NodeInsertEvent<T>> _insertedNodes =
      StreamController<NodeInsertEvent<T>>.broadcast();

  ListNode<T> get root => _value.root;

  IndexedTree<T> get value => _value;

  int get length => _value.length;

  Stream<NodeAddEvent<T>> get addedNodes => _addedNodes.stream;

  Stream<NodeInsertEvent<T>> get insertedNodes => _insertedNodes.stream;

  Stream<NodeRemoveEvent> get removedNodes => _removedNodes.stream;

  Node<T> operator [](covariant at) => _value[at];

  ListNode<T> elementAt(String? path) =>
      path == null ? root : _value.elementAt(path);

  ListNode<T> at(int index) => _value.at(index);

  ListNode<T> get first => _value.first;

  set first(ListNode<T> value) {
    _value.first = value;
  }

  ListNode<T> get last => _value.last;

  set last(ListNode<T> value) {
    _value.last = value;
  }

  int indexWhere(bool Function(Node<T> element) test,
      {int start = 0, String? path}) {
    return _value.indexWhere(test, start: start, path: path);
  }

  ListNode<T> firstWhere(bool Function(ListNode<T> element) test,
      {ListNode<T> orElse()?, String? path}) {
    return _value.firstWhere(test, orElse: orElse);
  }

  ListNode<T> lastWhere(bool Function(ListNode<T> element) test,
      {ListNode<T> orElse()?, String? path}) {
    return _value.lastWhere(test, orElse: orElse);
  }

  void add(Node<T> value, {String? path}) {
    _value.add(value, path: path);
    _notifyNodesAdded([value], path: path);
  }

  void addAll(Iterable<Node<T>> iterable, {String? path}) {
    _value.addAll(iterable, path: path);
    _notifyNodesAdded(iterable, path: path);
  }

  void clear({String? path}) {
    final allKeys = path == null ? _value.children : elementAt(path).children;
    _value.clear(path: path);
    _notifyNodesRemoved((allKeys).map((node) => node.key), path: path);
  }

  void insert(int index, ListNode<T> element, {String? path}) {
    _value.insert(index, element, path: path);
    _notifyNodesInserted([element], index, path: path);
  }

  int insertAfter(ListNode<T> after, ListNode<T> element, {String? path}) {
    final index = _value.insertAfter(after, element, path: path);
    _notifyNodesInserted([element], index);
    return index;
  }

  int insertBefore(ListNode<T> before, ListNode<T> element, {String? path}) {
    final index = _value.insertBefore(before, element, path: path);
    _notifyNodesInserted([element], index);
    return index;
  }

  void insertAll(int index, Iterable<ListNode<T>> iterable, {String? path}) {
    _value.insertAll(index, iterable, path: path);
    _notifyNodesInserted(iterable, index, path: path);
  }

  Node<T> removeAt(int index, {String? path}) {
    final removedNode = _value.removeAt(index, path: path);
    _notifyNodesRemoved([removedNode.key], path: path);
    return removedNode;
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
    final allKeysInPath =
        elementAt(path).children.map((node) => node.key).toSet();

    _value.removeWhere(test, path: path);

    final remainingKeysInPath =
        elementAt(path).children.map((node) => node.key).toSet();

    allKeysInPath.removeAll(remainingKeysInPath);
    if (allKeysInPath.isNotEmpty) _notifyNodesRemoved(allKeysInPath);
  }

  void _notifyNodesAdded(Iterable<Node<T>> iterable, {String? path}) {
    _addedNodes.sink.add(NodeAddEvent(iterable, path: path));
    notifyListeners();
  }

  void _notifyNodesInserted(Iterable<Node<T>> iterable, int index,
      {String? path}) {
    _insertedNodes.sink.add(NodeInsertEvent(iterable, index, path: path));
    notifyListeners();
  }

  void _notifyNodesRemoved(Iterable<String> keys, {String? path}) {
    _removedNodes.sink.add(NodeRemoveEvent(keys, path: path));
    notifyListeners();
  }

  void dispose() {
    _addedNodes.close();
    _removedNodes.close();
    _insertedNodes.close();
    super.dispose();
  }
}
