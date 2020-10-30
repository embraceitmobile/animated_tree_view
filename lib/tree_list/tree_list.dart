import 'package:multi_level_list_view/tree_list/node.dart';
import 'i_tree_list.dart';

const ROOT_KEY = "/";

class TreeList<T extends Node<T>> implements ITreeList<T> {
  TreeList._(_RootNode<T> root) : _root = root {
    if (_root.hasChildren) {
      for (final node in _root.children) {
        node.path = _root.childrenPath;
      }
    }
  }

  _RootNode<T> _root;

  Node<T> get root => _root;

  factory TreeList() => TreeList._(_RootNode(<T>[]));

  factory TreeList.from(List<Node<T>> list) => TreeList._(_RootNode(list));

  void insertAt(T item, int index, {String path}) {}

  void insert(T item, {String path}) {}

  void insertAll(List<T> items, {String path}) {}

  void remove(T item, {String path}) {}

  void removeAll(List<T> items, {String path}) {}

  void removeAt(int index, {String path}) {}

  void removeAllAt(String path) {}
}

class _RootNode<T extends Node<T>> with Node<T> {
  final List<Node<T>> children;
  final String key;

  _RootNode(this.children) : this.key = ROOT_KEY;
}
