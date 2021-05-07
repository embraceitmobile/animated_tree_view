import 'package:tree_structure_view/controllers/animated_list_controller.dart';
import 'package:tree_structure_view/node/map_node.dart';
import 'package:tree_structure_view/node/node.dart';
import 'package:tree_structure_view/tree/base/i_tree.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

abstract class ITreeListViewController<T extends Node<T>> {
  void attach(
      {required covariant ITree<T> tree,
      required AnimatedListController listController,
      required AutoScrollController scrollController});

  void scrollToItem(T item);

  void scrollToIndex(int index);

  void toggleNodeExpandCollapse(T item);
}
