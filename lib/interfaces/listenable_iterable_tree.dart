import 'package:flutter/foundation.dart';
import 'package:multi_level_list_view/interfaces/iterable_tree.dart';
import 'package:multi_level_list_view/tree_structures/node.dart';
import 'iterable_tree_update_provider.dart';

abstract class ListenableIterableTree<T extends Node<T>>
    with IterableTreeUpdateProvider<T>
    implements IterableTree<T>, ValueListenable<IterableTree<T>> {}

abstract class ListenableInsertableIterableTree<T extends Node<T>>
    with IterableTreeUpdateProvider<T>
    implements InsertableIterableTree<T>, ValueListenable<IterableTree<T>> {}
