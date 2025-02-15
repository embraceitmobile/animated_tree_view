import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:animated_tree_view/tree_view/tree_view_state_helper.dart';
import 'package:flutter/material.dart';

class ExpandableNodeItem<Data, Tree extends ITreeNode<Data>>
    extends StatelessWidget {
  final TreeNodeWidgetBuilder<Tree> builder;
  final AutoScrollController scrollController;
  final Tree node;
  final Animation<double> animation;
  final Indentation indentation;
  final ExpansionIndicatorBuilder<Data>? expansionIndicatorBuilder;
  final bool remove;
  final int? index;
  final ValueSetter<Tree>? onItemTap;
  final ValueSetter<Tree>? onItemDoubleTap;
  final ValueSetter<Tree>? onItemSecondaryTap;
  final Function(Tree, TapDownDetails)? onItemSecondaryTapDown;
  final Function(Tree, TapUpDetails)? onItemSecondaryTapUp;
  final ValueSetter<Tree>? onItemLongPress;
  final ValueSetter<Tree> onToggleExpansion;
  final bool showRootNode;
  final LastChildCacheManager lastChildCacheManager;

  static Widget insertedNode<Data, Tree extends ITreeNode<Data>>({
    required int index,
    required Tree node,
    required TreeNodeWidgetBuilder<Tree> builder,
    required AutoScrollController scrollController,
    required Animation<double> animation,
    required ExpansionIndicatorBuilder<Data>? expansionIndicator,
    required ValueSetter<Tree>? onItemTap,
    ValueSetter<Tree>? onItemDoubleTap,
    ValueSetter<Tree>? onItemSecondaryTap,
    Function(Tree, TapDownDetails)? onItemSecondaryTapDown,
    Function(Tree, TapUpDetails)? onItemSecondaryTapUp,
    ValueSetter<Tree>? onItemLongPress,
    required ValueSetter<Tree> onToggleExpansion,
    required bool showRootNode,
    required Indentation indentation,
    required LastChildCacheManager lastChildCacheManager,
  }) {
    return ValueListenableBuilder<INode>(
      key: ValueKey(node.key + index.toString()),
      valueListenable: node,
      builder: (context, treeNode, _) => ValueListenableBuilder(
        valueListenable: (treeNode as Tree).listenableData,
        builder: (context, data, _) => ExpandableNodeItem<Data, Tree>(
          builder: builder,
          scrollController: scrollController,
          node: node,
          index: index,
          animation: animation,
          indentation: indentation,
          expansionIndicatorBuilder: expansionIndicator,
          onToggleExpansion: onToggleExpansion,
          onItemTap: onItemTap,
          onItemDoubleTap: onItemDoubleTap,
          onItemSecondaryTap: onItemSecondaryTap,
          onItemSecondaryTapDown: onItemSecondaryTapDown,
          onItemSecondaryTapUp: onItemSecondaryTapUp,
          onItemLongPress: onItemLongPress,
          showRootNode: showRootNode,
          lastChildCacheManager: lastChildCacheManager,
        ),
      ),
    );
  }

  static Widget removedNode<Data, Tree extends ITreeNode<Data>>({
    required Tree node,
    required TreeNodeWidgetBuilder<Tree> builder,
    required AutoScrollController scrollController,
    required Animation<double> animation,
    required ExpansionIndicatorBuilder<Data>? expansionIndicator,
    required ValueSetter<Tree>? onItemTap,
    ValueSetter<Tree>? onItemDoubleTap,
    ValueSetter<Tree>? onItemSecondaryTap,
    Function(Tree, TapDownDetails)? onItemSecondaryTapDown,
    Function(Tree, TapUpDetails)? onItemSecondaryTapUp,
    ValueSetter<Tree>? onItemLongPress,
    required ValueSetter<Tree> onToggleExpansion,
    required bool showRootNode,
    required Indentation indentation,
    required LastChildCacheManager lastChildCacheManager,
  }) {
    return ExpandableNodeItem<Data, Tree>(
      key: ValueKey(node.key),
      builder: builder,
      scrollController: scrollController,
      node: node,
      remove: true,
      animation: animation,
      indentation: indentation,
      expansionIndicatorBuilder: expansionIndicator,
      onItemTap: onItemTap,
      onItemDoubleTap: onItemDoubleTap,
      onItemSecondaryTap: onItemSecondaryTap,
      onItemSecondaryTapDown: onItemSecondaryTapDown,
      onItemSecondaryTapUp: onItemSecondaryTapUp,
      onItemLongPress: onItemLongPress,
      onToggleExpansion: onToggleExpansion,
      showRootNode: showRootNode,
      lastChildCacheManager: lastChildCacheManager,
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
    this.expansionIndicatorBuilder,
    this.onItemTap,
    this.onItemDoubleTap,
    this.onItemSecondaryTap,
    this.onItemSecondaryTapDown,
    this.onItemSecondaryTapUp,
    this.onItemLongPress,
    required this.showRootNode,
    required this.indentation,
    required this.lastChildCacheManager,
  });

  @override
  Widget build(BuildContext context) {
    final itemContainer = StatefulBuilder(builder: (context, setter) {
      return ExpandableNodeContainer<Tree>(
          key: ValueKey("container#$key"),
          animation: animation,
          node: node,
          child: builder(context, node),
          indentation: indentation,
          minLevelToIndent: showRootNode ? 0 : 1,
          lastChildCacheManager: lastChildCacheManager,
          expansionIndicator: node.childrenAsList.isEmpty
              ? null
              : expansionIndicatorBuilder?.call(context, node),
          onTap: remove
              ? null
              : (dynamic item) {
                  onToggleExpansion(item);
                  if (onItemTap != null) onItemTap!(item);
                },
          onDoubleTap: remove ? null : (item) => onItemDoubleTap?.call(item),
          onSecondaryTapUp: remove
              ? null
              : (item, details) => onItemSecondaryTapUp?.call(item, details),
          onSecondaryTapDown: remove
              ? null
              : (item, details) => onItemSecondaryTapDown?.call(item, details),
          onSecondaryTap:
              remove ? null : (item) => onItemSecondaryTap?.call(item),
          onLongPress: remove ? null : (item) => onItemLongPress?.call(item),
          onHover: remove
              ? null
              : (item, hovered) {
                  setter(() {
                    node.hoverNotifier.value = hovered;
                  });
                });
    });

    if (index == null || remove) return itemContainer;

    return AutoScrollTag(
      key: ValueKey("tag#${node.key}"),
      controller: scrollController,
      index: index!,
      child: itemContainer,
    );
  }
}

