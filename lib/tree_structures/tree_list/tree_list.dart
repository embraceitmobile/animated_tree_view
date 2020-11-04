import 'package:multi_level_list_view/interfaces/iterable_tree.dart';
import 'package:multi_level_list_view/tree_structures/node.dart';

class TreeList<T extends Node<T>> implements InsertableIterableTree<T> {
  TreeList._(RootNode<T> root) : _root = root {
    if (_root.hasChildren) {
      for (final node in _root.children) {
        node.path = _root.childrenPath;
      }
    }
  }

  RootNode<T> _root;

  Node<T> get root => _root;

  List<Node<T>> get children => _root.children;

  factory TreeList() => TreeList._(RootNode(<T>[]));

  factory TreeList.from(List<Node<T>> list) => TreeList._(RootNode(list));

  void add(T element, {String path}) {
    final node = path == null ? _root : _root.getNodeAt(path);
    node.children.add(element);
    node.populateChildrenPath(refresh: true);
  }

  void addAll(Iterable<T> iterable, {String path}) {
    final node = path == null ? _root : _root.getNodeAt(path);
    node.children.addAll(iterable);
    node.populateChildrenPath(refresh: true);
  }

  void insert(T element, int index, {String path}) {
    final node = path == null ? _root : _root.getNodeAt(path);
    node.children.insert(index, element);
    node.populateChildrenPath(refresh: true);
  }

  void insertAll(Iterable<T> iterable, int index, {String path}) {
    final node = path == null ? _root : _root.getNodeAt(path);
    node.children.insertAll(index, iterable);
    node.populateChildrenPath(refresh: true);
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
