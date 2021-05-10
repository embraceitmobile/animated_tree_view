import 'package:tree_structure_view/node/list_node.dart';
import 'package:tree_structure_view/node/map_node.dart';
import 'base/i_tree.dart';
import '../node/node.dart';

class IndexedTree<T> implements ITree<T>, IIndexedTree<T> {
  IndexedTree() : _root = ListNode<T>(Node.ROOT_KEY);

  factory IndexedTree.fromList(List<ListNode<T>> list) =>
      IndexedTree()..addAll(list);

  final ListNode<T> _root;

  List<ListNode<T>> get children => _root.children;

  int get length => children.length;

  ListNode<T> get root => _root;

  ListNode<T> elementAt(String path) => _root.elementAt(path) as ListNode<T>;

  ListNode<T> operator [](int at) => _root.children[at];

  ListNode<T> get first => _root.children.first;

  set first(ListNode<T> value) {
    _root.children.first = value;
  }

  ListNode<T> get last => _root.children.last;

  set last(ListNode<T> value) {
    _root.children.last = value;
  }

  ListNode<T> firstWhere(bool Function(ListNode<T> element) test,
      {ListNode<T> orElse()?, String? path}) {
    final node = path == null ? _root : _root[path];
    return node.children.firstWhere(test, orElse: orElse);
  }

  int indexWhere(bool Function(ListNode<T> element) test,
      {int start = 0, String? path}) {
    final node = path == null ? _root : _root[path];
    return node.children.indexWhere(test, start);
  }

  ListNode<T> lastWhere(bool Function(ListNode<T> element) test,
      {ListNode<T> orElse()?, String? path}) {
    final node = path == null ? _root : _root[path];
    return node.children.lastWhere(test, orElse: orElse);
  }

  void add(Node<T> value, {String? path}) {
    final node = path == null ? _root : _root[path];
    node.add(value);
  }

  void addAll(Iterable<Node<T>> iterable, {String? path}) {
    final node = path == null ? _root : _root[path];
    node.addAll(iterable);
  }

  void insert(int index, Node<T> element, {String? path}) {
    final node = path == null ? _root : _root[path];
    node.insert(index, element);
  }

  int insertAfter(Node<T> element, {String? path}) {
    final node = path == null ? _root : _root[path];
    return node.insertAfter(element);
  }

  void insertAll(int index, Iterable<Node<T>> iterable, {String? path}) {
    final node = path == null ? _root : _root[path];
    node.insertAll(index, iterable);
  }

  int insertBefore(Node<T> element, {String? path}) {
    final node = path == null ? _root : _root[path];
    return node.insertBefore(element);
  }

  void remove(String key, {String? path}) {
    final node = path == null ? _root : _root[path];
    node.remove(key);
  }

  ListNode<T> removeAt(int index, {String? path}) {
    final node = path == null ? _root : _root[path];
    return node.removeAt(index) as ListNode<T>;
  }

  void removeAll(Iterable<String> keys, {String? path}) {
    final node = path == null ? _root : _root[path];
    node.removeAll(keys);
  }

  void clear({String? path}) {
    final node = path == null ? _root : _root[path];
    node.clear();
  }
}
