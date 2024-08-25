import 'package:animated_tree_view/animated_tree_view.dart';
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
  final ValueSetter<Tree> onToggleExpansion;
  final bool showRootNode;
  final bool isLastChild;

  static Widget insertedNode<Data, Tree extends ITreeNode<Data>>({
    required int index,
    required Tree node,
    required TreeNodeWidgetBuilder<Tree> builder,
    required AutoScrollController scrollController,
    required Animation<double> animation,
    required ExpansionIndicatorBuilder<Data>? expansionIndicator,
    required ValueSetter<Tree>? onItemTap,
    required ValueSetter<Tree> onToggleExpansion,
    required bool showRootNode,
    required Indentation indentation,
    Tree? nextNode,
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
          showRootNode: showRootNode,
          isLastChild: node.level > (nextNode?.level ?? 0),
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
    required ValueSetter<Tree> onToggleExpansion,
    required bool showRootNode,
    required bool isLastChild,
    required Indentation indentation,
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
      onToggleExpansion: onToggleExpansion,
      showRootNode: showRootNode,
      isLastChild: true,
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
    required this.showRootNode,
    required this.indentation,
    required this.isLastChild,
  });

  @override
  Widget build(BuildContext context) {
    final itemContainer = ExpandableNodeContainer(
      key: ValueKey("container#$key"),
      animation: animation,
      node: node,
      child: builder(context, node),
      indentation: indentation,
      minLevelToIndent: showRootNode ? 0 : 1,
      isLastChild: isLastChild,
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
      key: ValueKey("tag#${node.key}"),
      controller: scrollController,
      index: index!,
      child: itemContainer,
    );
  }
}

class ExpandableNodeContainer<T> extends StatelessWidget {
  final Animation<double> animation;
  final ValueSetter<ITreeNode<T>>? onTap;
  final ITreeNode<T> node;
  final ExpansionIndicator? expansionIndicator;
  final Indentation indentation;
  final Widget child;
  final int minLevelToIndent;
  final bool isLastChild;

  const ExpandableNodeContainer({
    super.key,
    required this.animation,
    required this.onTap,
    required this.child,
    required this.node,
    required this.indentation,
    required this.minLevelToIndent,
    required this.isLastChild,
    this.expansionIndicator,
  });

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      axis: Axis.vertical,
      sizeFactor: CurvedAnimation(parent: animation, curve: Curves.easeOut),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onTap == null ? null : () => onTap!(node),
        child: Indent(
          indentation: indentation,
          node: node,
          minLevelToIndent: minLevelToIndent,
          isLastChild: isLastChild,
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
