import 'package:animated_tree_view/src/controllers/animated_list_controller.dart';
import 'package:animated_tree_view/src/listenable_node/base/i_listenable_node.dart';
import 'package:animated_tree_view/src/listenable_node/listenable_indexed_node.dart';
import 'package:animated_tree_view/src/listenable_node/listenable_node.dart';
import 'package:animated_tree_view/src/node/base/i_node.dart';
import 'package:animated_tree_view/src/node/indexed_node.dart';
import 'package:animated_tree_view/src/node/node.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class TreeListViewController<T extends Node<T>>
    extends ITreeListViewController<T> {
  TreeListViewController({ListenableNode<T>? initialItem})
      : super(initialItem ?? ListenableNode<T>.root());

  ListenableNode<T> elementAt(String path) =>
      super.elementAt(path) as ListenableNode<T>;

  ListenableNode<T> get root => super.root as ListenableNode<T>;
}

class IndexedTreeListViewController<T extends IndexedNode<T>>
    extends ITreeListViewController<T> {
  IndexedTreeListViewController({ListenableIndexedNode<T>? initialItems})
      : super(initialItems ?? ListenableIndexedNode<T>.root());

  ListenableIndexedNode<T> elementAt(String path) =>
      super.elementAt(path) as ListenableIndexedNode<T>;

  ListenableIndexedNode<T> get root => super.root as ListenableIndexedNode<T>;
}

abstract class ITreeListViewController<T extends INode<T>> {
  late final AnimatedListController<T> animatedListController;

  final IListenableNode<T> root;

  final AutoScrollController scrollController;

  ITreeListViewController(this.root)
      : this.scrollController = AutoScrollController();

  void attach(AnimatedListController<T> animatedListController) {
    this.animatedListController = animatedListController;
  }

  INode<T> elementAt(String path) => root.elementAt(path);

  void scrollToIndex(int index) => scrollController.scrollToIndex(index);

  void scrollToItem(T item) =>
      scrollController.scrollToIndex(animatedListController.indexOf(item));

  void toggleNodeExpandCollapse(T item) =>
      animatedListController.toggleExpansion(item);

  void dispose() {
    animatedListController.dispose();
  }
}
