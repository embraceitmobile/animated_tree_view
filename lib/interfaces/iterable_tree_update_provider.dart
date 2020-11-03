import 'dart:async';
import 'package:flutter/material.dart';
import 'package:multi_level_list_view/tree_structures/node.dart';

abstract class IterableTreeUpdateProvider<T extends Node<T>> {
  final StreamController<_NodeEvent<T>> _addedItemsController =
      StreamController<_NodeEvent<T>>.broadcast();

  final StreamController<_NodeEvent<T>> _insertedItemsController =
      StreamController<_NodeEvent<T>>.broadcast();

  final StreamController<_NodeEvent<T>> _removedItemsController =
      StreamController<_NodeEvent<T>>.broadcast();

  @protected
  void emitAddItems(Iterable<T> iterable, {String path}) {
    _addedItemsController.sink.add(_NodeEvent(iterable, path: path));
  }

  @protected
  void emitInsertItems(Iterable<T> iterable, int index, {String path}) {
    _insertedItemsController.sink
        .add(_NodeEvent(iterable, index: index, path: path));
  }

  @protected
  void emitRemoveItems(Iterable<T> iterable, {int index, String path}) {
    _removedItemsController.sink
        .add(_NodeEvent(iterable, index: index, path: path));
  }

  Stream<_NodeEvent<T>> get addedItems => _addedItemsController.stream;

  Stream<_NodeEvent<T>> get insertedItems => _insertedItemsController.stream;

  Stream<_NodeEvent<T>> get removedItems => _removedItemsController.stream;

  void dispose() {
    _addedItemsController.close();
    _insertedItemsController.close();
    _removedItemsController.close();
  }
}

class _NodeEvent<T extends Node<T>> {
  final List<T> items;
  final int index;
  final String path;

  const _NodeEvent(this.items, {this.index, this.path});
}
