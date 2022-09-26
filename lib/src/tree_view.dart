import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:animated_tree_view/src/tree_node/expandable_node.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'controllers/animated_list_controller.dart';
import 'tree_diff/tree_diff_util.dart';

/// The builder function that allows to build any item of type [T].
/// The builder function also provides the [level] of the node.
typedef LeveledItemWidgetBuilder<D, T> = Widget Function(
    BuildContext context, int level, T item);

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

class TreeView<D, T extends ITreeNode<D>> extends StatefulWidget {
  /// The [builder] function that is provided to the item builder
  final LeveledItemWidgetBuilder<D, T> builder;

  /// The rootNode of the [tree]
  final ITreeNode<D> tree;

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
  final ValueSetter<D>? onItemTap;

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

  static TreeView<D, TreeNode<D>> simple<D>({
    Key? key,
    required LeveledItemWidgetBuilder<D, TreeNode<D>> builder,
    required final TreeNode<D> tree,
    ExpansionBehavior expansionBehavior = ExpansionBehavior.scrollToLastChild,
    double? indentPadding,
    AutoScrollController? scrollController,
    ExpansionIndicator? expansionIndicator,
    ValueSetter<D>? onItemTap,
    bool? primary,
    ScrollPhysics? physics,
    EdgeInsetsGeometry? padding,
    bool? shrinkWrap,
    bool? showRootNode,
  }) =>
      TreeView._(
        key: key,
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

  static TreeView<D, IndexedTreeNode<D>> indexed<D>({
    Key? key,
    required LeveledItemWidgetBuilder<D, IndexedTreeNode<D>> builder,
    required final IndexedTreeNode<D> tree,
    ExpansionBehavior expansionBehavior = ExpansionBehavior.none,
    double? indentPadding,
    AutoScrollController? scrollController,
    ExpansionIndicator? expansionIndicator,
    ValueSetter<D>? onItemTap,
    bool? primary,
    ScrollPhysics? physics,
    EdgeInsetsGeometry? padding,
    bool? shrinkWrap,
    bool? showRootNode,
  }) =>
      TreeView._(
        key: key,
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
  State<StatefulWidget> createState() => TreeViewState<D, T>();
}

class TreeViewState<D, T extends ITreeNode<D>> extends State<TreeView<D, T>> {
  late final TreeViewController<D, T> controller;

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late final AnimatedListController<D> _animatedListController;
  late final AutoScrollController _scrollController;

  ITreeNode<D> get _tree => _animatedListController.tree;

  @override
  void initState() {
    super.initState();

    _scrollController =
        widget.scrollController ?? AutoScrollController(axis: Axis.vertical);

    _animatedListController = AnimatedListController<D>(
      listKey: _listKey,
      tree: widget.tree,
      removedItemBuilder: _buildRemovedItem,
      showRootNode: widget.showRootNode,
      scrollController: _scrollController,
      expansionBehavior: widget.expansionBehavior,
    );

    controller = TreeViewController(_animatedListController);
  }

  @override
  void didUpdateWidget(TreeView<D, T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.expansionBehavior != oldWidget.expansionBehavior)
      _animatedListController.expansionBehavior = widget.expansionBehavior;

    _didUpdateTree();
  }

  void _didUpdateTree() {
    final treeDiff = calculateTreeDiff<ITreeNode<D>>(_tree, widget.tree);
    if (treeDiff.isEmpty) return;

    for (final update in treeDiff) {
      update.when(add: (node) {
        node as D;
        final parentNode = _tree.elementAt(node.parent?.path ?? node.root.path)
            as INodeActions;
        parentNode.add(node);
      }, insert: (node, pos) {
        node as D;
        final parentNode = _tree.elementAt(node.parent?.path ?? node.root.path)
            as IIndexedNodeActions;
        parentNode.insert(pos, node as IndexedNode);
      }, remove: (node, pos) {
        node as D;
        final parentNode = _tree.elementAt(node.parent?.path ?? node.root.path)
            as INodeActions;

        parentNode.remove(node);
      }, update: (node) {
        node as D;

        //TODO: add node update implementation here
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: _listKey,
      initialItemCount: _animatedListController.list.length,
      controller: _scrollController,
      primary: widget.primary,
      physics: widget.physics,
      padding: widget.padding,
      shrinkWrap: widget.shrinkWrap,
      itemBuilder: (context, index, animation) => ValueListenableBuilder<INode>(
        valueListenable: _animatedListController.list[index],
        builder: (context, treeNode, _) => ValueListenableBuilder(
          valueListenable: (treeNode as T).listenableData,
          builder: (context, data, _) => ExpandableNodeItem<D, T>(
            builder: (context, level, node) =>
                widget.builder(context, level, node),
            animatedListController: _animatedListController,
            scrollController: _scrollController,
            node: _animatedListController.list[index] as T,
            index: index,
            animation: animation,
            indentPadding: widget.indentPadding,
            expansionIndicator: widget.expansionIndicator,
            onItemTap: widget.onItemTap,
            minLevelToIndent: widget.showRootNode ? 0 : 1,
          ),
        ),
      ),
    );
  }

  Widget _buildRemovedItem(
      T item, BuildContext context, Animation<double> animation) {
    return ExpandableNodeItem<D, T>(
      builder: (context, level, node) => widget.builder(context, level, node),
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

class TreeViewController<D, T extends ITreeNode<D>> {
  final AnimatedListController<D> _animatedListController;

  TreeViewController(this._animatedListController);

  Future scrollToIndex(int index) async =>
      _animatedListController.scrollToIndex;

  Future scrollToItem(T item) async => _animatedListController.scrollToItem;

  void collapseNode(T item) => _animatedListController.collapseNode;

  void expandNode(T item) => _animatedListController.expandNode;

  void toggleExpansion(T item) => _animatedListController.toggleExpansion;

  ITreeNode<D> get tree => _animatedListController.tree;

  INode elementAt(String path) => tree.elementAt(path);
}
