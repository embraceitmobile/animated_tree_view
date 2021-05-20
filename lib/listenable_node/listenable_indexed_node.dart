import 'package:flutter/foundation.dart';
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

  final bool shouldBubbleUpEvents;

  factory ListenableIndexedNode.root() =>
      ListenableIndexedNode(key: INode.ROOT_KEY);

  @override
  // TODO: implement addedNodes
  Stream<NodeAddEvent> get addedNodes => throw UnimplementedError();

  @override
  // TODO: implement insertedNodes
  Stream<NodeInsertEvent> get insertedNodes => throw UnimplementedError();

  @override
  // TODO: implement removedNodes
  Stream<NodeRemoveEvent> get removedNodes => throw UnimplementedError();

  @override
  // TODO: implement value
  ListenableIndexedNode<T> get value => this;
}
