import 'package:flutter/material.dart';
import 'package:multi_level_list_view/node/map_node.dart';
import 'base/i_tree.dart';
import '../node/node.dart';

class Tree<T> implements ITree<T> {
  Tree() : _root = MapNode<T>(key: Node.ROOT_KEY);

  factory Tree.fromMap(Map<String, Node<T>> nodes) => Tree();

  factory Tree.fromList(List<Node<T>> list) => Tree();

  final MapNode<T> _root;

  int get length => _root.children.length;

  Node<T> get root => _root;

  Node<T> operator [](String at) {
    // TODO: implement []
    throw UnimplementedError();
  }

  void operator []=(String at, Node<T> value) {
    // TODO: implement []=
  }

  void add(Node<T> value, {String path}) {}

  void addAll(Iterable<Node<T>> iterable, {String path}) {
    // TODO: implement addAll
  }

  void clear({String path}) {
    // TODO: implement clear
  }

  Node<T> elementAt(String path) {
    var currentNode = _root;
    for (final node in path.splitToNodes) {
      if (node.isEmpty) {
        return currentNode;
      } else {
        currentNode = currentNode.children[node];
      }
    }
    return currentNode;
  }

  void remove(Node<T> element, {String path}) {
    // TODO: implement remove
  }

  void removeAll(Iterable<Node<T>> iterable, {String path}) {
    // TODO: implement removeAll
  }

  void removeWhere(bool Function(Node<T> element) test, {String path}) {
    // TODO: implement removeWhere
  }
}
