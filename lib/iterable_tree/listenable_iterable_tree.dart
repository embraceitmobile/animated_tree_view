import 'package:flutter/foundation.dart';
import 'package:multi_level_list_view/collections/node_collections.dart';
import 'iterable_tree.dart';
import 'iterable_tree_update_provider.dart';

abstract class ListenableIterableTree<T extends Node<T>>
    with IterableTreeUpdateProvider<T>
    implements IterableTree<T>, ValueListenable<IterableTree<T>> {}
