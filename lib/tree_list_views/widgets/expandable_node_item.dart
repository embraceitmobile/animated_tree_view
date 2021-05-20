import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:tree_structure_view/tree_list_views/constants/constants.dart';
import 'package:tree_structure_view/tree_list_views/controllers/animated_list_controller.dart';
import 'package:tree_structure_view/tree_list_views/models/expandable_node.dart';
import 'package:tree_structure_view/tree_list_views/widgets/expandable_node_container.dart';
import 'package:tree_structure_view/tree_structure_view.dart';

class ExpandableNodeItem<T extends INode<T>> extends StatelessWidget {
  final LeveledItemWidgetBuilder<T> builder;
  final AnimatedListController<T> animatedListController;
  final AutoScrollController scrollController;
  final T node;
  final Animation<double> animation;
  final double indentPadding;
  final bool showExpansionIndicator;
  final Icon expandIcon;
  final Icon collapseIcon;
  final bool remove;
  final int? index;
  final ValueSetter<T>? onItemTap;
  final int indentAfterLevel;

  const ExpandableNodeItem(
      {Key? key,
      required this.builder,
      required this.animatedListController,
      required this.scrollController,
      required this.node,
      required this.animation,
      this.index,
      this.indentPadding = DEFAULT_INDENT_PADDING,
      this.remove = false,
      this.showExpansionIndicator = true,
      this.expandIcon = DEFAULT_EXPAND_ICON,
      this.collapseIcon = DEFAULT_COLLAPSE_ICON,
      this.indentAfterLevel = 2,
      this.onItemTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final itemContainer = ExpandableNodeContainer(
      animation: animation,
      item: node,
      child: builder(context, node.level, node),
      indentPadding: indentPadding *
          (node.level - indentAfterLevel).clamp(0, double.maxFinite),
      showExpansionIndicator:
          showExpansionIndicator && node.childrenAsList.isNotEmpty,
      expandedIndicatorIcon: node.isExpanded ? collapseIcon : expandIcon,
      onTap: remove
          ? null
          : (dynamic item) {
              animatedListController.toggleExpansion(item);
              if (onItemTap != null) onItemTap!(item);
            },
    );

    if (index == null || remove) return itemContainer;

    return AutoScrollTag(
      key: ValueKey(node.key),
      controller: scrollController,
      index: index!,
      child: itemContainer,
    );
  }
}
