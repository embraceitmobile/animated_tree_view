import 'package:tree_structure_view/node/indexed_node.dart';

import 'i_node.dart';

abstract class INodeActions<T> {
  void add(covariant INode<T> value);

  void addAll(covariant Iterable<INode<T>> iterable);

  void remove(covariant INode<T> value);

  void delete();

  void removeAll(covariant Iterable<INode<T>> iterable);

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

  void insertAll(int index, Iterable<IndexedNode<T>> iterable);

  int insertAfter(IndexedNode<T> after, IndexedNode<T> element);

  int insertBefore(IndexedNode<T> before, IndexedNode<T> element);

  IndexedNode<T> removeAt(int index);

  IndexedNode<T> firstWhere(bool Function(IndexedNode<T> element) test,
      {IndexedNode<T> orElse()?});

  int indexWhere(bool Function(IndexedNode<T> element) test, [int start = 0]);

  IndexedNode<T> lastWhere(bool Function(IndexedNode<T> element) test,
      {IndexedNode<T> orElse()?});
}
