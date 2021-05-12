import 'package:tree_structure_view/node/indexed_node.dart';
import 'package:tree_structure_view/node/node.dart';

abstract class ITree<T> {
  external factory ITree();

  external factory ITree.fromMap(Map<String, INode<T>> map);

  INode<T> get root;

  void add(INode<T> value, {String? path});

  Future<void> addAsync(INode<T> value, {String? path});

  void remove(String key, {String? path});

  void addAll(Iterable<INode<T>> iterable, {String? path});

  Future<void> addAllAsync(Iterable<INode<T>> iterable, {String? path});

  void removeAll(Iterable<String> keys, {String? path});

  void removeWhere(bool test(INode<T> element), {String? path});

  void clear({String? path});

  INode<T> elementAt(String? path);

  INode<T> operator [](String at);

  int get length;
}

abstract class IIndexedTree<T> implements ITree<T> {
  external factory IIndexedTree();

  external factory IIndexedTree.from(List<INode<T>> list);

  void insert(int index, IndexedNode<T> element, {String? path});

  Future<void> insertAsync(int index, IndexedNode<T> element, {String? path});

  void insertAll(int index, Iterable<IndexedNode<T>> iterable, {String? path});

  Future<void> insertAllAsync(int index, Iterable<IndexedNode<T>> iterable,
      {String? path});

  int insertAfter(IndexedNode<T> after, IndexedNode<T> element, {String? path});

  Future<int> insertAfterAsync(IndexedNode<T> after, IndexedNode<T> element,
      {String? path});

  int insertBefore(IndexedNode<T> before, IndexedNode<T> element,
      {String? path});

  Future<int> insertBeforeAsync(IndexedNode<T> before, IndexedNode<T> element,
      {String? path});

  INode<T> removeAt(int index, {String? path});

  set first(IndexedNode<T> value);

  IndexedNode<T> get first;

  set last(IndexedNode<T> value);

  IndexedNode<T> get last;

  IndexedNode<T> at(int index);

  int indexWhere(bool test(INode<T> element), {int start = 0, String? path});

  IndexedNode<T> firstWhere(bool test(IndexedNode<T> element),
      {IndexedNode<T> orElse()?, String? path});

  IndexedNode<T> lastWhere(bool test(IndexedNode<T> element),
      {IndexedNode<T> orElse()?, String? path});
}
