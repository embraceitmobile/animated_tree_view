import 'package:animated_tree_view/src/controllers/animated_list_controller.dart';
import 'package:animated_tree_view/src/listenable_node/base/i_listenable_node.dart';
import 'package:animated_tree_view/src/listenable_node/listenable_indexed_node.dart';
import 'package:animated_tree_view/src/listenable_node/listenable_node.dart';
import 'package:animated_tree_view/src/node/base/i_node.dart';
import 'package:animated_tree_view/src/node/indexed_node.dart';
import 'package:animated_tree_view/src/node/node.dart';

class TreeListViewController<T extends Node<T>>
    extends ITreeListViewController<T> {
  TreeListViewController();

  ListenableNode<T> elementAt(String path) =>
      super.elementAt(path) as ListenableNode<T>;

  ListenableNode<T> get root => super.root as ListenableNode<T>;
}

class IndexedTreeListViewController<T extends IndexedNode<T>>
    extends ITreeListViewController<T> {
  IndexedTreeListViewController();

  ListenableIndexedNode<T> elementAt(String path) =>
      super.elementAt(path) as ListenableIndexedNode<T>;

  ListenableIndexedNode<T> get root => super.root as ListenableIndexedNode<T>;
}

abstract class ITreeListViewController<T extends INode<T>> {
  late final AnimatedListController<T> animatedListController;
  late final IListenableNode<T> root;

  ITreeListViewController();

  void attach(IListenableNode<T> root,
      AnimatedListController<T> animatedListController) {
    this.root = root;
    this.animatedListController = animatedListController;
  }

  INode<T> elementAt(String path) => root.elementAt(path);

  Future scrollToIndex(int index) async =>
      animatedListController.scrollToIndex(index);

  Future scrollToItem(T item) async =>
      animatedListController.scrollToItem(item);

  void toggleNodeExpandCollapse(T item) =>
      animatedListController.toggleExpansion(item);
}
