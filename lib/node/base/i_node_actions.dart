import 'package:tree_structure_view/node/indexed_node.dart';

import 'i_node.dart';

abstract class INodeActions<T> {
  void add(INode<T> value);

  Future<void> addAsync(INode<T> value);

  void addAll(Iterable<INode<T>> iterable);

  Future<void> addAllAsync(Iterable<INode<T>> iterable);

  void remove(String key);

  void removeAll(Iterable<String> keys);

  void removeWhere(bool test(INode<T> element));

  void clear();
}

abstract class IIndexedNodeActions<T> implements INodeActions<T> {
  IndexedNode<T> at(int index);

  set first(IndexedNode<T> value);

  IndexedNode<T> get first;

  set last(IndexedNode<T> value);

  IndexedNode<T> get last;

  void insert(int index, IndexedNode<T> element);

  Future<void> insertAsync(int index, IndexedNode<T> element);

  void insertAll(int index, Iterable<IndexedNode<T>> iterable);

  Future<void> insertAllAsync(int index, Iterable<IndexedNode<T>> iterable);

  int insertAfter(IndexedNode<T> after, IndexedNode<T> element);

  Future<int> insertAfterAsync(IndexedNode<T> after, IndexedNode<T> element);

  int insertBefore(IndexedNode<T> before, IndexedNode<T> element);

  Future<int> insertBeforeAsync(IndexedNode<T> before, IndexedNode<T> element);

  IndexedNode<T> removeAt(int index);
}
