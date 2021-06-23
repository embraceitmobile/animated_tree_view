import 'package:flutter/cupertino.dart';
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
class TreeListView<T extends IListenableNode<T>> extends StatefulWidget {
  final ITreeListViewController<T>? controller;
  final LeveledItemWidgetBuilder<T> builder;
  final IListenableNode<T> root;
  final AutoScrollController? scrollController;
  final bool showExpansionIndicator;
  final Icon expandIcon;
  final Icon collapseIcon;
  final double indentPadding;
  final bool shrinkWrap;
  final bool showRootNode;
  final EdgeInsetsGeometry? padding;
  final ValueSetter<T>? onItemTap;
  final bool? primary;
  final ScrollPhysics? physics;

  static TreeListView<S> simple<S extends ListenableNode<S>>({
    Key? key,
    required LeveledItemWidgetBuilder<S> builder,
    TreeListViewController<S>? controller,
    ListenableNode<S>? initialItem,
    AutoScrollController? scrollController,
    bool? showExpansionIndicator,
    Icon? expandIcon,
    Icon? collapseIcon,
    double? indentPadding,
    ValueSetter<S>? onItemTap,
    bool? primary,
    ScrollPhysics? physics,
    bool? shrinkWrap,
    EdgeInsetsGeometry? padding,
    bool? showRootNode,
  }) =>
      TreeListView<S>._(
        key: key,
        builder: builder,
        root: initialItem ?? ListenableNode<S>.root(),
        controller: controller,
        scrollController: scrollController,
        showExpansionIndicator: showExpansionIndicator,
        expandIcon: expandIcon,
        collapseIcon: collapseIcon,
        indentPadding: indentPadding,
        showRootNode: showRootNode,
        shrinkWrap: shrinkWrap,
        onItemTap: onItemTap,
        primary: primary,
        physics: physics,
        padding: padding,
      );

  static TreeListView<S> indexed<S extends ListenableIndexedNode<S>>({
    Key? key,
    required LeveledItemWidgetBuilder<S> builder,
    IndexedTreeListViewController<S>? controller,
    ListenableIndexedNode<S>? initialItem,
    AutoScrollController? scrollController,
    bool? showExpansionIndicator,
    Icon? expandIcon,
    Icon? collapseIcon,
    double? indentPadding,
    ValueSetter<S>? onItemTap,
    bool? primary,
    ScrollPhysics? physics,
    bool? shrinkWrap,
    EdgeInsetsGeometry? padding,
    bool? showRootNode,
  }) =>
      TreeListView<S>._(
        key: key,
        builder: builder,
        root: initialItem ?? ListenableIndexedNode<S>.root(),
        controller: controller,
        scrollController: scrollController,
        showExpansionIndicator: showExpansionIndicator,
        expandIcon: expandIcon,
        collapseIcon: collapseIcon,
        indentPadding: indentPadding,
        showRootNode: showRootNode,
        shrinkWrap: shrinkWrap,
        onItemTap: onItemTap,
        primary: primary,
        physics: physics,
        padding: padding,
      );

  const TreeListView._({
    Key? key,
    required this.builder,
    required this.root,
    this.scrollController,
    this.controller,
    this.onItemTap,
    this.primary,
    this.physics,
    this.padding,
    bool? shrinkWrap,
    bool? showRootNode,
    bool? showExpansionIndicator,
    double? indentPadding,
    Icon? collapseIcon,
    Icon? expandIcon,
  })  : this.shrinkWrap = shrinkWrap ?? false,
        this.showRootNode = showRootNode ?? true,
        this.showExpansionIndicator = showExpansionIndicator ?? true,
        this.expandIcon = expandIcon ?? DEFAULT_EXPAND_ICON,
        this.collapseIcon = collapseIcon ?? DEFAULT_COLLAPSE_ICON,
        this.indentPadding = indentPadding ?? DEFAULT_INDENT_PADDING,
        super(key: key);

  @override
  State<StatefulWidget> createState() => _TreeListViewState<T>();
}

class _TreeListViewState<T extends IListenableNode<T>>
    extends State<TreeListView<T>> {
  static const TAG = "TreeListView";

  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  late final AnimatedListController<T> _animatedListController;
  late final AutoScrollController _scrollController;

  List<T> get _nodeList => _animatedListController.list;

  @override
  void initState() {
    super.initState();

    _scrollController =
        widget.scrollController ?? AutoScrollController(axis: Axis.vertical);

    _animatedListController = AnimatedListController<T>(
      listKey: listKey,
      listenableNode: widget.root,
      removedItemBuilder: buildRemovedItem,
      showRootNode: widget.showRootNode,
      scrollController: _scrollController,
    );

    widget.controller?.attach(widget.root, _animatedListController);
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
