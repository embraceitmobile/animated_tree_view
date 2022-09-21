import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'controllers/animated_list_controller.dart';
import 'expandable_node/expandable_node.dart';
import 'listenable_node/base/i_listenable_node.dart';
import 'tree_diff/tree_diff_util.dart';

/// The builder function that allows to build any item of type [T].
/// The builder function also provides the [level] of the node.
typedef LeveledItemWidgetBuilder<T> = Widget Function(
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

class TreeView<T extends ListenableNode<T>> extends StatelessWidget {
  /// The [builder] function that is provided to the item builder
  final LeveledItemWidgetBuilder<T> builder;

  /// An optional [controller] that allows controlling the [TreeView] programmatically
  final TreeViewController<T>? controller;

  /// An optional [tree] that can allows to initialize the [TreeView] with
  /// initial data
  final ListenableNode<T>? tree;

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
  final bool? showRootNode;

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
  final bool? shrinkWrap;

  /// The default [TreeView] uses a [Node] internally, which is based on the
  /// [Map] data structure for maintaining the children states.
  /// The [Node] does not allow insertion and removal of
  /// items at index positions. This allows for more efficient insertion and
  /// retrieval of items at child nodes, as child items can be readily accessed
  /// using the map keys.
  ///
  /// The complexity for accessing child nodes in [TreeView] is simply O(node_level).
  /// e.g. for path './.level1/level2', complexity is simply O(2).
  ///
  /// For a [TreeView] that allows for insertion and removal of
  /// items at index positions, use the alternate [IndexedTreeListView].
  ///
  const TreeView({
    super.key,
    required this.builder,
    this.expansionIndicator = ExpansionIndicator.RightUpChevron,
    this.expansionBehavior = ExpansionBehavior.scrollToLastChild,
    this.scrollController,
    this.indentPadding,
    this.showRootNode,
    this.tree,
    this.controller,
    this.shrinkWrap,
    this.onItemTap,
    this.primary,
    this.physics,
    this.padding,
  });

  @override
  Widget build(BuildContext context) => _TreeView<T>(
        builder: builder,
        controller: controller,
        tree: tree ?? ListenableNode<T>.root(),
        expansionIndicator: expansionIndicator,
        expansionBehavior: expansionBehavior,
        scrollController: scrollController,
        indentPadding: indentPadding,
        showRootNode: showRootNode,
        shrinkWrap: shrinkWrap,
        onItemTap: onItemTap,
        primary: primary,
        physics: physics,
        padding: padding,
      );
}

class IndexedTreeView<T extends ListenableIndexedNode<T>>
    extends StatelessWidget {
  /// The [builder] function that is provided to the item builder
  final LeveledItemWidgetBuilder<T> builder;

  /// An optional [controller] that allows controlling the [IndexedTreeView]
  /// programmatically
  final IndexedTreeViewController<T>? controller;

  /// An optional [tree] that can allows to initialize the [IndexedTreeView]
  /// with initial data
  final ListenableIndexedNode<T>? tree;

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
  final bool? showRootNode;

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
  final bool? shrinkWrap;

  /// The alternate implementation of [_TreeView] as [IndexedTreeView] uses an
  /// [IndexedNode] internally, which is based on the [List] data structure for
  /// maintaining the children states.
  /// The [IndexedNode] allows indexed based operations like insertion and removal of
  /// items at index positions. This allows for movement, addition and removal of
  /// child nodes based on indices.
  ///
  /// The complexity for accessing child nodes in [TreeView] is simply O(node_level ^ children).
  ///
  /// If you do not require index based operations, the more performant and efficient
  /// [TreeView] instead.
  ///
  const IndexedTreeView({
    super.key,
    required this.builder,
    this.expansionIndicator = ExpansionIndicator.RightUpChevron,
    this.expansionBehavior = ExpansionBehavior.scrollToLastChild,
    this.scrollController,
    this.indentPadding,
    this.showRootNode,
    this.tree,
    this.controller,
    this.shrinkWrap,
    this.onItemTap,
    this.primary,
    this.physics,
    this.padding,
  });

  @override
  Widget build(BuildContext context) => _TreeView<T>(
        key: key,
        builder: builder,
        controller: controller,
        tree: tree ?? ListenableIndexedNode<T>.root(),
        expansionIndicator: expansionIndicator,
        expansionBehavior: expansionBehavior,
        scrollController: scrollController,
        indentPadding: indentPadding,
        showRootNode: showRootNode,
        shrinkWrap: shrinkWrap,
        onItemTap: onItemTap,
        primary: primary,
        physics: physics,
        padding: padding,
      );
}

class _TreeView<T extends IListenableNode<T>> extends StatefulWidget {
  /// The [builder] function that is provided to the item builder
  final LeveledItemWidgetBuilder<T> builder;

  /// An optional [controller] that allows controlling the [TreeView] programmatically
  final ITreeViewController<T>? controller;

  /// The rootNode of the [tree]
  final IListenableNode<T> tree;

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

  const _TreeView({
    super.key,
    required this.expansionBehavior,
    required this.builder,
    required this.tree,
    this.indentPadding,
    this.scrollController,
    this.expansionIndicator,
    this.controller,
    this.onItemTap,
    this.primary,
    this.physics,
    this.padding,
    bool? shrinkWrap,
    bool? showRootNode,
  })  : this.shrinkWrap = shrinkWrap ?? false,
        this.showRootNode = showRootNode ?? true;

  @override
  State<StatefulWidget> createState() => _TreeViewState<T>();
}

class _TreeViewState<T extends IListenableNode<T>> extends State<_TreeView<T>> {
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  late final AnimatedListController<T> _animatedListController;
  late final AutoScrollController _scrollController;

  List<T> get _nodeList => _animatedListController.list;

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

    // ignore: invalid_use_of_protected_member
    widget.controller?.attach(widget.tree, _animatedListController);
  }

  @override
  void didUpdateWidget(_TreeView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.expansionBehavior != oldWidget.expansionBehavior)
      _animatedListController.expansionBehavior = widget.expansionBehavior;

    didUpdateTree(oldWidget.tree);
  }

  void didUpdateTree(IListenableNode<T> oldTree) {
    final treeDiff = calculateTreeDiff(oldTree, widget.tree);
    if (treeDiff.isEmpty) return;

    for (final update in treeDiff) {
      update.when(
        add: (node) {
          node as T;
          final parentNode = (oldTree.elementAt(node.path).parent ??
              oldTree.root) as INodeActions;
          parentNode.add(node);
        },
        insert: (node, pos) {
          node as T;
          final parentNode = (oldTree.elementAt(node.path).parent ??
              oldTree.root) as IIndexedNodeActions;
          parentNode.insert(pos, node as IndexedNode);
        },
        remove: (node, pos) {
          node as T;
          final parentNode = (oldTree.elementAt(node.path).parent ??
              oldTree.root) as INodeActions;

          parentNode.remove(node);
        },
      );
    }
  }

  Widget build(BuildContext context) {
    return AnimatedList(
      key: listKey,
      initialItemCount: _nodeList.length,
      controller: _scrollController,
      primary: widget.primary,
      physics: widget.physics,
      padding: widget.padding,
      shrinkWrap: widget.shrinkWrap,
      itemBuilder: (context, index, animation) => ValueListenableBuilder<T>(
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
          T item, BuildContext context, Animation<double> animation) =>
      ExpandableNodeItem<T>(
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
