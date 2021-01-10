import 'package:flutter/foundation.dart';
import '../insertable_tree.dart';
import '../tree.dart';
import '../tree_update_provider.dart';
import 'i_tree.dart';

abstract class IListenableTree<T>
    with TreeUpdateProvider<T>
    implements ITree<T>, ValueListenable<Tree<T>> {}

abstract class IListenableIndexedTree<T>
    with TreeUpdateProvider<T>
    implements ITree<T>, IInsertableTree<T>, ValueListenable<InsertableTree<T>> {}
