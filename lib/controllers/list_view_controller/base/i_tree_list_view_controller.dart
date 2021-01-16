import 'package:multi_level_list_view/controllers/animated_list_controller.dart';
import 'package:multi_level_list_view/node/map_node.dart';
import 'package:multi_level_list_view/node/node.dart';
import 'package:multi_level_list_view/tree/base/i_tree.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

abstract class ITreeListViewController<T extends Node<T>> {
  void attach(
      {covariant ITree<T> tree,
      AnimatedListController listController,
      AutoScrollController scrollController});

  void scrollToItem(T item);

  void scrollToIndex(int index);

  void toggleNodeExpandCollapse(T item);
}
