import 'dart:async';

import 'package:animated_tree_view/src/helpers/event_stream_controller.dart';
import 'package:animated_tree_view/src/helpers/exceptions.dart';
import 'package:animated_tree_view/src/node/base/i_node.dart';
import 'package:animated_tree_view/src/node/indexed_node.dart';
import 'package:flutter/foundation.dart';

import 'base/i_listenable_node.dart';

class ListenableIndexedNode<T> extends IndexedNode<T>
    with ChangeNotifier
    implements IListenableNode<T> {
  /// A listenable implementation the [Node].
  /// The mutations to the [Node] can be listened to using the [ValueListenable]
  /// interface or the [addedNodes] and [removedNodes] streams.
  ///
  /// The [ListenableIndexedNode] can also be used with a [ValueListenableBuilder]
  /// for updating the UI whenever the [Node] is mutated.
  ///
  /// Default constructor that takes an optional [key] and a parent.
  /// Make sure that the provided [key] is unique to among the siblings of the node.
  /// If a [key] is not provided, then a [UniqueKey] will automatically be
  /// assigned to the [Node].
  ListenableIndexedNode({String? key, IndexedNode<T>? parent})
      : super(key: key, parent: parent);

  /// Alternate factory constructor for [ListenableIndexedNode] that should be used for
  /// the [root] nodes.
  factory ListenableIndexedNode.root() =>
      ListenableIndexedNode(key: INode.ROOT_KEY);

  /// This is the parent [ListenableNode]. Only the root node has a null [parent]
  ListenableIndexedNode<T>? parent;

  /// Getter to get the [value] of the [ValueListenable]. It returns the [root]
  T get value => root as T;

  /// This returns the [children] as an iterable list.
  List<ListenableIndexedNode<T>> get childrenAsList =>
      List<ListenableIndexedNode<T>>.from(super.childrenAsList);

  /// Getter to get the [root] node.
  /// If the current node is not a [root], then the getter will traverse up the
  /// path to get the [root].
  ListenableIndexedNode<T> get root => super.root as ListenableIndexedNode<T>;

  /// Get the [first] child in the list
  ListenableIndexedNode<T> get first => super.first as ListenableIndexedNode<T>;

  /// Set the [last] child in the list to [value]
  ListenableIndexedNode<T> get last => super.last as ListenableIndexedNode<T>;

  /// Set the [first] child in the list to [value]
  set first(IndexedNode<T> value) {
    this.first = value;
    _notifyListeners();
  }

  /// Set the [last] child in the list to [value]
  set last(IndexedNode<T> value) {
    this.last = value;
    _notifyListeners();
  }

  /// Get the first child node that matches the criterion in the [test].
  /// An optional [orElse] function can be provided to handle the [test] is not
  /// able to find any node that matches the provided criterion.
  ListenableIndexedNode<T> firstWhere(
      bool Function(IndexedNode<T> element) test,
      {IndexedNode<T> orElse()?}) {
    return super.firstWhere(test, orElse: orElse) as ListenableIndexedNode<T>;
  }

  /// Get the index of the first child node that matches the criterion in the
  /// [test].
  /// An optional [start] index can be provided to ignore any nodes before the
  /// index [start]
  int indexWhere(bool Function(IndexedNode<T> element) test, [int start = 0]) {
    return super.indexWhere(test, start);
  }

  /// Get the last child node that matches the criterion in the [test].
  /// An optional [orElse] function can be provided to handle the [test] is not
  /// able to find any node that matches the provided criterion.
  ListenableIndexedNode<T> lastWhere(bool Function(IndexedNode<T> element) test,
      {IndexedNode<T> orElse()?}) {
    return super.lastWhere(test, orElse: orElse) as ListenableIndexedNode<T>;
  }

  final EventStreamController<NodeAddEvent<T>> _addedNodes =
      EventStreamController();

  final EventStreamController<NodeInsertEvent<T>> _insertedNodes =
      EventStreamController();

  final EventStreamController<NodeRemoveEvent<T>> _removedNodes =
      EventStreamController();

  /// Listen to this [Stream] to get updates on when a Node or a collection of
  /// Nodes is added to the current node.
  ///
  /// The stream should only be listened to on the [root] node.
  /// [ActionNotAllowedException] if a non-root tries to listen the [addedNodes]
  Stream<NodeAddEvent<T>> get addedNodes {
    if (!isRoot) throw ActionNotAllowedException.listener(this);
    return _addedNodes.stream;
  }

  /// Listen to this [Stream] to get updates on when a Node or a collection of
  /// Nodes is removed from the current node.
  ///
  /// The stream should only be listened to on the [root] node.
  /// [ActionNotAllowedException] if a non-root tries to listen the [removedNodes]
  Stream<NodeRemoveEvent<T>> get removedNodes {
    if (!isRoot) throw ActionNotAllowedException.listener(this);
    return _removedNodes.stream;
  }

  /// Listen to this [Stream] to get updates on when a Node or a collection of
  /// Nodes is inserted in the current node.
  ///
  /// The stream should only be listened to on the [root] node.
  /// [ActionNotAllowedException] if a non-root tries to listen the [insertedNodes]
  Stream<NodeInsertEvent<T>> get insertedNodes {
    if (!isRoot) throw ActionNotAllowedException.listener(this);
    return _insertedNodes.stream;
  }

  /// Add a child [value] node to the [children]. The [value] will be inserted
  /// after the last child in the list
  ///
  /// The [ValueListenable] and [addedNodes] listeners will also be notified
  /// on this operation
  void add(IndexedNode<T> value) {
    super.add(value);
    _notifyListeners();
    _notifyNodesAdded(NodeAddEvent(List<T>.from([value])));
  }

  /// Add a collection of [Iterable] nodes to [children]. The [iterable] will be
  /// inserted after the last child in the list
  ///
  /// The [ValueListenable] and [addedNodes] listeners will also be notified
  /// on this operation
  void addAll(Iterable<IndexedNode<T>> iterable) {
    super.addAll(iterable);
    _notifyListeners();
    _notifyNodesAdded(NodeAddEvent(List<T>.from(iterable)));
  }

  /// Insert an [element] in the children list at [index]
  ///
  /// The [ValueListenable] and [insertedNodes] listeners will also be notified
  /// on this operation
  void insert(int index, IndexedNode<T> element) {
    super.insert(index, element);
    _notifyListeners();
    _notifyNodesInserted(NodeInsertEvent<T>(List<T>.from([element]), index));
  }

  /// Insert an [element] in the children list after the node [after]
  ///
  /// The [ValueListenable] and [insertedNodes] listeners will also be notified
  /// on this operation
  int insertAfter(IndexedNode<T> after, IndexedNode<T> element) {
    final index = super.insertAfter(after, element);
    return index;
  }

  /// Insert an [element] in the children list before the node [before]
  ///
  /// The [ValueListenable] and [insertedNodes] listeners will also be notified
  /// on this operation
  int insertBefore(IndexedNode<T> before, IndexedNode<T> element) {
    final index = super.insertBefore(before, element);
    return index;
  }

  /// Insert a collection of [Iterable] nodes in the children list at [index]
  ///
  /// The [ValueListenable] and [insertedNodes] listeners will also be notified
  /// on this operation
  void insertAll(int index, Iterable<IndexedNode<T>> iterable) {
    super.insertAll(index, iterable);
    _notifyListeners();
    _notifyNodesInserted(NodeInsertEvent<T>(List<T>.from(iterable), index));
  }

  /// Delete [this] node
  ///
  /// The [ValueListenable] and [removedNodes] listeners will also be notified
  /// on this operation
  void delete() {
    final nodeToRemove = this;
    super.delete();
    _notifyListeners();
    _notifyNodesRemoved(NodeRemoveEvent(List<T>.from([nodeToRemove])));
  }

  /// Remove a child [value] node from the [children]
  ///
  /// The [ValueListenable] and [removedNodes] listeners will also be notified
  /// on this operation
  void remove(IndexedNode<T> value) {
    super.remove(value);
    _notifyListeners();
    _notifyNodesRemoved(NodeRemoveEvent(List<T>.from([value])));
  }

  /// Remove the child node at the [index]
  ///
  /// The [ValueListenable] and [removedNodes] listeners will also be notified
  /// on this operation
  ListenableIndexedNode<T> removeAt(int index) {
    final removedNode = super.removeAt(index);
    _notifyListeners();
    _notifyNodesRemoved(NodeRemoveEvent(List<T>.from([removedNode])));
    return removedNode as ListenableIndexedNode<T>;
  }

  /// Remove all the [Iterable] nodes from the [children]
  ///
  /// The [ValueListenable] and [removedNodes] listeners will also be notified
  /// on this operation
  void removeAll(Iterable<IndexedNode<T>> iterable) {
    for (final value in iterable) {
      final index = children.indexWhere((node) => node.key == value.key);
      if (index < 0) throw NodeNotFoundException(key: key);
      children.removeAt(index);
    }

    _notifyListeners();
    _notifyNodesRemoved(NodeRemoveEvent(List<T>.from(iterable)));
  }

  /// Remove all the child nodes from the [children] that match the criterion
  /// in the given [test]
  ///
  /// The [ValueListenable] and [removedNodes] listeners will also be notified
  /// on this operation
  void removeWhere(bool test(IndexedNode<T> element)) {
    final allChildren = childrenAsList.toSet();
    super.removeWhere(test);
    _notifyListeners();
    final remainingChildren = childrenAsList.toSet();
    allChildren.removeAll(remainingChildren);

    if (allChildren.isNotEmpty)
      _notifyNodesRemoved(NodeRemoveEvent(List<T>.from(allChildren)));
  }

  /// Clear all the child nodes from [children]. The [children] will be empty
  /// after this operation.
  ///
  /// The [ValueListenable] and [removedNodes] listeners will also be notified
  /// on this operation
  void clear() {
    final clearedNodes = childrenAsList;
    super.clear();
    _notifyListeners();
    _notifyNodesRemoved(NodeRemoveEvent(List<T>.from(clearedNodes)));
  }

  /// * Utility method to get a child node at the [path].
  /// Get any item at [path] from the [root]
  /// The keys of the items to be traversed should be provided in the [path]
  ///
  /// For example in a TreeView like this
  ///
  /// ```dart
  /// Node get mockNode1 => Node.root()
  ///   ..addAll([
  ///     Node(key: "0A")..add(Node(key: "0A1A")),
  ///     Node(key: "0B"),
  ///     Node(key: "0C")
  ///       ..addAll([
  ///         Node(key: "0C1A"),
  ///         Node(key: "0C1B"),
  ///         Node(key: "0C1C")
  ///           ..addAll([
  ///             Node(key: "0C1C2A")
  ///               ..addAll([
  ///                 Node(key: "0C1C2A3A"),
  ///                 Node(key: "0C1C2A3B"),
  ///                 Node(key: "0C1C2A3C"),
  ///               ]),
  ///           ]),
  ///       ]),
  ///   ]);
  ///```
  ///
  /// In order to access the Node with key "0C1C", the path would be
  ///   0C.0C1C
  ///
  /// Note: The root node [ROOT_KEY] does not need to be in the path
  ListenableIndexedNode<T> elementAt(String path) =>
      super.elementAt(path) as ListenableIndexedNode<T>;

  ListenableIndexedNode<T> at(int index) =>
      super.at(index) as ListenableIndexedNode<T>;

  ListenableIndexedNode<T> operator [](String path) => elementAt(path);

  void dispose() {
    _addedNodes.close();
    _removedNodes.close();
    _insertedNodes.close();
    super.dispose();
  }

  void _notifyListeners() {
    notifyListeners();
    if (!isRoot) parent!._notifyListeners();
  }

  void _notifyNodesAdded(NodeAddEvent<T> event) {
    if (isRoot) {
      _addedNodes.emit(event);
    } else {
      root._notifyNodesAdded(event);
    }
  }

  void _notifyNodesInserted(NodeInsertEvent<T> event) {
    if (isRoot) {
      _insertedNodes.emit(event);
    } else {
      root._notifyNodesInserted(event);
    }
  }

  void _notifyNodesRemoved(NodeRemoveEvent<T> event) {
    if (isRoot) {
      _removedNodes.emit(event);
    } else {
      root._notifyNodesRemoved(event);
    }
  }
}
