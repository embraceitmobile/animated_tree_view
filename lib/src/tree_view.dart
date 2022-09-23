import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:animated_tree_view/src/tree_node/expandable_node.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'controllers/animated_list_controller.dart';
import 'tree_diff/tree_diff_util.dart';

/// The builder function that allows to build any item of type [T].
/// The builder function also provides the [level] of the node.
typedef LeveledItemWidgetBuilder<T> = Widget Function(
    BuildContext context, int level, ITreeNode<T> item);

/// The [ExpansionBehavior] provides control over the behavior of the node
/// when it is expanded.
enum ExpansionBehavior {
  /// No additional action will be taken on node expansion.
  none,

  /// The list will be scrolled to the last child of the node if it is not
  /// already visible on screen. This ensures that the last child is always visible.
  scrollToLastChild,

  /// The expanded node will be snapped to the top of the list.This ensures that the
  /// expanded node is always visible with maximum number of children.
  snapToTop,

  /// Collapse all other nodes, only the current node will remain expanded. This ensures
  /// that only one node is expanded at one time.
  collapseOthers,

  /// Collapse all other nodes, only the current node will remain expanded,
  /// also snap the node to the top of the list. This ensures that only one node is expanded at one time.
  collapseOthersAndSnapToTop,
}

class TreeView<T> extends StatefulWidget {
  /// The [builder] function that is provided to the item builder
  final LeveledItemWidgetBuilder<T> builder;

  /// The rootNode of the [tree]
  final ITreeNode<T> tree;

  /// An optional [scrollController] that provides more granular control over
  /// scrolling behavior
  final AutoScrollController? scrollController;

  /// [expansionIndicator] can be customized to provide any expansion widget
  /// and collapse widget. The pre-built available [expansionIndicator]s are
  /// ** [ExpansionIndicator.RightUpChevron]
  /// ** [ExpansionIndicator.PlusMinus]
  /// ** [ExpansionIndicator.DownUpChevron]
  ///
  /// You can simply pass [null], if you do not want to show an [expansionIndicator]
  final ExpansionIndicator? expansionIndicator;

  /// This is the padding is applied to the start of an item. [indentPadding]
  /// will be multiplied by [INode.level] before being applied.
  /// ** e.g. if the node level is 2 and [indentPadding] is 8, then the start
  /// padding applied to an item will be 2*8 = 16
  final double? indentPadding;

  /// An optional callback that can be used to handle any action when an item is
  /// tapped or clicked
  final ValueSetter<T>? onItemTap;

  /// Flag to show the Root Node in the [TreeView]. Root Node is always the first
  /// item in the TreeView. If it is set to [false] then the Root Node will not
  /// be displayed, rather the first child of the RootNode will be the first item
  /// in the TreeList
  final bool showRootNode;

  /// The [ExpansionBehavior] provides control over the behavior of the node
  /// when it is expanded.
  ///
  /// For more detail see [ExpansionBehavior].
  /// The default [expansionBehavior] is [ExpansionBehavior.scrollToLastChild]
  final ExpansionBehavior expansionBehavior;

  /// The amount of space by which to inset the children.
  ///
  /// This is passed directly to the [AnimatedList]'s [padding] attribute
  /// For more information see the [AnimatedList.padding]
  final EdgeInsetsGeometry? padding;

  /// Whether this is the primary scroll view associated with the parent
  /// [PrimaryScrollController].
  ///
  /// This is passed directly to the [AnimatedList]'s [primary] attribute
  /// For more information see the [AnimatedList.primary]
  final bool? primary;

  /// An object that can be used to control the position to which this scroll
  /// view is scrolled.
  ///
  /// This is passed directly to the [AnimatedList]'s [physics] attribute
  /// For more information see the [AnimatedList.physics]
  final ScrollPhysics? physics;

  /// Whether the extent of the scroll view in the [scrollDirection] should be
  /// determined by the contents being viewed.
  /// This is passed directly to the [AnimatedList]'s [shrinkWrap] attribute
  /// For more information see the [AnimatedList.shrinkWrap]
  final bool shrinkWrap;

  const TreeView._({
    super.key,
    this.expansionBehavior = ExpansionBehavior.none,
    required this.builder,
    required this.tree,
    this.indentPadding,
    this.scrollController,
    this.expansionIndicator,
    this.onItemTap,
    this.primary,
    this.physics,
    this.padding,
    bool? shrinkWrap,
    bool? showRootNode,
  })  : this.shrinkWrap = shrinkWrap ?? false,
        this.showRootNode = showRootNode ?? true;

