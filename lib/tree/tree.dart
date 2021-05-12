import 'package:tree_structure_view/exceptions/exceptions.dart';
import 'package:tree_structure_view/node/node.dart';
import 'base/i_tree.dart';
import '../node/base/i_node.dart';

class Tree<T> implements ITree<T> {
  Tree() : _root = Node<T>.root();

  factory Tree.fromMap(Map<String, INode<T>> nodes) =>
      Tree()..addAll(nodes.values);

  final Node<T> _root;

  int get length => _root.length;

  Node<T> get root => _root;

  Node<T> elementAt(String? path) =>
      path == null ? _root : _root.elementAt(path);

  Node<T> operator [](String at) => elementAt(at);

  void add(INode<T> value, {String? path}) {
    final node = path == null ? _root : _root[path];
    node.add(value);
  }

  Future<void> addAsync(INode<T> value, {String? path}) async {
    final node = path == null ? _root : _root[path];
    await node.addAsync(value);
  }

  void addAll(Iterable<INode<T>> iterable, {String? path}) {
    final node = path == null ? _root : _root[path];
    node.addAll(iterable);
  }

  Future<void> addAllAsync(Iterable<INode<T>> iterable, {String? path}) async {
    final node = path == null ? _root : _root[path];
    await node.addAllAsync(iterable);
  }

  void clear({String? path}) {
    final node = path == null ? _root : _root[path];
    node.clear();
  }

  void remove(String key, {String? path}) {
    final node = path == null ? _root : _root[path];
    node.remove(key);
  }

  void removeWhere(bool Function(INode<T> element) test, {String? path}) {
    final node = path == null ? _root : _root[path];
    node.removeWhere(test);
  }

  void removeAll(Iterable<String> keys, {String? path}) {
    final node = path == null ? _root : _root[path];
    node.removeAll(keys);
  }
}
