import 'package:multi_level_list_view/exceptions/exceptions.dart';
import 'package:multi_level_list_view/node/map_node.dart';
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

  MapNode<T> operator [](String at) {
    return elementAt(at);
  }

  void add(Node<T> value, {String path}) {
    final node = path == null ? _root : elementAt(path);
    node.add(value);
  }

  void addAll(Iterable<Node<T>> iterable, {String path}) {
    final node = path == null ? _root : elementAt(path);
    node.addAll(iterable);
  }

  void clear({String path}) {
    final node = path == null ? _root : elementAt(path);
    node.children.clear();
  }

  MapNode<T> elementAt(String path) {
    var currentNode = _root;
    for (final node in path.splitToNodes) {
      if (node.isEmpty) {
        return currentNode;
      } else {
        final nextNode = currentNode.children[node];
        if (nextNode == null) throw NodeNotFoundException(path, node);
        currentNode = nextNode;
      }
    }
    return currentNode;
  }

  void remove(String key, {String path}) {
    final node = path == null ? _root : elementAt(path);
    node.remove(key);
  }

  void removeAll(Iterable<String> keys, {String path}) {
    final node = path == null ? _root : elementAt(path);
    node.removeAll(keys);
  }

  void removeWhere(bool Function(Node<T> element) test, {String path}) {
    final node = path == null ? _root : elementAt(path);
    node.removeWhere(test);
  }
}
