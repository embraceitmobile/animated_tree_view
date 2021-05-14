import 'dart:async';
import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:tree_structure_view/node/base/i_node.dart';
import 'package:tree_structure_view/tree/base/tree_update_notifier.dart';
import 'package:tree_structure_view/tree_list_views/base/i_tree_list_view.dart';
import 'package:tree_structure_view/tree_list_views/controllers/animated_list_controller.dart';
import 'package:tree_structure_view/tree_list_views/widgets/expandable_node_item.dart';

mixin TreeBuilderMixin<T extends INode<T>> implements ITreeListView<T> {
  AutoScrollController get scrollController;
  AnimatedListController<T> get animatedListController;
  TreeUpdateNotifier<T> get treeUpdateNotifier;
  GlobalKey<AnimatedListState> get listKey;

  StreamSubscription<NodeAddEvent<T>>? _addedNodesSubscription;
  StreamSubscription<NodeInsertEvent<T>>? _insertNodesSubscription;

  Widget build(BuildContext context) {
    final list = animatedListController.list;

    return AnimatedList(
      key: listKey,
      initialItemCount: list.length,
      controller: scrollController,
      primary: primary,
      physics: physics,
      padding: padding,
      shrinkWrap: shrinkWrap!,
      itemBuilder: (context, index, animation) => ExpandableNodeItem<T>(
        builder: builder,
        animatedListController: animatedListController,
        scrollController: scrollController,
        node: animatedListController.list[index],
        animation: animation,
        indentPadding: indentPadding,
        showExpansionIndicator: showExpansionIndicator,
        expandIcon: expandIcon,
        collapseIcon: collapseIcon,
        onItemTap: onItemTap,
      ),
    );
  }

  Widget buildRemovedItem(
          T item, BuildContext context, Animation<double> animation) =>
      ExpandableNodeItem<T>(
        builder: builder,
        animatedListController: animatedListController,
        scrollController: scrollController,
        node: item,
        remove: true,
        animation: animation,
        indentPadding: indentPadding,
        showExpansionIndicator: showExpansionIndicator,
        expandIcon: expandIcon,
        collapseIcon: collapseIcon,
        onItemTap: onItemTap,
      );

  void observeTreeUpdates() {
    _addedNodesSubscription =
        treeUpdateNotifier.addedNodes.listen(_handleItemAdditionEvent);
    _insertNodesSubscription =
        treeUpdateNotifier.insertedNodes.listen(_handleItemInsertEvent);
  }

  void cancelTreeUpdates() {
    _addedNodesSubscription?.cancel();
    _insertNodesSubscription?.cancel();
  }

  void _handleItemAdditionEvent(NodeAddEvent<T> event) {
    Future.delayed(
        Duration(milliseconds: 300),
        () => scrollController.scrollToIndex(
            animatedListController.indexOf(event.items.first as T)));
  }

  void _handleItemInsertEvent(NodeInsertEvent<T> event) {
    Future.delayed(
        Duration(milliseconds: 300),
        () => scrollController.scrollToIndex(
            animatedListController.indexOf(event.items.first as T)));
  }
}
