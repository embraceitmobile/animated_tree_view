import 'package:multi_level_list_view/tree_list/node.dart';



abstract class ITreeList<T extends Node<T>> {
  external factory ITreeList.fromList(List<T> list);

  external factory ITreeList.empty();

  void insertAt(T item, int index, {String path});

  void insert(T item, {String path});

  void insertAll(List<T> items, {String path});

  void remove(T item, {String path});

  void removeAll(List<T> items, {String path});

  void removeAt(int index, {String path});

  void removeAllAt(String path);
}
