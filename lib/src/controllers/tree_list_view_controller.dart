import 'package:animated_tree_view/src/controllers/animated_list_controller.dart';
import 'package:animated_tree_view/src/listenable_node/base/i_listenable_node.dart';
import 'package:animated_tree_view/src/listenable_node/listenable_indexed_node.dart';
import 'package:animated_tree_view/src/listenable_node/listenable_node.dart';
import 'package:animated_tree_view/src/node/base/i_node.dart';
import 'package:animated_tree_view/src/node/indexed_node.dart';
import 'package:animated_tree_view/src/node/node.dart';
import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class TreeListViewController<T extends Node<T>>
    extends ITreeListViewController<T> {
  TreeListViewController(
      {ListenableNode<T>? initialItem, AutoScrollController? scrollController})
      : super(
            root: initialItem ?? ListenableNode<T>.root(),
            scrollController: scrollController);

  ListenableNode<T> elementAt(String path) =>
      super.elementAt(path) as ListenableNode<T>;

  ListenableNode<T> get root => super.root as ListenableNode<T>;
}

class IndexedTreeListViewController<T extends IndexedNode<T>>
    extends ITreeListViewController<T> {
  IndexedTreeListViewController(
      {ListenableIndexedNode<T>? initialItems,
      AutoScrollController? scrollController})
      : super(
            root: initialItems ?? ListenableIndexedNode<T>.root(),
            scrollController: scrollController);

  ListenableIndexedNode<T> elementAt(String path) =>
      super.elementAt(path) as ListenableIndexedNode<T>;

  ListenableIndexedNode<T> get root => super.root as ListenableIndexedNode<T>;
}

abstract class ITreeListViewController<T extends INode<T>> {
  late final AnimatedListController<T> animatedListController;

  final IListenableNode<T> root;
  final AutoScrollController scrollController;

  ITreeListViewController(
      {required this.root, AutoScrollController? scrollController})
      : this.scrollController =
            scrollController ?? AutoScrollController(axis: Axis.vertical);

  void attach(AnimatedListController<T> animatedListController) {
    this.animatedListController = animatedListController;
  }

  INode<T> elementAt(String path) => root.elementAt(path);

  Future scrollToIndex(int index) async =>
      animatedListController.scrollToIndex(index);

  Future scrollToItem(T item) async =>
      animatedListController.scrollToItem(item);

  void toggleNodeExpandCollapse(T item) =>
      animatedListController.toggleExpansion(item);

  void dispose() {
    animatedListController.dispose();
  }
}
