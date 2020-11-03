library multi_level_list_view;

import 'package:flutter/material.dart';
import 'package:multi_level_list_view/controllers/animated_list_controller.dart';
import 'package:multi_level_list_view/iterable_tree/listenable_iterable_tree.dart';
import 'package:multi_level_list_view/collections/node_collections.dart';
import 'package:multi_level_list_view/tree_list/listenable_tree_list.dart';
import 'package:multi_level_list_view/widgets/list_item_container.dart';

export 'package:multi_level_list_view/tree_list/tree_list.dart';
export 'package:multi_level_list_view/collections/node_collections.dart';

typedef LeveledIndexedWidgetBuilder<T> = Widget Function(
    BuildContext context, int level, T item);

const TAG = "MultiLevelListView";
const DEFAULT_INDENT_PADDING = 24.0;
const DEFAULT_EXPAND_ICON = const Icon(Icons.keyboard_arrow_down);
const DEFAULT_COLLAPSE_ICON = const Icon(Icons.keyboard_arrow_up);
const DEFAULT_SHOW_EXPANSION_INDICATOR = true;

class MultiLevelListView<T extends Node<T>> extends StatefulWidget {
  final ListenableIterableTree<T> listenableTree;
  final LeveledIndexedWidgetBuilder builder;
  final bool showExpansionIndicator;
  final Icon expandIcon;
  final Icon collapseIcon;
  final double indentPadding;
  final VoidCallback onTap;

  const MultiLevelListView._({
    Key key,
    @required this.builder,
    this.listenableTree,
    this.onTap,
    this.showExpansionIndicator,
    this.indentPadding,
    this.expandIcon,
    this.collapseIcon,
  }) : super(key: key);

  factory MultiLevelListView({
    Key key,
    @required LeveledIndexedWidgetBuilder builder,
    List<T> initialItems,
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

  @override
  void initState() {
    super.initState();
    _animatedListController = AnimatedListController(
      listKey: _listKey,
      tree: widget.listenableTree,
      removedItemBuilder: _buildRemovedItem,
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = _animatedListController.list;
    if (list.isEmpty) return SizedBox.shrink();

    return AnimatedList(
      key: _listKey,
      initialItemCount: list.length,
      itemBuilder: (context, index, animation) =>
          _buildItem(list[index], animation),
    );
  }

  /// Used to build list items that haven't been removed.
  Widget _buildItem(T item, Animation<double> animation,
      {bool remove = false}) {
    return ListItemContainer(
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
  }

  Widget _buildRemovedItem(
          T item, BuildContext context, Animation<double> animation) =>
      _buildItem(item, animation, remove: true);
}
