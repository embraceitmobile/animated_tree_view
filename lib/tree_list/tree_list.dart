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

  List<Node<T>> get children => _root.children;

  factory TreeList() => TreeList._(_RootNode(<T>[]));

  factory TreeList.from(List<Node<T>> list) => TreeList._(_RootNode(list));

  void add(T element, {String path}) {
    if (path == null) {
      _root.children.add(element);
    } else {
      root.getNodeAt(path).children.add(element);
    }
  }

  void addAll(Iterable<T> iterable, {String path}) {
    if (path == null) {
      _root.children.addAll(iterable);
    } else {
      _root.getNodeAt(path).children.addAll(iterable);
    }
  }

  void insert(T element, int index, {String path}) {
    if (path == null) {
      _root.children.insert(index, element);
    } else {
      _root.getNodeAt(path).children.insert(index, element);
    }
  }

  void insertAll(Iterable<T> iterable, int index, {String path}) {
    if (path == null) {
      _root.children.insertAll(index, iterable);
    } else {
      _root.getNodeAt(path).children.insertAll(index, iterable);
    }
  }

  void remove(T value, {String path}) {
    if (path == null) {
      _root.children.remove(value);
    } else {
      _root.getNodeAt(path).children.remove(value);
    }
  }

  void removeItems(Iterable<Node<T>> iterable, {String path}) {
    final node = path == null ? _root : _root.getNodeAt(path);

    for (final item in iterable) {
      node.children.remove(item);
    }
  }

  void removeAt(int index, {String path}) {
    if (path == null) {
      _root.children.removeAt(index);
    } else {
      _root.getNodeAt(path).children.removeAt(index);
    }
  }

  void clearAll({String path}) {
    if (path == null) {
      _root.children.clear();
    } else {
      _root.getNodeAt(path).children.clear();
    }
  }
}

class _RootNode<T extends Node<T>> with Node<T> {
  final List<Node<T>> children;
  final String key;

  _RootNode(this.children) : this.key = ROOT_KEY;
}
