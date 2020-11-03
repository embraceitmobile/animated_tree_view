import 'package:multi_level_list_view/iterable_tree/iterable_tree.dart';
import 'package:multi_level_list_view/collections/node_collections.dart';

const ROOT_KEY = "/";

class TreeList<T extends Node<T>> implements IterableTree<T> {
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
    final node = path == null ? _root : _root.getNodeAt(path);
    node.children.add(element);
  }

  void addAll(Iterable<T> iterable, {String path}) {
    final node = path == null ? _root : _root.getNodeAt(path);
    node.children.addAll(iterable);
  }

  void insert(T element, int index, {String path}) {
    final node = path == null ? _root : _root.getNodeAt(path);
    node.children.insert(index, element);
  }

  void insertAll(Iterable<T> iterable, int index, {String path}) {
    final node = path == null ? _root : _root.getNodeAt(path);
    node.children.insertAll(index, iterable);
  }

  void remove(T value, {String path}) {
    final node = path == null ? _root : _root.getNodeAt(path);
    node.children.remove(value);
  }

  void removeItems(Iterable<Node<T>> iterable, {String path}) {
    final node = path == null ? _root : _root.getNodeAt(path);

    for (final item in iterable) {
      node.children.remove(item);
    }
  }

  T removeAt(int index, {String path}) {
    final node = path == null ? _root : _root.getNodeAt(path);
    final item = node.children[index];
    node.children.removeAt(index);
    return item;
  }

  Iterable<Node<T>> clearAll({String path}) {
    final node = path == null ? _root : _root.getNodeAt(path);
    final items = List.of(node.children, growable: false);
    node.children.clear();
    return items;
  }
}

class _RootNode<T extends Node<T>> with Node<T> {
  final List<Node<T>> children;
  final String key;

  _RootNode(this.children) : this.key = ROOT_KEY;
}
