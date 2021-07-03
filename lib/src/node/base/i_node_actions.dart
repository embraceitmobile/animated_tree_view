import 'package:animated_tree_view/src/node/indexed_node.dart';

import 'i_node.dart';

/// Base class for Node that defines the actions that a Node can perform
abstract class INodeActions<T> {
  /// Add a child [value] node to the [this] node
  void add(covariant INode<T> value);

  /// Add a collection of [Iterable] nodes to [this] node
  void addAll(covariant Iterable<INode<T>> iterable);

  /// Remove a child [value] node from the [this] node
  void remove(covariant INode<T> value);

  /// Delete [this] node
  void delete();

  /// Remove all the [Iterable] nodes from [this] node
  void removeAll(covariant Iterable<INode<T>> iterable);

  /// Remove all the child nodes from [this] node that match the criterion
  /// in the given [test]
  void removeWhere(bool test(INode<T> element));

  /// Clear all the child nodes from [this] node. [this] node will not have
  /// children after this operation.
  void clear();
}

abstract class IIndexedNodeActions<T> extends INodeActions<T> {
  /// Returns the child node at the [index]
  IndexedNode<T> at(int index);

  /// Set the [first] child in the list to [value]
  set first(IndexedNode<T> value);

  /// Get the [first] child in the list
  IndexedNode<T> get first;

  /// Set the [last] child in the list to [value]
  set last(IndexedNode<T> value);

  /// Get the [last] child in the list
  IndexedNode<T> get last;

  /// Insert an [element] in the children list at [index]
  void insert(int index, IndexedNode<T> element);

  /// Insert a collection of [Iterable] nodes in the children list at [index]
  void insertAll(int index, Iterable<IndexedNode<T>> iterable);

  /// Insert an [element] in the children list after the node [after]
  int insertAfter(IndexedNode<T> after, IndexedNode<T> element);

  /// Insert an [element] in the children list before the node [before]
  int insertBefore(IndexedNode<T> before, IndexedNode<T> element);

  /// Remove the child node at the [index]
  IndexedNode<T> removeAt(int index);

  /// Get the first child node that matches the criterion in the [test].
  /// An optional [orElse] function can be provided to handle the [test] is not
  /// able to find any node that matches the provided criterion.
  IndexedNode<T> firstWhere(bool Function(IndexedNode<T> element) test,
      {IndexedNode<T> orElse()?});

  /// Get the index of the first child node that matches the criterion in the
  /// [test].
  /// An optional [start] index can be provided to ignore any nodes before the
  /// index [start]
  int indexWhere(bool Function(IndexedNode<T> element) test, [int start = 0]);

  /// Get the last child node that matches the criterion in the [test].
  /// An optional [orElse] function can be provided to handle the [test] is not
  /// able to find any node that matches the provided criterion.
  IndexedNode<T> lastWhere(bool Function(IndexedNode<T> element) test,
      {IndexedNode<T> orElse()?});
}
