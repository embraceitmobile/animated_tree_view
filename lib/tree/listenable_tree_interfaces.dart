import 'package:flutter/foundation.dart';
import 'i_tree.dart';
import 'indexed_tree.dart';
import 'tree.dart';
import 'tree_update_provider.dart';

abstract class IListenableTree<T>
    with TreeUpdateProvider<T>
    implements ITree<T>, ValueListenable<Tree<T>> {}

abstract class IListenableIndexedTree<T>
    with TreeUpdateProvider<T>
    implements ITree<T>, IIndexedTree<T>, ValueListenable<IndexedTree<T>> {}
