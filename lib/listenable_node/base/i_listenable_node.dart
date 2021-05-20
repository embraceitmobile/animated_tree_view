import 'package:flutter/foundation.dart';
import 'package:tree_structure_view/listenable_node/base/node_update_notifier.dart';
import 'package:tree_structure_view/node/node.dart';

abstract class IListenableNode<T> extends INode<T>
    implements NodeUpdateNotifier, ValueListenable<INode<T>> {}
