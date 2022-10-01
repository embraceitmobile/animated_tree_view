import 'dart:async';
import '../tree_diff/tree_diff_util.dart';
import 'package:flutter/material.dart';
import 'package:animated_tree_view/animated_tree_view.dart';

import 'animated_list_controller.dart';
import 'expandable_node.dart';

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

/// The [TreeView] allows to visually display a tree data structure in a linear
/// list which animates the node addition, removal, changes and expansion/collapse
/// of the node.
///
/// The [TreeView] is based on the [AnimatedList], so it can be used as a replacement
/// of [AnimatedList].
///
/// The default [TreeView.simple] uses a [TreeNode] internally, which is based on the
/// [Map] data structure for maintaining the children states.
/// The [TreeNode] does not allow insertion and removal of
/// items at index positions. This allows for more efficient insertion and
/// retrieval of items at child nodes, as child items can be readily accessed
/// using the map keys.
///
/// The complexity for accessing child nodes in [TreeView] is simply O(node_level).
/// e.g. for path './.level1/level2', complexity is simply O(2).
///
/// For a [TreeView] that allows for insertion and removal of
/// items at index positions, use the alternate [TreeView.indexed].
class TreeView<D, T extends ITreeNode<D>> extends StatefulWidget {
  /// The [builder] function that is provided to the item builder
  final LeveledItemWidgetBuilder<D, T> builder;

  /// The rootNode of the [tree]. If the [tree] is updated using setState or any
  /// other state management tool, then a [TreeDiff] is performed to get all the
  /// nodes that have been modified between the old and new trees. The [TreeDiffUpdate]
  /// result is then used to apply the changes in the new tree to the old tree.
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

  /// The default implementation of [TreeView] that uses a [TreeNode] internally,
  /// which is based on the
  /// [Map] data structure for maintaining the children states.
  /// The [TreeNode] does not allow insertion and removal of
  /// items at index positions. This allows for more efficient insertion and
  /// retrieval of items at child nodes, as child items can be readily accessed
  /// using the map keys.
  ///
  /// The complexity for accessing child nodes in [TreeView.simple] is simply O(node_level).
  /// e.g. for path './.level1/level2', complexity is simply O(2).
  ///
  /// ** See code in example/lib/samples/widgets/treeview_modification_sample.dart **
  /// {@end-tool}
  ///
  /// See also:
  ///   * For a [TreeView] that allows for insertion and removal of
  ///   items at index positions, use the alternate [TreeView.indexed].
  ///   * For using an object that extends the [TreeNode] instead of using [TreeNode]
  ///   directly, used the [TreeView.simpleTyped] which allows for typed objects
  ///   to be returned in the [builder]
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

