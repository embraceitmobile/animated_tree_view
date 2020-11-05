library multi_level_list_view;

import 'package:flutter/material.dart';
import 'package:multi_level_list_view/controllers/animated_list_controller.dart';
import 'package:multi_level_list_view/controllers/multilevel_list_view_controller.dart';
import 'package:multi_level_list_view/interfaces/iterable_tree_update_provider.dart';
import 'package:multi_level_list_view/interfaces/listenable_iterable_tree.dart';
import 'package:multi_level_list_view/tree_structures/node.dart';
import 'package:multi_level_list_view/tree_structures/tree_list/listenable_tree_list.dart';
import 'package:multi_level_list_view/tree_structures/tree_list/tree_list.dart';
import 'package:multi_level_list_view/widgets/list_item_container.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

export 'package:multi_level_list_view/tree_structures/tree_list/tree_list.dart';
export 'package:multi_level_list_view/tree_structures/node.dart';
export 'package:multi_level_list_view/controllers/multilevel_list_view_controller.dart';

typedef LeveledIndexedWidgetBuilder<T> = Widget Function(
    BuildContext context, int level, T item);

const TAG = "MultiLevelListView";
const DEFAULT_INDENT_PADDING = 24.0;
const DEFAULT_EXPAND_ICON = const Icon(Icons.keyboard_arrow_down);
const DEFAULT_COLLAPSE_ICON = const Icon(Icons.keyboard_arrow_up);
const DEFAULT_SHOW_EXPANSION_INDICATOR = true;

class MultiLevelListView<T extends Node<T>> extends StatefulWidget {
  final ListenableIterableTree<T> listenableTree;
  final LeveledIndexedWidgetBuilder<T> builder;
  final MultiLevelListViewController<T> controller;
  final bool showExpansionIndicator;
  final Icon expandIcon;
  final Icon collapseIcon;
  final double indentPadding;
  final VoidCallback onTap;

  const MultiLevelListView._({
    Key key,
    @required this.builder,
    this.listenableTree,
    this.controller,
    this.onTap,
    this.showExpansionIndicator,
    this.indentPadding,
    this.expandIcon,
    this.collapseIcon,
  }) : super(key: key);

  /// The default [MultiLevelListView] uses a TreeMap structure internally for
  /// handling the nodes. The TreeMap does not allow insertion and removal of
  /// items at index positions. This allows for more efficient insertion and
  /// retrieval of items at child nodes, as child items can be readily accessed
  /// using the map keys.
  ///
  /// The complexity for accessing child nodes in [MultiLevelListView] is simply O(node_level).
  /// e.g. for path './.level1/level2', complexity is simply O(2).
  ///
  /// For a [MultiLevelListView] that allows for insertion and removal of
  /// items at index positions, use the alternate [MultiLevelListView.insertable]
  factory MultiLevelListView({
    Key key,
    @required LeveledIndexedWidgetBuilder<T> builder,
    List<T> initialItems,
    EfficientMultiLevelListViewController<T> controller,
    VoidCallback onTap,
    bool showExpansionIndicator,
    double indentPadding,
    Icon expandIcon,
    Icon collapseIcon,
  }) =>
      MultiLevelListView._(
        key: key,
        builder: builder,
        listenableTree: ListenableTreeList.from(initialItems ?? <T>[]),
        controller: controller,
        onTap: onTap,
        showExpansionIndicator:
            showExpansionIndicator ?? DEFAULT_SHOW_EXPANSION_INDICATOR,
        indentPadding: indentPadding ?? DEFAULT_INDENT_PADDING,
        expandIcon: expandIcon ?? DEFAULT_EXPAND_ICON,
        collapseIcon: collapseIcon ?? DEFAULT_COLLAPSE_ICON,
      );

  /// The [MultiLevelListView.insertable] uses a [TreeList] structure internally
  /// for handling nodes. Using a [List] structure allows for insertion and
  /// removal of items in child nodes. However, this makes the node access
  /// operation less efficient as the children need to be iterated for each
  /// node level.
  ///
  /// The complexity for accessing nodes for [MultiLevelListView.insertable] is
  /// O(n^m), where n is the number of children in a node, and m is the node level.
  ///
  /// If you do not have a requirement for insertion and removal of items in a
  /// node, use the more efficient [MultiLevelListView] instead.
  factory MultiLevelListView.insertable({
    Key key,
    @required LeveledIndexedWidgetBuilder<T> builder,
    List<T> initialItems,
    InsertableMultiLevelListViewController<T> controller,
    VoidCallback onTap,
    bool showExpansionIndicator,
    double indentPadding,
    Icon expandIcon,
    Icon collapseIcon,
  }) =>
      MultiLevelListView._(
        key: key,
        builder: builder,
        listenableTree: ListenableTreeList.from(initialItems ?? <T>[]),
        controller: controller,
        onTap: onTap,
        showExpansionIndicator:
            showExpansionIndicator ?? DEFAULT_SHOW_EXPANSION_INDICATOR,
        indentPadding: indentPadding ?? DEFAULT_INDENT_PADDING,
        expandIcon: expandIcon ?? DEFAULT_EXPAND_ICON,
        collapseIcon: collapseIcon ?? DEFAULT_COLLAPSE_ICON,
      );

  @override
  State<StatefulWidget> createState() => _MultiLevelListView<T>();
}

class _MultiLevelListView<T extends Node<T>>
    extends State<MultiLevelListView<T>> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  AnimatedListController<T> _animatedListController;
  AutoScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null)
      widget.controller.attachTree(widget.listenableTree);

    _scrollController = AutoScrollController();
    _animatedListController = AnimatedListController(
      listKey: _listKey,
      tree: widget.listenableTree,
      removedItemBuilder: _buildRemovedItem,
    );

    widget.listenableTree.addedItems.listen(_handleItemAdditionEvent);
    widget.listenableTree.insertedItems.listen(_handleItemAdditionEvent);
  }

  @override
  Widget build(BuildContext context) {
    final list = _animatedListController.list;
    if (list.isEmpty) return SizedBox.shrink();

    return AnimatedList(
      key: _listKey,
      initialItemCount: list.length,
      controller: _scrollController,
      itemBuilder: (context, index, animation) =>
          _buildItem(list[index], animation, index: index),
    );
  }

  /// Used to build list items that haven't been removed.
  Widget _buildItem(Node<T> item, Animation<double> animation,
      {bool remove = false, int index}) {
    final itemContainer = ListItemContainer(
      animation: animation,
      item: item,
      child: widget.builder(context, item.level, item),
      indentPadding: widget.indentPadding * item.level,
      showExpansionIndicator:
          widget.showExpansionIndicator && item.children.isNotEmpty,
      expandedIndicatorIcon:
          item.isExpanded ? widget.collapseIcon : widget.expandIcon,
      onTap: remove
          ? null
          : (item) {
              _animatedListController.toggleExpansion(item);
              if (widget.onTap != null) widget.onTap();
            },
    );

    if (index == null) return itemContainer;

    return AutoScrollTag(
      key: ValueKey(item.key),
      controller: _scrollController,
      index: index,
      child: itemContainer,
    );
  }

  Widget _buildRemovedItem(
          T item, BuildContext context, Animation<double> animation) =>
      _buildItem(item, animation, remove: true);

  void _handleItemAdditionEvent(NodeEvent<T> event) {
    Future.delayed(
        Duration(milliseconds: 300),
        () => _scrollController
            .scrollToIndex(_animatedListController.indexOf(event.items.first)));
  }
}
