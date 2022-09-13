import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:animated_tree_view/src/controllers/animated_list_controller.dart';
import 'package:flutter/material.dart';

const DEFAULT_INDENT_PADDING = 24.0;

extension ExpandableNode on INode {
  static const _isExpandedKey = "is_expanded";

  bool get isExpanded => meta?[_isExpandedKey] == true;

  void setExpanded(bool isExpanded) {
    (meta ??= {})[_isExpandedKey] = isExpanded;
  }
}

class ExpandableNodeItem<T extends INode<T>> extends StatelessWidget {
  final LeveledItemWidgetBuilder<T> builder;
  final AnimatedListController<T> animatedListController;
  final AutoScrollController scrollController;
  final T node;
  final Animation<double> animation;
  final double indentPadding;
  final ExpansionIndicator? expansionIndicator;
  final bool remove;
  final int? index;
  final ValueSetter<T>? onItemTap;
  final int minLevelToIndent;

  const ExpandableNodeItem({
    Key? key,
    required this.builder,
    required this.animatedListController,
    required this.scrollController,
    required this.node,
    required this.animation,
    this.index,
    this.remove = false,
    this.minLevelToIndent = 0,
    this.expansionIndicator,
    this.onItemTap,
    double? indentPadding,
  })  : this.indentPadding = indentPadding ?? DEFAULT_INDENT_PADDING,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final itemContainer = _ExpandableNodeContainer(
      animation: animation,
      item: node,
      child: builder(context, node.level, node),
      indentPadding: indentPadding *
          (node.level - minLevelToIndent).clamp(0, double.maxFinite),
      isExpanded: node.isExpanded,
      expansionIndicator:
          node.childrenAsList.isEmpty ? null : expansionIndicator,
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
  final ExpansionIndicator? expansionIndicator;
  final double indentPadding;
  final Widget child;
  final bool isExpanded;

  const _ExpandableNodeContainer({
    Key? key,
    required this.animation,
    required this.onTap,
    required this.child,
    required this.item,
    required this.indentPadding,
    required this.isExpanded,
    this.expansionIndicator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      axis: Axis.vertical,
      sizeFactor: CurvedAnimation(parent: animation, curve: Curves.easeOut),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onTap == null ? null : () => onTap!(item),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: indentPadding),
              child: child,
            ),
            if (expansionIndicator != null)
              Padding(
                padding: expansionIndicator!.padding,
                child: Align(
                  alignment: expansionIndicator!.alignment,
                  child: isExpanded
                      ? expansionIndicator!.collapseIcon
                      : expansionIndicator!.expandIcon,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