  /// Use the typed constructor if you are extending the [TreeNode] instead of
  /// directly wrapping the data in the [TreeNode]. Using the [TreeView.simpleTyped]
  /// allows the [builder] to return the correctly typed [T] object.
  ///
  /// The default implementation of [TreeView] that uses a [TreeNode] internally,
  /// which is based on the [Map] data structure for maintaining the children states.
  /// The [TreeNode] does not allow insertion and removal of
  /// items at index positions. This allows for more efficient insertion and
  /// retrieval of items at child nodes, as child items can be readily accessed
  /// using the map keys.
  ///
  /// The complexity for accessing child nodes in [TreeView.simple] is simply O(node_level).
  /// e.g. for path './.level1/level2', complexity is simply O(2).
  ///
  /// ** See code in example/lib/samples/widgets/treeview_indexed_modification_sample.dart **
  ///  {@end-tool}
  ///
  /// See also:
  ///   * For a [TreeView] that allows for insertion and removal of
  ///   items at index positions, use the alternate [TreeView.indexTyped].
  ///   * If you are wrapping the data directly in the [TreeNode] instead of
  ///   extending the [TreeNode], then you can also use the simpler [TreeView.simple].
  static TreeView<D, T> simpleTyped<D, T extends TreeNode<D>>({
    Key? key,
    required LeveledItemWidgetBuilder<D, T> builder,
    required final T tree,
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

  /// The alternate implementation of [TreeView] uses an [IndexedNode] internally,
  /// which is based on the [List] data structure for maintaining the children states.
  /// The [IndexedNode] allows indexed based operations like insertion and removal of
  /// items at index positions. This allows for movement, addition and removal of
  /// child nodes based on indices.
  ///
  /// The complexity for accessing child nodes in [TreeView.indexed] is simply
  /// O(node_level ^ children).
  ///
  /// ** See code in example/lib/samples/widgets/treeview_indexed_modification_sample.dart **
  ///  {@end-tool}
  ///
  /// If you do not require index based operations, the more performant and efficient
  /// [TreeView.simple] instead.
  ///
  /// See also:
  ///   * If you do not require index based operations, the more performant and
  ///   efficient [TreeView.simple] instead.
  ///   * For using an object that extends the [IndexedTreeNode] instead of using
  ///   [IndexedTreeNode] directly, used the [TreeView.indexTyped] which allows
  ///   for typed objects to be returned in the [builder]
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

  /// Use the typed constructor if you are extending the [IndexedTreeNode] instead
  /// of directly wrapping the data in the [IndexedTreeNode].
  /// Using the [TreeView.indexTyped] allows the [builder] to return the correctly
  /// typed [T] object.
  ///
  /// This alternate implementation of [TreeView] uses an [IndexedNode] internally,
  /// which is based on the [List] data structure for maintaining the children states.
  /// The [IndexedNode] allows indexed based operations like insertion and removal of
  /// items at index positions. This allows for movement, addition and removal of
  /// child nodes based on indices.
  ///
  /// The complexity for accessing child nodes in [TreeView.indexed] is simply
  /// O(node_level ^ children).
  ///
  /// If you do not require index based operations, the more performant and efficient
  /// [TreeView.simple] instead.
  ///
  /// See also:
  ///   * If you do not require index based operations, the more performant and
  ///     efficient [TreeView.simpleTyped] instead.
  ///   * If you are wrapping the data directly in the [IndexedTreeNode] instead of
  ///     extending the [IndexedTreeNode], then you can also use the simpler [TreeView.indexed].
  static TreeView<D, T> indexTyped<D, T extends IndexedTreeNode<D>>({
    Key? key,
    required LeveledItemWidgetBuilder<D, T> builder,
    required final T tree,
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
        node as T;
        final parentNode = _tree.elementAt(node.parent?.path ?? node.root.path)
            as INodeActions;
        parentNode.add(node);
      }, insert: (node, pos) {
        node as T;
        final parentNode = _tree.elementAt(node.parent?.path ?? node.root.path)
            as IIndexedNodeActions;
        parentNode.insert(pos, node as IndexedNode);
      }, remove: (node, pos) {
        node as T;
        final parentNode = _tree.elementAt(node.parent?.path ?? node.root.path)
            as INodeActions;

        parentNode.remove(node);
      }, update: (node) {
        node as T;
        final oldNode = _tree.elementAt(node.path) as T;
        oldNode.data = node.data;
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

///Utility class to provide easy access to basic node operations.
///The [TreeViewController] also exposes basic scrolling methods that can be used
///for scrolling to an item or a list index.
class TreeViewController<D, T extends ITreeNode<D>> {
  final AnimatedListController<D> _animatedListController;

  const TreeViewController(this._animatedListController);

  /// Method for programmatically scrolling to an [index] in the flat list of the [TreeView].
  Future scrollToIndex(int index) async =>
      _animatedListController.scrollToIndex;

  /// Method for programmatically scrolling to a [node] in the [TreeView].
  Future scrollToItem(T node) async =>
      _animatedListController.scrollToItem(node);

  /// Method for programmatically collapsing an expanded [TreeNode].
  void collapseNode(T node) => _animatedListController.collapseNode(node);

  /// Method for programmatically expanding an collapsing [TreeNode].
  void expandNode(T node) => _animatedListController.expandNode(node);

  /// Method for programmatically toggling the expansion state of a [TreeNode].
  /// If the [TreeNode] is in expanded state, then it will be collapsed.
  /// Else if the [TreeNode] is in collapsed state, then it will be expanded.
  void toggleExpansion(T node) => _animatedListController.toggleExpansion(node);

  /// Returns the [INode.ROOT_KEY] root of the [tree]
  T get tree => _animatedListController.tree as T;

  /// Returns the [ITreeNode] at the provided [path]
  T elementAt(String path) => tree.elementAt(path) as T;
}
