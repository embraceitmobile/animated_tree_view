import 'dart:async';
import 'package:flutter/material.dart';


abstract class TreeUpdateProvider<T> {
  final StreamController<NodeEvent<T>> _addedItemsController =
      StreamController<NodeEvent<T>>.broadcast();

  final StreamController<NodeEvent<T>> _insertedItemsController =
      StreamController<NodeEvent<T>>.broadcast();

  final StreamController<NodeEvent<T>> _removedItemsController =
      StreamController<NodeEvent<T>>.broadcast();

  @protected
  void emitAddItems(Iterable<T> iterable, {String? path}) {
    _addedItemsController.sink.add(NodeEvent(iterable as List<T>, path: path));
  }

  @protected
  void emitInsertItems(Iterable<T> iterable, int index, {String? path}) {
    _insertedItemsController.sink
        .add(NodeEvent(iterable as List<T>, index: index, path: path));
  }

  @protected
  void emitRemoveItems(Iterable<T> iterable, {String? path}) {
    _removedItemsController.sink.add(NodeEvent(iterable as List<T>, path: path));
  }

  Stream<NodeEvent<T>> get addedItems => _addedItemsController.stream;

  Stream<NodeEvent<T>> get insertedItems => _insertedItemsController.stream;

  Stream<NodeEvent<T>> get removedItems => _removedItemsController.stream;

  void dispose() {
    _addedItemsController.close();
    _insertedItemsController.close();
    _removedItemsController.close();
  }
}

class NodeEvent<T> {
  final List<T> items;
  final int? index;
  final String? path;

  const NodeEvent(this.items, {this.index, this.path});
}
