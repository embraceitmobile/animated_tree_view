library multi_level_list_view;

import 'package:flutter/material.dart';
import 'package:multi_level_list_view/controllers/animated_list_controller.dart';
import 'package:multi_level_list_view/widgets/list_item_container.dart';
import 'models/entry.dart';

export 'models/entry.dart';

typedef MultiLevelIndexBuilder<T> = Widget Function(
    BuildContext context, int level, T item);

const TAG = "MultiLevelListView";

class MultiLevelListView<T extends Entry> extends StatefulWidget {
  final List<T> list;
  final MultiLevelIndexBuilder builder;
  final bool showExpansionIndicator;
  final Icon expandIcon;
  final Icon collapseIcon;
  final double indentPadding;
  final VoidCallback onTap;

  const MultiLevelListView({
    Key key,
    @required this.list,
    @required this.builder,
    this.showExpansionIndicator = true,
    this.indentPadding = 24.0,
    this.expandIcon = const Icon(Icons.keyboard_arrow_down),
    this.collapseIcon = const Icon(Icons.keyboard_arrow_up),
    this.onTap,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiLevelListView();
}

class _MultiLevelListView<T extends Entry>
    extends State<MultiLevelListView<T>> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  AnimatedListController<T> _animatedListController;

  @override
  void initState() {
    super.initState();
    _animatedListController = AnimatedListController(
      listKey: _listKey,
      initialItems: widget.list,
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

  // Used to build list items that haven't been removed.
  Widget _buildItem(T item, Animation<double> animation,
      {bool remove = false}) {
    final level = '.'.allMatches(item.id).length;
    return ListItemContainer(
      animation: animation,
      item:item,
      child: widget.builder(context, level, item),
      indentPadding: widget.indentPadding * level,
      showExpansionIndicator:
          widget.showExpansionIndicator && item.children.isNotEmpty,
      expandedIndicatorIcon: _animatedListController.isExpanded(item.id)
          ? widget.collapseIcon
          : widget.expandIcon,
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
