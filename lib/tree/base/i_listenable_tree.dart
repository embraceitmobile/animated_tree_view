import 'package:flutter/foundation.dart';
import '../indexed_tree.dart';
import '../tree.dart';
import '../tree_update_notifier.dart';
import 'i_tree.dart';

abstract class IListenableTree<T> extends ChangeNotifier
    implements TreeUpdateNotifier<T>, ITree<T>, ValueListenable<Tree<T>> {}

abstract class IListenableIndexedTree<T> extends ChangeNotifier
    implements
        TreeUpdateNotifier<T>,
        ITree<T>,
        IIndexedTree<T>,
        ValueListenable<IndexedTree<T>> {}
