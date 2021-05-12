import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tree_structure_view/exceptions/exceptions.dart';
import 'base/i_node_actions.dart';
import 'base/i_node.dart';

export 'base/i_node.dart';

class IndexedNode<T>
    with INodeViewData<T>
    implements INode<T>, IIndexedNodeActions<T> {
  final List<IndexedNode<T>> children;
  final String key;
  String path;

  @mustCallSuper
  IndexedNode([String? key])
      : children = <IndexedNode<T>>[],
        key = key ?? UniqueKey().toString(),
        path = "";

  factory IndexedNode.root() => IndexedNode(INode.ROOT_KEY);

  UnmodifiableListView<INode<T>> get childrenAsList =>
      UnmodifiableListView(children);

  IndexedNode<T> get first {
    if (children.isEmpty) throw ChildrenNotFoundException(this);
    return children.first;
  }

  set first(IndexedNode<T> value) {
    if (children.isEmpty) throw ChildrenNotFoundException(this);
    children.first = value;
  }

  IndexedNode<T> get last {
    if (children.isEmpty) throw ChildrenNotFoundException(this);
    return children.last;
  }

  set last(IndexedNode<T> value) {
    if (children.isEmpty) throw ChildrenNotFoundException(this);
    children.last = value;
  }

  IndexedNode<T> firstWhere(bool Function(IndexedNode<T> element) test,
      {IndexedNode<T> orElse()?}) {
    return children.firstWhere(test, orElse: orElse);
  }

  int indexWhere(bool Function(IndexedNode<T> element) test, [int start = 0]) {
    return children.indexWhere(test, start);
  }

  IndexedNode<T> lastWhere(bool Function(IndexedNode<T> element) test,
      {IndexedNode<T> orElse()?}) {
    return children.lastWhere(test, orElse: orElse);
  }

  void add(INode<T> value) {
    value.path = childrenPath;
    final updatedValue = _updateChildrenPaths<T>(value as IndexedNode<T>);
    children.add(updatedValue);
  }

  Future<void> addAsync(INode<T> value) async {
    value.path = childrenPath;
    final updatedValue =
        await compute(_updateChildrenPaths, (value as IndexedNode<T>));
    children.add(updatedValue as IndexedNode<T>);
  }

  void addAll(Iterable<INode<T>> iterable) {
    for (final node in iterable) {
      add(node);
    }
  }

  Future<void> addAllAsync(Iterable<INode<T>> iterable) async {
    await Future.forEach(
        iterable, (dynamic node) async => await addAsync(node));
  }

  void insert(int index, IndexedNode<T> element) {
    element.path = childrenPath;
    final updatedValue = _updateChildrenPaths<T>(element);
    children.insert(index, updatedValue);
  }

  Future<void> insertAsync(int index, IndexedNode<T> element) async {
    element.path = childrenPath;
    final updatedValue = await compute(_updateChildrenPaths, (element));
    children.insert(index, updatedValue as IndexedNode<T>);
  }

  int insertAfter(IndexedNode<T> after, IndexedNode<T> element) {
    final index = children.indexWhere((node) => node.key == after.key);
    if (index < 0) throw NodeNotFoundException.fromNode(after);
    insert(index + 1, element);
    return index + 1;
  }

  Future<int> insertAfterAsync(
      IndexedNode<T> after, IndexedNode<T> element) async {
    final index = children.indexWhere((node) => node.key == after.key);
    if (index < 0) throw NodeNotFoundException.fromNode(after);
    await insertAsync(index + 1, element);
    return index + 1;
  }

  int insertBefore(IndexedNode<T> before, IndexedNode<T> element) {
    final index = children.indexWhere((node) => node.key == before.key);
    if (index < 0) throw NodeNotFoundException.fromNode(before);
    insert(index, element);
    return index;
  }

  Future<int> insertBeforeAsync(
      IndexedNode<T> before, IndexedNode<T> element) async {
    final index = children.indexWhere((node) => node.key == before.key);
    if (index < 0) throw NodeNotFoundException.fromNode(before);
    await insertAsync(index, element);
    return index;
  }

  void insertAll(int index, Iterable<IndexedNode<T>> iterable) {
    final updatedNodes = iterable.map((node) {
      node.path = childrenPath;
      return _updateChildrenPaths<T>(node);
    });

    children.insertAll(index, updatedNodes);
  }

  Future<void> insertAllAsync(
      int index, Iterable<IndexedNode<T>> iterable) async {
    final updatedNodes = <IndexedNode<T>>[];
    for (final node in iterable) {
      node.path = childrenPath;
      updatedNodes.add(await compute(_updateChildrenPaths, (node)));
    }

    children.insertAll(index, updatedNodes);
  }

  void remove(String key) {
    final index = children.indexWhere((node) => node.key == key);
    if (index < 0) throw NodeNotFoundException(key: key);
    children.removeAt(index);
  }

  IndexedNode<T> removeAt(int index) {
    return children.removeAt(index);
  }

  void removeAll(Iterable<String> keys) {
    for (final key in keys) {
      remove(key);
    }
  }

  void removeWhere(bool Function(INode<T> element) test) {
    children.removeWhere(test);
  }

  void clear() {
    children.clear();
  }

  INode<T> elementAt(String path) {
    IndexedNode<T> currentNode = this;
    for (final nodeKey in path.splitToNodes) {
      if (nodeKey == currentNode.key) {
        continue;
      } else {
        final index =
            currentNode.children.indexWhere((node) => node.key == nodeKey);
        if (index < 0) throw NodeNotFoundException(path: path, key: nodeKey);
        final nextNode = currentNode.children[index];
        currentNode = nextNode;
      }
    }
    return currentNode;
  }

  IndexedNode<T> at(int index) => children[index];

  IndexedNode<T> operator [](String path) => elementAt(path) as IndexedNode<T>;

  static IndexedNode<E> _updateChildrenPaths<E>(IndexedNode<E> node) {
    for (final childNode in node.children) {
      childNode.path = node.childrenPath;
      if (childNode.children.isNotEmpty) {
        _updateChildrenPaths(childNode);
      }
    }
    return node;
  }
}
