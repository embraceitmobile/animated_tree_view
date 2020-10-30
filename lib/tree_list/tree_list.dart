import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:multi_level_list_view/tree_list/node.dart';
import 'i_tree_list.dart';

class TreeList<T extends Node<T>> implements ITreeList<T> {
  TreeList._(TreeNode<T> root) : _root = root;
  TreeNode<T> _root;

  factory TreeList.fromList(List<T> list) => TreeList._(TreeNode(list));

  factory TreeList.empty() => TreeList._(TreeNode(<T>[]));

  void insertAt(T item, int index, {String path}) {}

  void insert(T item, {String path}) {}

  void insertAll(List<T> items, {String path}) {}

  void remove(T item, {String path}) {}

  void removeAll(List<T> items, {String path}) {}

  void removeAt(int index, {String path}) {}

  void removeAllAt(String path) {}
}
