import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:animated_tree_view/src/expandable_node/expansion_indicator.dart';
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

enum ExpansionBehavior { none, scrollToLastChild, snapToParent }

/// The default [TreeView] uses a [Node] internally, which is based on the
/// [Map] data structure for maintaining the children states.
/// The [Node] does not allow insertion and removal of
/// items at index positions. This allows for more efficient insertion and
/// retrieval of items at child nodes, as child items can be readily accessed
/// using the map keys.
///
/// The complexity for accessing child nodes in [TreeView] is simply O(node_level).
/// e.g. for path './.level1/level2', complexity is simply O(2).
///
/// For a [TreeView] that allows for insertion and removal of
/// items at index positions, use the alternate [IndexedTreeListView].
///
class TreeView<T extends ListenableNode<T>> extends StatelessWidget {
  final LeveledItemWidgetBuilder<T> builder;
  final TreeListViewController<T>? controller;
  final ListenableNode<T>? initialItem;
  final AutoScrollController? scrollController;
  final ExpansionIndicator? expansionIndicator;
  final double? indentPadding;
  final ValueSetter<T>? onItemTap;
  final bool? primary;
  final ScrollPhysics? physics;
  final bool? shrinkWrap;
  final EdgeInsetsGeometry? padding;
  final bool? showRootNode;
  final ExpansionBehavior expansionBehavior;

  const TreeView({
    Key? key,
    required this.builder,
    this.expansionIndicator = ExpansionIndicator.RightUpChevron,
    this.expansionBehavior = ExpansionBehavior.scrollToLastChild,
    this.controller,
    this.initialItem,
    this.scrollController,
    this.indentPadding,
    this.onItemTap,
    this.primary,
    this.physics,
    this.shrinkWrap,
    this.padding,
    this.showRootNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => _TreeView<T>(
        builder: builder,
        controller: controller,
        root: initialItem ?? ListenableNode<T>.root(),
        expansionIndicator: expansionIndicator,
        expansionBehavior: expansionBehavior,
        scrollController: scrollController,
        indentPadding: indentPadding,
        showRootNode: showRootNode,
        shrinkWrap: shrinkWrap,
        onItemTap: onItemTap,
        primary: primary,
        physics: physics,
        padding: padding,
      );
}

/// The alternate implementation of [_TreeView] as [IndexedTreeView] uses an
/// [IndexedNode] internally, which is based on the [List] data structure for
/// maintaining the children states.
/// The [IndexedNode] allows indexed based operations like insertion and removal of
/// items at index positions. This allows for movement, addition and removal of
/// child nodes based on indices.
///
/// The complexity for accessing child nodes in [TreeView] is simply O(node_level ^ children).
///
/// If you do not require index based operations, the more performant and efficient
/// [TreeView] instead.
///
class IndexedTreeView<T extends ListenableIndexedNode<T>>
    extends StatelessWidget {
  final LeveledItemWidgetBuilder<T> builder;
  final IndexedTreeListViewController<T>? controller;
  final ListenableIndexedNode<T>? initialItem;
  final AutoScrollController? scrollController;
  final ExpansionIndicator? expansionIndicator;
  final double? indentPadding;
  final ValueSetter<T>? onItemTap;
  final bool? primary;
  final ScrollPhysics? physics;
  final bool? shrinkWrap;
  final EdgeInsetsGeometry? padding;
  final bool? showRootNode;
  final ExpansionBehavior expansionBehavior;

  const IndexedTreeView({
    Key? key,
    required this.builder,
    this.expansionIndicator = ExpansionIndicator.RightUpChevron,
    this.expansionBehavior = ExpansionBehavior.scrollToLastChild,
    this.controller,
    this.initialItem,
    this.scrollController,
    this.indentPadding,
    this.onItemTap,
    this.primary,
    this.physics,
    this.shrinkWrap,
    this.padding,
    this.showRootNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => _TreeView<T>(
        key: key,
        builder: builder,
        controller: controller,
        root: initialItem ?? ListenableIndexedNode<T>.root(),
        expansionIndicator: expansionIndicator,
        expansionBehavior: expansionBehavior,
        scrollController: scrollController,
        indentPadding: indentPadding,
        showRootNode: showRootNode,
        shrinkWrap: shrinkWrap,
        onItemTap: onItemTap,
        primary: primary,
        physics: physics,
        padding: padding,
      );
}

class _TreeView<T extends IListenableNode<T>> extends StatefulWidget {
  final ITreeListViewController<T>? controller;
  final LeveledItemWidgetBuilder<T> builder;
  final IListenableNode<T> root;
  final AutoScrollController? scrollController;
  final ExpansionIndicator? expansionIndicator;
  final double? indentPadding;
  final bool shrinkWrap;
  final bool showRootNode;
  final EdgeInsetsGeometry? padding;
  final ValueSetter<T>? onItemTap;
  final bool? primary;
  final ScrollPhysics? physics;
  final ExpansionBehavior expansionBehavior;

  const _TreeView({
    Key? key,
    required this.builder,
    required this.root,
    required this.expansionBehavior,
    this.scrollController,
    this.controller,
    this.onItemTap,
    this.primary,
    this.physics,
    this.padding,
    this.expansionIndicator,
    this.indentPadding,
    bool? shrinkWrap,
    bool? showRootNode,
  })  : this.shrinkWrap = shrinkWrap ?? false,
        this.showRootNode = showRootNode ?? true,
        super(key: key);

  @override
  State<StatefulWidget> createState() => _TreeViewState<T>();
}

class _TreeViewState<T extends IListenableNode<T>> extends State<_TreeView<T>> {
  static const TAG = "TreeView";

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
      expansionBehavior: widget.expansionBehavior,
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
          expansionIndicator: widget.expansionIndicator,
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
        expansionIndicator: widget.expansionIndicator,
        onItemTap: widget.onItemTap,
        minLevelToIndent: widget.showRootNode ? 0 : 1,
      );
}