class ExpandableNodeContainer<Tree extends ITreeNode> extends StatelessWidget {
  final Animation<double> animation;
  final ValueSetter<Tree>? onTap;
  final ValueSetter<Tree>? onDoubleTap;
  final ValueSetter<Tree>? onSecondaryTap;
  final Function(Tree, TapDownDetails)? onSecondaryTapDown;
  final Function(Tree, TapUpDetails)? onSecondaryTapUp;
  final ValueSetter<Tree>? onLongPress;
  final Function(Tree, bool)? onHover;
  final Tree node;
  final ExpansionIndicator? expansionIndicator;
  final Indentation indentation;
  final Widget child;
  final int minLevelToIndent;
  final LastChildCacheManager lastChildCacheManager;

  const ExpandableNodeContainer({
    super.key,
    required this.animation,
    required this.onTap,
    this.onDoubleTap,
    this.onSecondaryTap,
    this.onSecondaryTapDown,
    this.onSecondaryTapUp,
    this.onLongPress,
    this.onHover,
    required this.child,
    required this.node,
    required this.indentation,
    required this.minLevelToIndent,
    required this.lastChildCacheManager,
    this.expansionIndicator,
  });

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      axis: Axis.vertical,
      sizeFactor: CurvedAnimation(parent: animation, curve: Curves.easeOut),
      child: InkWell(
        // behavior: HitTestBehavior.translucent,
        focusNode: node.focusNode,
        onTap: () {
          node.focusNode.requestFocus();
          onTap?.call(node);
        },
        onDoubleTap: onDoubleTap == null ? null : () => onDoubleTap!(node),
        onSecondaryTap:
            onSecondaryTap == null ? null : () => onSecondaryTap!(node),
        onSecondaryTapDown: onSecondaryTapDown == null
            ? null
            : (details) => onSecondaryTapDown!(node, details),
        onSecondaryTapUp: onSecondaryTapUp == null
            ? null
            : (details) => onSecondaryTapUp!(node, details),
        onLongPress: onLongPress == null ? null : () => onLongPress!(node),
        onHover: onHover == null ? null : (hovered) => onHover!(node, hovered),
        child: Indent(
          indentation: indentation,
          node: node,
          minLevelToIndent: minLevelToIndent,
          lastChildCacheManager: lastChildCacheManager,
          child: expansionIndicator == null
              ? child
              : PositionedExpansionIndicator(
                  expansionIndicator: expansionIndicator!,
                  child: child,
                ),
        ),
      ),
    );
  }
}
