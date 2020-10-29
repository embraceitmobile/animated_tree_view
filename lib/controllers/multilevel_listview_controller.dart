import 'dart:async';
import 'package:multi_level_list_view/models/entry.dart';

class MultiLevelListViewController<T extends Entry<T>> {
  final StreamController<_ListUpdateModel<T>> _insertItemsController =
      StreamController<_ListUpdateModel<T>>.broadcast();

  final StreamController<_ListUpdateModel<T>> _removeItemsController =
      StreamController<_ListUpdateModel<T>>.broadcast();

  Stream<_ListUpdateModel<T>> get insertItemsStream =>
      _insertItemsController.stream;

  Stream<_ListUpdateModel<T>> get removeItemsStream =>
      _removeItemsController.stream;

  void insert(T item, {String path}) {
    _insertItemsController.sink
        .add(_ListUpdateModel<T>([item], path: path ?? ""));
  }

  void insertAll(List<T> items, {String path}) {
    _insertItemsController.sink
        .add(_ListUpdateModel<T>(items, path: path ?? ""));
  }

  void remove(T item, {String path}) {
    _removeItemsController.sink
        .add(_ListUpdateModel<T>([item], path: path ?? ""));
  }

  void removeAll(List<T> items, {String path}) {
    _removeItemsController.sink
        .add(_ListUpdateModel<T>(items, path: path ?? ""));
  }

  void dispose() {
    _insertItemsController.close();
    _removeItemsController.close();
  }
}

class _ListUpdateModel<T> {
  final List<T> items;
  final String path;

  const _ListUpdateModel(this.items, {this.path});
}
