import 'package:flutter/foundation.dart';
import '../indexed_tree.dart';
import '../tree.dart';
import '../tree_change_notifier.dart';
import 'i_tree.dart';

abstract class IListenableTree<T>
    extends TreeChangeNotifier<T>
    implements ITree<T>, ValueListenable<Tree<T>> {}

abstract class IListenableIndexedTree<T>
    extends TreeChangeNotifier<T>
    implements ITree<T>, IIndexedTree<T>, ValueListenable<IndexedTree<T>> {}
