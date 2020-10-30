import 'dart:async';
import 'package:flutter/material.dart';
import 'package:multi_level_list_view/tree_list/node.dart';

class ListenableTreeList<T extends Node<T>> extends ChangeNotifier {
  final StreamController<_NodeEvent<T>> _insertedItemsController =
      StreamController<_NodeEvent<T>>.broadcast();

  final StreamController<_NodeEvent<T>> _removedItemsController =
      StreamController<_NodeEvent<T>>.broadcast();

  Stream<_NodeEvent<T>> get insertedItems => _insertedItemsController.stream;

  Stream<_NodeEvent<T>> get removedItems => _removedItemsController.stream;

  void dispose() {
    _insertedItemsController.close();
    _removedItemsController.close();
    super.dispose();
  }
}

class _NodeEvent<T extends Node<T>> {
  final List<T> items;
  final String path;

  const _NodeEvent(this.items, {this.path});
}
