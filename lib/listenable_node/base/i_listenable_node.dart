import 'package:flutter/foundation.dart';
import 'package:tree_structure_view/node/base/i_node_actions.dart';
import 'package:tree_structure_view/node/indexed_node.dart';
import 'package:tree_structure_view/node/node.dart';

abstract class IListenableNode<T> extends Node<T>
    implements INodeActions<T>, ValueListenable<Node<T>> {}

abstract class IListenableIndexedNode<T extends INode<T>> extends IndexedNode<T>
    implements IIndexedNodeActions<T>, ValueListenable<IndexedNode<T>> {}