  factory TreeView({
    required LeveledItemWidgetBuilder<T> builder,
    required final TreeNode<T> tree,
    ExpansionBehavior expansionBehavior = ExpansionBehavior.scrollToLastChild,
    double? indentPadding,
    AutoScrollController? scrollController,
    ExpansionIndicator? expansionIndicator,
    ValueSetter<T>? onItemTap,
    bool? primary,
    ScrollPhysics? physics,
    EdgeInsetsGeometry? padding,
    bool? shrinkWrap,
    bool? showRootNode,
  }) =>
      TreeView._(
        builder: builder,
        tree: tree,
        expansionBehavior: expansionBehavior,
        indentPadding: indentPadding,
        expansionIndicator: expansionIndicator,
        scrollController: scrollController,
        onItemTap: onItemTap,
        primary: primary,
        physics: physics,
        padding: padding,
        shrinkWrap: shrinkWrap,
        showRootNode: showRootNode,
      );

  factory TreeView.indexed({
    required LeveledItemWidgetBuilder<T> builder,
    required final IndexedTreeNode<T> tree,
    ExpansionBehavior expansionBehavior = ExpansionBehavior.none,
    double? indentPadding,
    AutoScrollController? scrollController,
    ExpansionIndicator? expansionIndicator,
    ValueSetter<T>? onItemTap,
    bool? primary,
    ScrollPhysics? physics,
    EdgeInsetsGeometry? padding,
    bool? shrinkWrap,
    bool? showRootNode,
  }) =>
      TreeView._(
        builder: builder,
        tree: tree,
        expansionBehavior: expansionBehavior,
        indentPadding: indentPadding,
        expansionIndicator: expansionIndicator,
        scrollController: scrollController,
        onItemTap: onItemTap,
        primary: primary,
        physics: physics,
        padding: padding,
        shrinkWrap: shrinkWrap,
        showRootNode: showRootNode,
      );

  @override
  State<StatefulWidget> createState() => _TreeViewState<T>();
}

class _TreeViewState<T> extends State<TreeView<T>> {
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  late final AnimatedListController<T> _animatedListController;
  late final AutoScrollController _scrollController;

  List<ITreeNode<T>> get _nodeList => _animatedListController.list;

  ITreeNode<T> get _tree => _animatedListController.tree;

  @override
  void initState() {
    super.initState();

    _scrollController =
        widget.scrollController ?? AutoScrollController(axis: Axis.vertical);

    _animatedListController = AnimatedListController<T>(
      listKey: listKey,
      tree: widget.tree,
      removedItemBuilder: buildRemovedItem,
      showRootNode: widget.showRootNode,
      scrollController: _scrollController,
      expansionBehavior: widget.expansionBehavior,
    );
  }

  @override
  void didUpdateWidget(TreeView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.expansionBehavior != oldWidget.expansionBehavior)
      _animatedListController.expansionBehavior = widget.expansionBehavior;

    didUpdateTree();
  }

  void didUpdateTree() {
    final treeDiff = calculateTreeDiff<ITreeNode<T>>(_tree, widget.tree);
    if (treeDiff.isEmpty) return;

    for (final update in treeDiff) {
      update.when(
        add: (node) {
          node as T;
          final parentNode = _tree
              .elementAt(node.parent?.path ?? node.root.path) as INodeActions;
          parentNode.add(node);
        },
        insert: (node, pos) {
          node as T;
          final parentNode =
              _tree.elementAt(node.parent?.path ?? node.root.path)
                  as IIndexedNodeActions;
          parentNode.insert(pos, node as IndexedNode);
        },
        remove: (node, pos) {
          node as T;
          final parentNode = _tree
              .elementAt(node.parent?.path ?? node.root.path) as INodeActions;

          parentNode.remove(node);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: listKey,
      initialItemCount: _nodeList.length,
      controller: _scrollController,
      primary: widget.primary,
      physics: widget.physics,
      padding: widget.padding,
      shrinkWrap: widget.shrinkWrap,
      itemBuilder: (context, index, animation) => ValueListenableBuilder<INode>(
        valueListenable: _nodeList[index],
        builder: (context, value, child) => ExpandableNodeItem<T>(
          builder: widget.builder,
          animatedListController: _animatedListController,
          scrollController: _scrollController,
          node: _nodeList[index],
          index: index,
          animation: animation,
          indentPadding: widget.indentPadding,
          expansionIndicator: widget.expansionIndicator,
          onItemTap: widget.onItemTap,
          minLevelToIndent: widget.showRootNode ? 0 : 1,
        ),
      ),
    );
  }

  Widget buildRemovedItem(
      ITreeNode<T> item, BuildContext context, Animation<double> animation) {
    return ExpandableNodeItem<T>(
      builder: widget.builder,
      animatedListController: _animatedListController,
      scrollController: _scrollController,
      node: item,
      remove: true,
      animation: animation,
      indentPadding: widget.indentPadding,
      expansionIndicator: widget.expansionIndicator,
      onItemTap: widget.onItemTap,
      minLevelToIndent: widget.showRootNode ? 0 : 1,
    );
  }
}
