import 'package:tree_structure_view/exceptions/exceptions.dart';
import 'package:tree_structure_view/node/map_node.dart';
import 'base/i_tree.dart';
import '../node/node.dart';

class Tree<T> implements ITree<T> {
  Tree() : _root = MapNode<T>(Node.ROOT_KEY);

  factory Tree.fromMap(Map<String, Node<T>> nodes) =>
      Tree()..addAll(nodes.values);

  factory Tree.fromList(List<Node<T>> list) => Tree()..addAll(list);

  final MapNode<T> _root;

  int get length => _root.children.length;

  MapNode<T> get root => _root;

  MapNode<T> elementAt(String? path) =>
      path == null ? _root : _root.elementAt(path);

  MapNode<T> operator [](String at) => elementAt(at);

  void add(Node<T> value, {String? path}) {
    final node = path == null ? _root : _root[path];
    node.add(value);
  }

  void addAll(Iterable<Node<T>> iterable, {String? path}) {
    final node = path == null ? _root : _root[path];
    node.addAll(iterable);
  }

  void clear({String? path}) {
    final node = path == null ? _root : _root[path];
    node.children.clear();
  }

  void remove(String key, {String? path}) {
    final node = path == null ? _root : _root[path];
    node.remove(key);
  }

  void removeWhere(bool Function(Node<T> element) test, {String? path}) {
    final node = path == null ? _root : _root[path];
    node.removeWhere(test);
  }

  void removeAll(Iterable<String> keys, {String? path}) {
    final node = path == null ? _root : _root[path];
    node.removeAll(keys);
  }
}
