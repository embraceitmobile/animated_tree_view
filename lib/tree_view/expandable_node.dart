import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:flutter/material.dart';

const DEFAULT_INDENT_PADDING = 24.0;

class ExpandableNodeItem<Data, Tree extends ITreeNode<Data>>
    extends StatelessWidget {
  final TreeNodeWidgetBuilder<Tree> builder;
  final AutoScrollController scrollController;
  final Tree node;
  final Animation<double> animation;
  final double indentPadding;
  final ExpansionIndicatorBuilder<Data>? expansionIndicatorBuilder;
  final bool remove;
  final int? index;
  final ValueSetter<Tree>? onItemTap;
  final ValueSetter<Tree> onToggleExpansion;
  final int minLevelToIndent;

  static Widget insertedNode<Data, Tree extends ITreeNode<Data>>({
    required int index,
    required Tree node,
    required TreeNodeWidgetBuilder<Tree> builder,
    required AutoScrollController scrollController,
    required Animation<double> animation,
    required double? indentPadding,
    required ExpansionIndicatorBuilder<Data>? expansionIndicator,
    required ValueSetter<Tree>? onItemTap,
    required ValueSetter<Tree> onToggleExpansion,
    required bool showRootNode,
  }) {
    return ValueListenableBuilder<INode>(
      valueListenable: node,
      builder: (context, treeNode, _) => ValueListenableBuilder(
        valueListenable: (treeNode as Tree).listenableData,
        builder: (context, data, _) => ExpandableNodeItem<Data, Tree>(
          builder: builder,
          scrollController: scrollController,
          node: node,
          index: index,
          animation: animation,
          indentPadding: indentPadding,
          expansionIndicatorBuilder: expansionIndicator,
          onToggleExpansion: onToggleExpansion,
          onItemTap: onItemTap,
          minLevelToIndent: showRootNode ? 0 : 1,
        ),
      ),
    );
  }

  static Widget removedNode<Data, Tree extends ITreeNode<Data>>({
    required Tree node,
    required TreeNodeWidgetBuilder<Tree> builder,
    required AutoScrollController scrollController,
    required Animation<double> animation,
    required double? indentPadding,
    required ExpansionIndicatorBuilder<Data>? expansionIndicator,
    required ValueSetter<Tree>? onItemTap,
    required ValueSetter<Tree> onToggleExpansion,
    required bool showRootNode,
  }) {
    return ExpandableNodeItem<Data, Tree>(
      builder: builder,
      scrollController: scrollController,
      node: node,
      remove: true,
      animation: animation,
      indentPadding: indentPadding,
      expansionIndicatorBuilder: expansionIndicator,
      onItemTap: onItemTap,
      onToggleExpansion: onToggleExpansion,
      minLevelToIndent: showRootNode ? 0 : 1,
    );
  }

  const ExpandableNodeItem({
    super.key,
    required this.builder,
    required this.scrollController,
    required this.node,
    required this.animation,
    required this.onToggleExpansion,
    this.index,
    this.remove = false,
    this.minLevelToIndent = 0,
    this.expansionIndicatorBuilder,
    this.onItemTap,
    double? indentPadding,
  }) : this.indentPadding = indentPadding ?? DEFAULT_INDENT_PADDING;

  @override
  Widget build(BuildContext context) {
    final itemContainer = _ExpandableNodeContainer(
      animation: animation,
      item: node,
      child: builder(context, node),
      indentPadding: indentPadding *
          (node.level - minLevelToIndent).clamp(0, double.maxFinite),
      expansionIndicator: node.childrenAsList.isEmpty
          ? null
          : expansionIndicatorBuilder?.call(context, node),
      onTap: remove
          ? null
          : (dynamic item) {
              onToggleExpansion(item);
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

class _ExpandableNodeContainer<T> extends StatelessWidget {
  final Animation<double> animation;
  final ValueSetter<ITreeNode<T>>? onTap;
  final ITreeNode<T> item;
  final ExpansionIndicator? expansionIndicator;
  final double indentPadding;
  final Widget child;

  const _ExpandableNodeContainer({
    super.key,
    required this.animation,
    required this.onTap,
    required this.child,
    required this.item,
    required this.indentPadding,
    this.expansionIndicator,
  });

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      axis: Axis.vertical,
      sizeFactor: CurvedAnimation(parent: animation, curve: Curves.easeOut),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onTap == null ? null : () => onTap!(item),
        child: Padding(
          padding: EdgeInsets.only(left: indentPadding),
          child: Stack(
            children: <Widget>[
              child,
              if (expansionIndicator != null)
                Positioned(
                  left: expansionIndicator!.alignment.x <= 0 ? 0 : null,
                  right: expansionIndicator!.alignment.x >= 0 ? 0 : null,
                  top: expansionIndicator!.alignment.y <= 0 ? 0 : null,
                  bottom: expansionIndicator!.alignment.y >= 0 ? 0 : null,
                  child: Padding(
                    padding: expansionIndicator!.padding,
                    child: expansionIndicator!,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
