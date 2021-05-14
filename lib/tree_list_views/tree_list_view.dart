import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:tree_structure_view/tree_list_views/controllers/animated_list_controller.dart';
import 'package:tree_structure_view/tree_list_views/controllers/list_view_controller/base/i_tree_list_view_controller.dart';
import 'package:tree_structure_view/listenable_tree/listenable_tree.dart';
import 'package:tree_structure_view/node/node.dart';
import 'package:tree_structure_view/tree/base/tree_update_notifier.dart';
import 'package:tree_structure_view/tree/tree.dart';
import 'package:tree_structure_view/tree_list_views/widgets/tree_builder_mixin.dart';

import 'base/i_tree_list_view.dart';

/// The default [TreeListView] uses a [Node] internally, which is based on the
/// [Map] data structure for maintaining the children states.
/// The [Node] does not allow insertion and removal of
/// items at index positions. This allows for more efficient insertion and
/// retrieval of items at child nodes, as child items can be readily accessed
/// using the map keys.
///
/// The complexity for accessing child nodes in [TreeListView] is simply O(node_level).
/// e.g. for path './.level1/level2', complexity is simply O(2).
///
/// For a [TreeListView] that allows for insertion and removal of
/// items at index positions, use the alternate [IndexedTreeListView].

class TreeListView<T extends Node<T>> extends StatefulWidget
    implements ITreeListView<T> {
  final Map<String, T>? initialItems;
  final ITreeListViewController<T>? controller;
  final LeveledItemWidgetBuilder<T> builder;
  final bool showExpansionIndicator;
  final Icon expandIcon;
  final Icon collapseIcon;
  final double indentPadding;
  final ValueSetter<T>? onItemTap;
  final bool? primary;
  final ScrollPhysics? physics;
  final bool? shrinkWrap;
  final EdgeInsetsGeometry? padding;

  const TreeListView({
    Key? key,
    required this.builder,
    this.initialItems,
    this.controller,
    this.onItemTap,
    this.primary,
    this.physics,
    this.shrinkWrap,
    this.padding,
    this.showExpansionIndicator = true,
    this.indentPadding = DEFAULT_INDENT_PADDING,
    this.expandIcon = DEFAULT_EXPAND_ICON,
    this.collapseIcon = DEFAULT_COLLAPSE_ICON,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TreeListViewState<T>();
}

class _TreeListViewState<T extends Node<T>> extends State<TreeListView<T>>
    with TreeBuilderMixin<T>
    implements ITreeListView<T> {
  static const TAG = "TreeListView";

  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  late final AutoScrollController scrollController = AutoScrollController();
  late final AnimatedListController<T> animatedListController;
  late final ListenableTree<T> _listenableTree;

  TreeUpdateNotifier<T> get treeUpdateNotifier => _listenableTree;
  LeveledItemWidgetBuilder<T> get builder => widget.builder;
  Icon? get collapseIcon => widget.collapseIcon;
  Icon? get expandIcon => widget.expandIcon;
  double? get indentPadding => widget.indentPadding;
  ValueSetter<T>? get onItemTap => widget.onItemTap;
  EdgeInsetsGeometry? get padding => widget.padding;
  ScrollPhysics? get physics => widget.physics;
  bool? get primary => widget.primary;
  bool? get showExpansionIndicator => widget.showExpansionIndicator;
  bool? get shrinkWrap => widget.shrinkWrap;

  @override
  void initState() {
    super.initState();

    _listenableTree = ListenableTree<T>(widget.initialItems == null
        ? Tree<T>()
        : Tree<T>.fromMap(widget.initialItems!));

    animatedListController = AnimatedListController.tree(
      listKey: listKey,
      listenableTree: _listenableTree,
      removedItemBuilder: buildRemovedItem,
    );

    widget.controller?.attach(
      tree: _listenableTree,
      scrollController: scrollController,
      listController: animatedListController,
    );

    observeTreeUpdates();
  }

  @override
  void dispose() {
    cancelTreeUpdates();
    _listenableTree.dispose();
    super.dispose();
  }
}
