// import 'dart:async';
//
// import 'package:tree_structure_view/node/indexed_node.dart';
// import 'package:tree_structure_view/node/base/i_node.dart';
// import 'package:tree_structure_view/listenable_tree/base/i_listenable_tree.dart';
// import 'package:tree_structure_view/tree/base/i_tree.dart';
// import 'package:tree_structure_view/tree/indexed_tree.dart';
// import 'package:tree_structure_view/tree/base/tree_update_notifier.dart';
//
// class ListenableIndexedTree<T> extends IListenableIndexedTree<T>
//     implements ITree<T>, IIndexedTree<T> {
//   ListenableIndexedTree(IndexedTree<T> tree) : _value = tree;
//
//   factory ListenableIndexedTree.fromList(List<IndexedNode<T>> list) =>
//       ListenableIndexedTree(IndexedTree<T>.fromList(list));
//
//   final IndexedTree<T> _value;
//
//   final StreamController<NodeAddEvent<T>> _addedNodes =
//       StreamController<NodeAddEvent<T>>.broadcast();
//
//   final StreamController<NodeRemoveEvent> _removedNodes =
//       StreamController<NodeRemoveEvent>.broadcast();
//
//   final StreamController<NodeInsertEvent<T>> _insertedNodes =
//       StreamController<NodeInsertEvent<T>>.broadcast();
//
//   IndexedNode<T> get root => _value.root;
//
//   IndexedTree<T> get value => _value;
//
//   int get length => _value.length;
//
//   Stream<NodeAddEvent<T>> get addedNodes => _addedNodes.stream;
//
//   Stream<NodeInsertEvent<T>> get insertedNodes => _insertedNodes.stream;
//
//   Stream<NodeRemoveEvent> get removedNodes => _removedNodes.stream;
//
//   INode<T> operator [](covariant at) => _value[at];
//
//   IndexedNode<T> elementAt(String? path) =>
//       path == null ? root : _value.elementAt(path);
//
//   IndexedNode<T> at(int index) => _value.at(index);
//
//   IndexedNode<T> get first => _value.first;
//
//   set first(IndexedNode<T> value) {
//     _value.first = value;
//   }
//
//   IndexedNode<T> get last => _value.last;
//
//   set last(IndexedNode<T> value) {
//     _value.last = value;
//   }
//
//   int indexWhere(bool Function(INode<T> element) test,
//       {int start = 0, String? path}) {
//     return _value.indexWhere(test, start: start, path: path);
//   }
//
//   IndexedNode<T> firstWhere(bool Function(IndexedNode<T> element) test,
//       {IndexedNode<T> orElse()?, String? path}) {
//     return _value.firstWhere(test, orElse: orElse);
//   }
//
//   IndexedNode<T> lastWhere(bool Function(IndexedNode<T> element) test,
//       {IndexedNode<T> orElse()?, String? path}) {
//     return _value.lastWhere(test, orElse: orElse);
//   }
//
//   void add(INode<T> value, {String? path}) {
//     _value.add(value, path: path);
//     _notifyNodesAdded([value], path: path);
//   }
//
//   // Future<void> addAsync(INode<T> value, {String? path}) async {
//   //   await _value.addAsync(value, path: path);
//   //   _notifyNodesAdded([value], path: path);
//   // }
//
//   void addAll(Iterable<INode<T>> iterable, {String? path}) {
//     _value.addAll(iterable, path: path);
//     _notifyNodesAdded(iterable, path: path);
//   }
//
//   // Future<void> addAllAsync(Iterable<INode<T>> iterable, {String? path}) async {
//   //   await _value.addAllAsync(iterable, path: path);
//   //   _notifyNodesAdded(iterable, path: path);
//   // }
//
//   void clear({String? path}) {
//     final allKeys = path == null ? _value.children : elementAt(path).children;
//     _value.clear(path: path);
//     _notifyNodesRemoved((allKeys).map((node) => node.key), path: path);
//   }
//
//   void insert(int index, IndexedNode<T> element, {String? path}) {
//     _value.insert(index, element, path: path);
//     _notifyNodesInserted([element], index, path: path);
//   }
//
//   // Future<void> insertAsync(int index, IndexedNode<T> element,
//   //     {String? path}) async {
//   //   await _value.insertAsync(index, element, path: path);
//   //   _notifyNodesInserted([element], index, path: path);
//   // }
//
//   int insertAfter(IndexedNode<T> after, IndexedNode<T> element,
//       {String? path}) {
//     final index = _value.insertAfter(after, element, path: path);
//     _notifyNodesInserted([element], index);
//     return index;
//   }
//
//   // Future<int> insertAfterAsync(IndexedNode<T> after, IndexedNode<T> element,
//   //     {String? path}) async {
//   //   final index = await _value.insertAfterAsync(after, element, path: path);
//   //   _notifyNodesInserted([element], index);
//   //   return index;
//   // }
//
//   int insertBefore(IndexedNode<T> before, IndexedNode<T> element,
//       {String? path}) {
//     final index = _value.insertBefore(before, element, path: path);
//     _notifyNodesInserted([element], index);
//     return index;
//   }
//
//   // Future<int> insertBeforeAsync(IndexedNode<T> before, IndexedNode<T> element,
//   //     {String? path}) async {
//   //   final index = await _value.insertBeforeAsync(before, element, path: path);
//   //   _notifyNodesInserted([element], index);
//   //   return index;
//   // }
//
//   void insertAll(int index, Iterable<IndexedNode<T>> iterable, {String? path}) {
//     _value.insertAll(index, iterable, path: path);
//     _notifyNodesInserted(iterable, index, path: path);
//   }
//
//   // @override
//   // Future<void> insertAllAsync(int index, Iterable<IndexedNode<T>> iterable,
//   //     {String? path}) async {
//   //   await _value.insertAllAsync(index, iterable, path: path);
//   //   _notifyNodesInserted(iterable, index, path: path);
//   // }
//
//   INode<T> removeAt(int index, {String? path}) {
//     final removedNode = _value.removeAt(index, path: path);
//     _notifyNodesRemoved([removedNode.key], path: path);
//     return removedNode;
//   }
//
//   void remove(String key, {String? path}) {
//     _value.remove(key, path: path);
//     _notifyNodesRemoved([key], path: path);
//   }
//
//   void removeAll(Iterable<String> keys, {String? path}) {
//     _value.removeAll(keys, path: path);
//     _notifyNodesRemoved(keys, path: path);
//   }
//
//   void removeWhere(bool Function(INode<T> element) test, {String? path}) {
//     final allKeysInPath =
//         elementAt(path).children.map((node) => node.key).toSet();
//
//     _value.removeWhere(test, path: path);
//
//     final remainingKeysInPath =
//         elementAt(path).children.map((node) => node.key).toSet();
//
//     allKeysInPath.removeAll(remainingKeysInPath);
//     if (allKeysInPath.isNotEmpty) _notifyNodesRemoved(allKeysInPath);
//   }
//
//   void _notifyNodesAdded(Iterable<INode<T>> iterable, {String? path}) {
//     _addedNodes.sink.add(NodeAddEvent(iterable, path: path));
//     notifyListeners();
//   }
//
//   void _notifyNodesInserted(Iterable<INode<T>> iterable, int index,
//       {String? path}) {
//     _insertedNodes.sink.add(NodeInsertEvent(iterable, index, path: path));
//     notifyListeners();
//   }
//
//   void _notifyNodesRemoved(Iterable<String> keys, {String? path}) {
//     _removedNodes.sink.add(NodeRemoveEvent(keys, parentKey: path));
//     notifyListeners();
//   }
//
//   void dispose() {
//     _addedNodes.close();
//     _removedNodes.close();
//     _insertedNodes.close();
//     super.dispose();
//   }
// }
