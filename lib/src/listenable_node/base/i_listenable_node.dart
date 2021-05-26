import 'package:animated_tree_view/src/node/base/i_node.dart';
import 'package:flutter/foundation.dart';

import 'node_update_notifier.dart';

abstract class IListenableNode<T> extends INode<T>
    implements NodeUpdateNotifier<T>, ValueListenable<T> {}
