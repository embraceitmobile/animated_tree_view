import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import 'controllers/animated_list_controller.dart';
import 'controllers/tree_list_view_controller.dart';
import 'expandable_node/expandable_node.dart';
import 'listenable_node/base/i_listenable_node.dart';
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
  Widget build(BuildContext context) => _TreeListView<T>(
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
  Widget build(BuildContext context) => _TreeListView<T>(
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
    required this.indentPadding,
    required this.expandIcon,
    required this.collapseIcon,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TreeListViewState<T>();
}

class _TreeListViewState<T extends IListenableNode<T>>
    extends State<_TreeListView<T>> {
  static const TAG = "TreeListView";

  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  AnimatedListController<T> get _animatedListController =>
      widget.controller.animatedListController;

  AutoScrollController get _scrollController =>
      widget.controller.animatedListController.scrollController;

  List<T> get _nodeList => widget.controller.animatedListController.list;

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
  }

  Widget build(BuildContext context) {
    return AnimatedList(
      key: listKey,
      initialItemCount: _nodeList.length,
      controller: _scrollController,
      primary: widget.primary,
      physics: widget.physics,
      padding: widget.padding,
      shrinkWrap: widget.shrinkWrap,
      itemBuilder: (context, index, animation) => ValueListenableBuilder<T>(
        valueListenable: _nodeList[index],
        builder: (context, value, child) => ExpandableNodeItem<T>(
          builder: widget.builder,
          animatedListController: _animatedListController,
          scrollController: _scrollController,
          node: _nodeList[index],
          index: index,
          animation: animation,
          indentPadding: widget.indentPadding,
          showExpansionIndicator: widget.showExpansionIndicator,
          expandIcon: widget.expandIcon,
          collapseIcon: widget.collapseIcon,
          onItemTap: widget.onItemTap,
          minLevelToIndent: widget.showRootNode ? 0 : 1,
        ),
      ),
    );
  }

  Widget buildRemovedItem(
          T item, BuildContext context, Animation<double> animation) =>
      ExpandableNodeItem<T>(
        builder: widget.builder,
        animatedListController: _animatedListController,
        scrollController: _scrollController,
        node: item,
        remove: true,
        animation: animation,
        indentPadding: widget.indentPadding,
        showExpansionIndicator: widget.showExpansionIndicator,
        expandIcon: widget.expandIcon,
        collapseIcon: widget.collapseIcon,
        onItemTap: widget.onItemTap,
        minLevelToIndent: widget.showRootNode ? 0 : 1,
      );
}
