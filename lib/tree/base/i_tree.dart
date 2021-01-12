import 'package:multi_level_list_view/node/list_node.dart';
import 'package:multi_level_list_view/node/map_node.dart';

abstract class ITree<T> {
  external factory ITree();

  external factory ITree.fromList(List<Node<T>> list);

  external factory ITree.fromMap(Map<String, Node<T>> map);

  Node<T> get root;

  void add(Node<T> value, {String path});

  void remove(Node<T> element, {String path});

  void addAll(Iterable<Node<T>> iterable, {String path});

  void removeAll(Iterable<Node<T>> iterable, {String path});

  void removeWhere(bool test(Node<T> element), {String path});

  void clear({String path});

  Node<T> elementAt(String path);

  Node<T> operator [](covariant dynamic at);

  int get length;
}

abstract class IIndexedTree<T> extends ITree<T> {
  external factory IIndexedTree();

  external factory IIndexedTree.from(List<Node<T>> list);

  void insert(int index, Node<T> element, {String path});

  void insertAll(int index, Iterable<Node<T>> iterable, {String path});

  void insertAfter(Node<T> element, {String path});

  void insertBefore(Node<T> element, {String path});

  Node<T> removeAt(int index, {String path});

  set first(ListNode<T> value);

  ListNode<T> get first;

  set last(ListNode<T> value);

  ListNode<T> get last;

  int indexWhere(bool test(Node<T> element), {int start = 0, String path});

  Node<T> firstWhere(bool test(Node<T> element),
      {Node<T> orElse(), String path});

  Node<T> lastWhere(bool test(Node<T> element),
      {Node<T> orElse(), String path});
}
