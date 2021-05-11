import 'package:flutter/foundation.dart';
import '../../tree/indexed_tree.dart';
import '../../tree/tree.dart';
import '../../tree/base/tree_update_notifier.dart';
import '../../tree/base/i_tree.dart';

abstract class IListenableTree<T> extends ChangeNotifier
    implements TreeUpdateNotifier<T>, ITree<T>, ValueListenable<Tree<T>> {}

abstract class IListenableIndexedTree<T> extends ChangeNotifier
    implements
        TreeUpdateNotifier<T>,
        ITree<T>,
        IIndexedTree<T>,
        ValueListenable<IndexedTree<T>> {}
