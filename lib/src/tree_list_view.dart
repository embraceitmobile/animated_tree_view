import 'dart:async';

import 'package:flutter/material.dart';

import 'constants/constants.dart';
import 'controllers/animated_list_controller.dart';
import 'controllers/tree_list_view_controller.dart';
import 'expandable_node/expandable_node.dart';
import 'listenable_node/base/i_listenable_node.dart';
import 'listenable_node/base/node_update_notifier.dart';
import 'listenable_node/listenable_indexed_node.dart';
import 'listenable_node/listenable_node.dart';

typedef LeveledItemWidgetBuilder<T> = Widget Function(
    BuildContext context, int level, T item);

class TreeListView<T extends ListenableNode<T>> extends StatelessWidget {
  final TreeListViewController<T> controller;
  final LeveledItemWidgetBuilder<T> builder;
  final bool showExpansionIndicator;
  final Icon expandIcon;
  final Icon collapseIcon;
  final double indentPadding;
  final ValueSetter<T>? onItemTap;
  final bool? primary;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final EdgeInsetsGeometry? padding;
  final bool showRootNode;

  const TreeListView({
    Key? key,
    required this.builder,
    required this.controller,
    this.onItemTap,
    this.primary,
    this.physics,
    this.padding,
    this.shrinkWrap = false,
    this.showRootNode = true,
    this.showExpansionIndicator = true,
    this.indentPadding = DEFAULT_INDENT_PADDING,
    this.expandIcon = DEFAULT_EXPAND_ICON,
    this.collapseIcon = DEFAULT_COLLAPSE_ICON,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => _TreeListView(
        key: key,
        builder: builder,
        controller: controller,
        onItemTap: onItemTap,
        primary: primary,
        physics: physics,
        shrinkWrap: shrinkWrap,
        padding: padding,
        showRootNode: showRootNode,
        showExpansionIndicator: showExpansionIndicator,
        indentPadding: indentPadding,
        expandIcon: expandIcon,
        collapseIcon: collapseIcon,
      );
}

class IndexedTreeListView<T extends ListenableIndexedNode<T>>
    extends StatelessWidget {
  final IndexedTreeListViewController<T> controller;
  final LeveledItemWidgetBuilder<T> builder;
  final bool showExpansionIndicator;
  final Icon expandIcon;
  final Icon collapseIcon;
  final double indentPadding;
  final ValueSetter<T>? onItemTap;
  final bool? primary;
  final ScrollPhysics? physics;
  final bool showRootNode;
  final bool shrinkWrap;
  final EdgeInsetsGeometry? padding;

  const IndexedTreeListView({
    Key? key,
    required this.builder,
    required this.controller,
    this.onItemTap,
    this.primary,
    this.physics,
    this.padding,
    this.shrinkWrap = false,
    this.showRootNode = true,
    this.showExpansionIndicator = true,
    this.indentPadding = DEFAULT_INDENT_PADDING,
    this.expandIcon = DEFAULT_EXPAND_ICON,
    this.collapseIcon = DEFAULT_COLLAPSE_ICON,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => _TreeListView(
        key: key,
        builder: builder,
        controller: controller,
        onItemTap: onItemTap,
        primary: primary,
        physics: physics,
        shrinkWrap: shrinkWrap,
        padding: padding,
        showRootNode: showRootNode,
        showExpansionIndicator: showExpansionIndicator,
        indentPadding: indentPadding,
        expandIcon: expandIcon,
        collapseIcon: collapseIcon,
      );
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
class _TreeListView<T extends IListenableNode<T>> extends StatefulWidget {
  final ITreeListViewController<T> controller;
  final LeveledItemWidgetBuilder<T> builder;
  final bool showExpansionIndicator;
  final Icon expandIcon;
  final Icon collapseIcon;
  final double indentPadding;
  final ValueSetter<T>? onItemTap;
  final bool? primary;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final EdgeInsetsGeometry? padding;
  final bool showRootNode;

  const _TreeListView({
    Key? key,
    required this.builder,
    required this.controller,
    this.onItemTap,
    this.primary,
    this.physics,
    this.padding,
    this.shrinkWrap = false,
    this.showRootNode = true,
    this.showExpansionIndicator = true,
    this.indentPadding = DEFAULT_INDENT_PADDING,
    this.expandIcon = DEFAULT_EXPAND_ICON,
    this.collapseIcon = DEFAULT_COLLAPSE_ICON,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TreeListViewState<T>();
}

class _TreeListViewState<T extends IListenableNode<T>>
    extends State<_TreeListView<T>> {
  static const TAG = "TreeListView";

  StreamSubscription<NodeAddEvent>? _addedNodesSubscription;
  StreamSubscription<NodeInsertEvent>? _insertNodesSubscription;

  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();

    final animatedListController = AnimatedListController<T>(
      listKey: listKey,
      listenableNode: widget.controller.root,
      removedItemBuilder: buildRemovedItem,
      showRootNode: widget.showRootNode,
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
      shrinkWrap: widget.shrinkWrap,
      itemBuilder: (context, index, animation) => ValueListenableBuilder<T>(
        valueListenable: list[index],
        builder: (context, value, child) => ExpandableNodeItem<T>(
          builder: widget.builder,
          animatedListController: widget.controller.animatedListController,
          scrollController: widget.controller.scrollController,
          node: list[index],
          animation: animation,
          indentPadding: widget.indentPadding,
          showExpansionIndicator: widget.showExpansionIndicator,
          expandIcon: widget.expandIcon,
          collapseIcon: widget.collapseIcon,
          onItemTap: widget.onItemTap,
          indentAfterLevel: widget.showRootNode ? 0 : 1,
        ),
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
        indentAfterLevel: widget.showRootNode ? 0 : 1,
      );

  void observeTreeUpdates() {
    _addedNodesSubscription =
        widget.controller.root.addedNodes.listen(_handleItemAdditionEvent);
    _insertNodesSubscription =
        widget.controller.root.insertedNodes.listen(_handleItemInsertEvent);
  }

  void cancelTreeUpdates() {
    _addedNodesSubscription?.cancel();
    _insertNodesSubscription?.cancel();
  }

  void _handleItemAdditionEvent(NodeAddEvent<T> event) {
    Future.delayed(
      Duration(milliseconds: 300),
      () => widget.controller.scrollController.scrollToIndex(
        widget.controller.animatedListController.indexOf(event.items.first),
      ),
    );
  }

  void _handleItemInsertEvent(NodeInsertEvent<T> event) {
    Future.delayed(
      Duration(milliseconds: 300),
      () => widget.controller.scrollController.scrollToIndex(
        widget.controller.animatedListController.indexOf(event.items.first),
      ),
    );
  }

  @override
  void dispose() {
    cancelTreeUpdates();
    super.dispose();
  }
}
