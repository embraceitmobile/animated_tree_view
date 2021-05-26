import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:animated_tree_view/src/constants/constants.dart';
import 'package:animated_tree_view/src/controllers/animated_list_controller.dart';
import 'package:animated_tree_view/src/node/base/i_node.dart';
import 'package:animated_tree_view/src/tree_list_view.dart';
import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

extension ExpandableNode on INode {
  static const _isExpandedKey = "is_expanded";

  bool get isExpanded => meta?[_isExpandedKey] == true;

  void setExpanded(bool isExpanded) {
    if (meta == null) meta = {};
    meta![_isExpandedKey] = isExpanded;
  }
}

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
    final itemContainer = _ExpandableNodeContainer(
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

class _ExpandableNodeContainer<T extends INode<T>> extends StatelessWidget {
  final Animation<double> animation;
  final ValueSetter<T>? onTap;
  final T item;
  final bool showExpansionIndicator;
  final Icon expandedIndicatorIcon;
  final double indentPadding;
  final Widget child;

  const _ExpandableNodeContainer({
    Key? key,
    required this.animation,
    required this.onTap,
    required this.child,
    required this.item,
    required this.expandedIndicatorIcon,
    required this.indentPadding,
    required this.showExpansionIndicator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      axis: Axis.vertical,
      sizeFactor: CurvedAnimation(parent: animation, curve: Curves.easeOut),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => onTap!(item),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: indentPadding),
              child: child,
            ),
            if (showExpansionIndicator)
              Align(
                alignment: Alignment.topRight,
                child: expandedIndicatorIcon,
              ),
          ],
        ),
      ),
    );
  }
}
