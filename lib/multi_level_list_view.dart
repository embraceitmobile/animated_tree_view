library multi_level_list_view;

import 'package:flutter/material.dart';
import 'package:multi_level_list_view/controllers/animated_list_controller.dart';
import 'package:multi_level_list_view/controllers/multilevel_listview_controller.dart';
import 'package:multi_level_list_view/widgets/list_item_container.dart';
import 'models/entry.dart';

export 'models/entry.dart';

typedef LeveledIndexedWidgetBuilder<T> = Widget Function(
    BuildContext context, int level, T item);

const TAG = "MultiLevelListView";

class MultiLevelListView<T extends Entry<T>> extends StatefulWidget {
  final List<T> _items;
  final LeveledIndexedWidgetBuilder builder;
  final bool showExpansionIndicator;
  final Icon expandIcon;
  final Icon collapseIcon;
  final double indentPadding;
  final VoidCallback onTap;
  final MultiLevelListViewController controller;

  const MultiLevelListView({
    Key key,
    @required this.builder,
    List<T> initialItems,
    this.controller,
    this.onTap,
    this.showExpansionIndicator = true,
    this.indentPadding = 24.0,
    this.expandIcon = const Icon(Icons.keyboard_arrow_down),
    this.collapseIcon = const Icon(Icons.keyboard_arrow_up),
  })  : this._items = initialItems ?? const [],
        super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiLevelListView<T>();
}

class _MultiLevelListView<T extends Entry<T>>
    extends State<MultiLevelListView<T>> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  AnimatedListController<T> _animatedListController;

  @override
  void initState() {
    super.initState();
    _animatedListController = AnimatedListController(
      listKey: _listKey,
      initialItems: widget._items,
      listViewController: widget.controller,
      removedItemBuilder: _buildRemovedItem,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<T>>(
      valueListenable: _animatedListController.list,
      builder: (context, list, child) {
        if (list.isEmpty) return SizedBox.shrink();
        return AnimatedList(
          key: _listKey,
          initialItemCount: list.length,
          itemBuilder: (context, index, animation) =>
              _buildItem(list[index], animation),
        );
      },
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
