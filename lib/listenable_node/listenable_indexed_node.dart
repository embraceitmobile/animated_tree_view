import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:tree_structure_view/helpers/exceptions.dart';
import 'package:tree_structure_view/listenable_node/base/node_update_notifier.dart';
import 'package:tree_structure_view/node/base/i_node.dart';
import 'package:tree_structure_view/node/indexed_node.dart';

import 'base/i_listenable_node.dart';

class ListenableIndexedNode<T extends INode<T>> extends IndexedNode<T>
    with ChangeNotifier
    implements IListenableNode<T> {
  ListenableIndexedNode(
      {String? key, IndexedNode<T>? parent, this.shouldBubbleUpEvents = true})
      : super(key: key, parent: parent);

  factory ListenableIndexedNode.root() =>
      ListenableIndexedNode(key: INode.ROOT_KEY);

  final bool shouldBubbleUpEvents;

  StreamController<NodeAddEvent<T>>? _nullableAddedNodes;

  StreamController<NodeInsertEvent<T>>? _nullableInsertedNodes;

  StreamController<NodeRemoveEvent<T>>? _nullableRemovedNodes;

  StreamController<NodeAddEvent<T>> get _addedNodes =>
      _nullableAddedNodes ??= StreamController<NodeAddEvent<T>>.broadcast();

  StreamController<NodeInsertEvent<T>> get _insertedNodes =>
      _nullableInsertedNodes ??=
          StreamController<NodeInsertEvent<T>>.broadcast();

  StreamController<NodeRemoveEvent<T>> get _removedNodes =>
      _nullableRemovedNodes ??=
          StreamController<NodeRemoveEvent<T>>.broadcast();

  Stream<NodeAddEvent<T>> get addedNodes {
    if (!isRoot) throw ActionNotAllowedException.listener(this);
    return _addedNodes.stream;
  }

  Stream<NodeRemoveEvent<T>> get removedNodes {
    if (!isRoot) throw ActionNotAllowedException.listener(this);
    return _removedNodes.stream;
  }

  Stream<NodeInsertEvent<T>> get insertedNodes {
    if (!isRoot) throw ActionNotAllowedException.listener(this);
    return _insertedNodes.stream;
  }

  T get value => root as T;

  void dispose() {
    _nullableAddedNodes?.close();
    _nullableRemovedNodes?.close();
    _nullableInsertedNodes?.close();
    super.dispose();
  }
}
