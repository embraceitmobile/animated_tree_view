import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tree_structure_view/exceptions/exceptions.dart';
import 'base/i_node_actions.dart';
import 'node.dart';

export 'node.dart';

class ListNode<T> with NodeViewData<T> implements Node<T>, IListNodeActions<T> {
  final List<ListNode<T>> children;
  final String key;
  String path;

  @mustCallSuper
  ListNode([String? key])
      : children = <ListNode<T>>[],
        key = key ?? UniqueKey().toString(),
        path = "";

  UnmodifiableListView<Node<T>> get childrenAsList =>
      UnmodifiableListView(children);

  void add(Node<T> value) {
    value.path = childrenPath;
    final updatedValue = _updateChildrenPaths<T>(value as ListNode<T>);
    children.add(updatedValue);
  }

  Future<void> addAsync(Node<T> value) async {
    value.path = childrenPath;
    final updatedValue =
        await compute(_updateChildrenPaths, (value as ListNode<T>));
    children.add(updatedValue as ListNode<T>);
  }

  void addAll(Iterable<Node<T>> iterable) {
    for (final node in iterable) {
      add(node);
    }
  }

  Future<void> addAllAsync(Iterable<Node<T>> iterable) async {
    await Future.forEach(
        iterable, (dynamic node) async => await addAsync(node));
  }

  void insert(int index, Node<T> element) {
    element.path = childrenPath;
    final updatedValue = _updateChildrenPaths<T>(element as ListNode<T>);
    children.insert(index, updatedValue);
  }

  Future<void> insertAsync(int index, Node<T> element) async {
    element.path = childrenPath;
    final updatedValue =
        await compute(_updateChildrenPaths, (element as ListNode<T>));
    children.insert(index, updatedValue as ListNode<T>);
  }

  int insertAfter(Node<T> element) {
    final index = children.indexWhere((node) => node.key == element.key);
    if (index < 0) throw NodeNotFoundException.fromNode(element);
    insert(index + 1, element);
    return index + 1;
  }

  Future<int> insertAfterAsync(Node<T> element) async {
    final index = children.indexWhere((node) => node.key == element.key);
    if (index < 0) throw NodeNotFoundException.fromNode(element);
    await insertAsync(index + 1, element);
    return index + 1;
  }

  int insertBefore(Node<T> element) {
    final index = children.indexWhere((node) => node.key == element.key);
    if (index < 0) throw NodeNotFoundException.fromNode(element);
    insert(index, element);
    return index;
  }

  Future<int> insertBeforeAsync(Node<T> element) async {
    final index = children.indexWhere((node) => node.key == element.key);
    if (index < 0) throw NodeNotFoundException.fromNode(element);
    await insertAsync(index, element);
    return index;
  }

  void insertAll(int index, Iterable<Node<T>> iterable) {
    final updatedNodes = iterable.map((node) {
      node.path = childrenPath;
      return _updateChildrenPaths<T>(node as ListNode<T>);
    });

    children.insertAll(index, updatedNodes);
  }

  Future<void> insertAllAsync(int index, Iterable<Node<T>> iterable) async {
    final updatedNodes = List<ListNode<T>>.empty();
    for (final node in iterable) {
      node.path = childrenPath;
      updatedNodes
          .add(await compute(_updateChildrenPaths, (node as ListNode<T>)));
    }

    children.insertAll(index, updatedNodes);
  }


  void remove(String key) {
    final index = children.indexWhere((node) => node.key == key);
    if (index < 0) throw NodeNotFoundException(key: key);
    children.removeAt(index);
  }

  Node<T> removeAt(int index) {
    return children.removeAt(index);
  }

  void removeAll(Iterable<String> keys) {
    for (final key in keys) {
      remove(key);
    }
  }

  void clear() {
    children.clear();
  }

  Node<T> elementAt(String path) {
    ListNode<T> currentNode = this;
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

  ListNode<T> operator [](String path) => elementAt(path) as ListNode<T>;

  static ListNode<E> _updateChildrenPaths<E>(ListNode<E> node) {
    for (final childNode in node.children) {
      childNode.path = node.childrenPath;
      if (childNode.children.isNotEmpty) {
        _updateChildrenPaths(childNode);
      }
    }
    return node;
  }
}
