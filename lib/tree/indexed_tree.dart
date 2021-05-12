import 'package:tree_structure_view/node/indexed_node.dart';
import 'package:tree_structure_view/node/node.dart';
import 'base/i_tree.dart';
import '../node/base/i_node.dart';

class IndexedTree<T> implements ITree<T>, IIndexedTree<T> {
  IndexedTree() : _root = IndexedNode<T>.root();

  factory IndexedTree.fromList(List<IndexedNode<T>> list) =>
      IndexedTree()..addAll(list);

  final IndexedNode<T> _root;

  List<IndexedNode<T>> get children => _root.children;

  int get length => _root.length;

  IndexedNode<T> get root => _root;

  IndexedNode<T> elementAt(String? path) =>
      path == null ? _root : _root.elementAt(path) as IndexedNode<T>;

  IndexedNode<T> operator [](String at) => _root[at];

  IndexedNode<T> at(int index) => _root.at(index);

  IndexedNode<T> get first => _root.first;

  set first(IndexedNode<T> value) {
    _root.first = value;
  }

  IndexedNode<T> get last => _root.last;

  set last(IndexedNode<T> value) {
    _root.last = value;
  }

  IndexedNode<T> firstWhere(bool Function(IndexedNode<T> element) test,
      {IndexedNode<T> orElse()?, String? path}) {
    final node = path == null ? _root : _root[path];
    return node.firstWhere(test, orElse: orElse);
  }

  int indexWhere(bool Function(IndexedNode<T> element) test,
      {int start = 0, String? path}) {
    final node = path == null ? _root : _root[path];
    return node.indexWhere(test, start);
  }

  IndexedNode<T> lastWhere(bool Function(IndexedNode<T> element) test,
      {IndexedNode<T> orElse()?, String? path}) {
    final node = path == null ? _root : _root[path];
    return node.lastWhere(test, orElse: orElse);
  }

  void add(INode<T> value, {String? path}) {
    final node = path == null ? _root : _root[path];
    node.add(value);
  }

  void addAll(Iterable<INode<T>> iterable, {String? path}) {
    final node = path == null ? _root : _root[path];
    node.addAll(iterable);
  }

  void insert(int index, IndexedNode<T> element, {String? path}) {
    final node = path == null ? _root : _root[path];
    node.insert(index, element);
  }

  int insertAfter(IndexedNode<T> after, IndexedNode<T> element,
      {String? path}) {
    final node = path == null ? _root : _root[path];
    return node.insertAfter(after, element);
  }

  void insertAll(int index, Iterable<IndexedNode<T>> iterable, {String? path}) {
    final node = path == null ? _root : _root[path];
    node.insertAll(index, iterable);
  }

  int insertBefore(IndexedNode<T> before, IndexedNode<T> element,
      {String? path}) {
    final node = path == null ? _root : _root[path];
    return node.insertBefore(before, element);
  }

  void remove(String key, {String? path}) {
    final node = path == null ? _root : _root[path];
    node.remove(key);
  }

  IndexedNode<T> removeAt(int index, {String? path}) {
    final node = path == null ? _root : _root[path];
    return node.removeAt(index);
  }

  void removeAll(Iterable<String> keys, {String? path}) {
    final node = path == null ? _root : _root[path];
    node.removeAll(keys);
  }

  void removeWhere(bool Function(INode<T> element) test, {String? path}) {
    final node = path == null ? _root : _root[path];
    node.removeWhere(test);
  }

  void clear({String? path}) {
    final node = path == null ? _root : _root[path];
    node.clear();
  }
}
