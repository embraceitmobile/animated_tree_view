import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tree_structure_view/listenable_node/base/node_update_notifier.dart';
import 'package:tree_structure_view/node/indexed_node.dart';
import 'package:tree_structure_view/tree_list_views/controllers/animated_list_controller.dart';
import 'package:tree_structure_view/node/node.dart';
import 'package:tree_structure_view/tree_list_views/widgets/expandable_node_item.dart';
import 'package:tree_structure_view/tree_list_views/widgets/tree_builder_mixin.dart';

import 'base/i_tree_list_view.dart';
import 'controllers/list_view_controller/tree_list_view_controller.dart';

class TreeListView<T extends Node<T>> extends _TreeListView<T> {
  const TreeListView({
    Key? key,
    required LeveledItemWidgetBuilder<T> builder,
    required TreeListViewController<T> controller,
    ValueSetter<T>? onItemTap,
    bool? primary,
    ScrollPhysics? physics,
    bool? shrinkWrap,
    EdgeInsetsGeometry? padding,
    bool showExpansionIndicator = true,
    double indentPadding = DEFAULT_INDENT_PADDING,
    Icon expandIcon = DEFAULT_EXPAND_ICON,
    Icon collapseIcon = DEFAULT_COLLAPSE_ICON,
  }) : super(
            key: key,
            builder: builder,
            controller: controller,
            showExpansionIndicator: showExpansionIndicator,
            expandIcon: expandIcon,
            collapseIcon: collapseIcon,
            indentPadding: indentPadding,
            onItemTap: onItemTap,
            primary: primary,
            physics: physics,
            shrinkWrap: shrinkWrap,
            padding: padding);
}

class IndexedTreeListView<T extends IndexedNode<T>> extends _TreeListView<T> {
  const IndexedTreeListView({
    Key? key,
    required LeveledItemWidgetBuilder<T> builder,
    required IndexedTreeListViewController<T> controller,
    ValueSetter<T>? onItemTap,
    bool? primary,
    ScrollPhysics? physics,
    bool? shrinkWrap,
    EdgeInsetsGeometry? padding,
    bool showExpansionIndicator = true,
    double indentPadding = DEFAULT_INDENT_PADDING,
    Icon expandIcon = DEFAULT_EXPAND_ICON,
    Icon collapseIcon = DEFAULT_COLLAPSE_ICON,
  }) : super(
            key: key,
            builder: builder,
            controller: controller,
            showExpansionIndicator: showExpansionIndicator,
            expandIcon: expandIcon,
            collapseIcon: collapseIcon,
            indentPadding: indentPadding,
            onItemTap: onItemTap,
            primary: primary,
            physics: physics,
            shrinkWrap: shrinkWrap,
            padding: padding);
}

/// The default [TreeListView] uses a [Node] internally, which is based on the
/// [Map] data structure for maintaining the children states.
/// The [Node] does not allow insertion and removal of
/// items at index positions. This allows for more efficient insertion and
/// retrieval of items at child nodes, as child items can be readily accessed
/// using the map keys.
///
/// The complexity for accessing child nodes in [TreeListView] is simply O(node_level).
/// e.g. for path './.level1/level2', complexity is simply O(2).
///
/// For a [TreeListView] that allows for insertion and removal of
/// items at index positions, use the alternate [IndexedTreeListView].
///
abstract class _TreeListView<T extends INode<T>> extends StatefulWidget
    implements ITreeListView<T> {
  final ITreeListViewController<T> controller;
  final LeveledItemWidgetBuilder<T> builder;
  final bool showExpansionIndicator;
  final Icon expandIcon;
  final Icon collapseIcon;
  final double indentPadding;
  final ValueSetter<T>? onItemTap;
  final bool? primary;
  final ScrollPhysics? physics;
  final bool? shrinkWrap;
  final EdgeInsetsGeometry? padding;

  const _TreeListView({
    Key? key,
    required this.builder,
    required this.controller,
    this.onItemTap,
    this.primary,
    this.physics,
    this.shrinkWrap,
    this.padding,
    this.showExpansionIndicator = true,
    this.indentPadding = DEFAULT_INDENT_PADDING,
    this.expandIcon = DEFAULT_EXPAND_ICON,
    this.collapseIcon = DEFAULT_COLLAPSE_ICON,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TreeListViewState<T>();
}

class _TreeListViewState<T extends INode<T>> extends State<_TreeListView<T>> {
  static const TAG = "TreeListView";

  StreamSubscription<NodeAddEvent<T>>? _addedNodesSubscription;
  StreamSubscription<NodeInsertEvent<T>>? _insertNodesSubscription;

  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();

    final animatedListController = AnimatedListController<T>(
      listKey: listKey,
      listenableNode: widget.controller.listenableNode,
      removedItemBuilder: buildRemovedItem,
    );

    widget.controller.attach(animatedListController);
    observeTreeUpdates();
  }

  Widget build(BuildContext context) {
    final list = widget.controller.animatedListController.list;

    return AnimatedList(
      key: listKey,
      initialItemCount: list.length,
      controller: widget.controller.scrollController,
      primary: widget.primary,
      physics: widget.physics,
      padding: widget.padding,
      shrinkWrap: widget.shrinkWrap!,
      itemBuilder: (context, index, animation) => ExpandableNodeItem<T>(
        builder: widget.builder,
        animatedListController: widget.controller.animatedListController,
        scrollController: widget.controller.scrollController,
        node: widget.controller.animatedListController.list[index],
        animation: animation,
        indentPadding: widget.indentPadding,
        showExpansionIndicator: widget.showExpansionIndicator,
        expandIcon: widget.expandIcon,
        collapseIcon: widget.collapseIcon,
        onItemTap: widget.onItemTap,
      ),
    );
  }

  Widget buildRemovedItem(
          T item, BuildContext context, Animation<double> animation) =>
      ExpandableNodeItem<T>(
        builder: widget.builder,
        animatedListController: widget.controller.animatedListController,
        scrollController: widget.controller.scrollController,
        node: item,
        remove: true,
        animation: animation,
        indentPadding: widget.indentPadding,
        showExpansionIndicator: widget.showExpansionIndicator,
        expandIcon: widget.expandIcon,
        collapseIcon: widget.collapseIcon,
        onItemTap: widget.onItemTap,
      );

  void observeTreeUpdates() {
    _addedNodesSubscription = widget.controller.listenableNode.addedNodes
        .listen(_handleItemAdditionEvent);
    _insertNodesSubscription = widget.controller.listenableNode.insertedNodes
        .listen(_handleItemInsertEvent);
  }

  void cancelTreeUpdates() {
    _addedNodesSubscription?.cancel();
    _insertNodesSubscription?.cancel();
  }

  void _handleItemAdditionEvent(NodeAddEvent<T> event) {
    Future.delayed(
      Duration(milliseconds: 300),
      () => widget.controller.scrollController.scrollToIndex(
        widget.controller.animatedListController
            .indexOf(event.items.first as T),
      ),
    );
  }

  void _handleItemInsertEvent(NodeInsertEvent<T> event) {
    Future.delayed(
      Duration(milliseconds: 300),
      () => widget.controller.scrollController.scrollToIndex(
        widget.controller.animatedListController
            .indexOf(event.items.first as T),
      ),
    );
  }

  @override
  void dispose() {
    cancelTreeUpdates();
    super.dispose();
  }
}
