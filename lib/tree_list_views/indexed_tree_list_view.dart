// import 'package:flutter/material.dart';
// import 'package:scroll_to_index/scroll_to_index.dart';
// import 'package:tree_structure_view/tree_list_views/controllers/animated_list_controller.dart';
// import 'package:tree_structure_view/tree_list_views/controllers/list_view_controller/base/i_tree_list_view_controller.dart';
// import 'package:tree_structure_view/listenable_tree/listenable_indexed_tree.dart';
// import 'package:tree_structure_view/node/indexed_node.dart';
// import 'package:tree_structure_view/tree/base/tree_update_notifier.dart';
// import 'package:tree_structure_view/tree/indexed_tree.dart';
// import 'package:tree_structure_view/tree_list_views/widgets/tree_builder_mixin.dart';
//
// import 'base/i_tree_list_view.dart';
//
// /// The [IndexedTreeListView] uses an [IndexedNode] internally, which is based
// /// the [List] data structure for handling child nodes.
// /// Using a [List] structure allows for insertion and removal of items in child
// /// nodes. However, this makes the node access operation less efficient as the
// /// children need to be iterated for each node level.
// ///
// /// The complexity for accessing nodes for [IndexedTreeListView] is
// /// O(n^m), where n is the number of children in a node, and m is the node level.
// ///
// /// If you do not have a requirement for insertion and removal of items in a
// /// node, use the more efficient [TreeListView] instead.
// class IndexedTreeListView<T extends IndexedNode<T>> extends StatefulWidget
//     implements ITreeListView<T> {
//   final List<T>? initialItems;
//   final ITreeListViewController<T>? controller;
//   final LeveledItemWidgetBuilder<T> builder;
//   final bool showExpansionIndicator;
//   final Icon expandIcon;
//   final Icon collapseIcon;
//   final double indentPadding;
//   final ValueSetter<T>? onItemTap;
//   final bool? primary;
//   final ScrollPhysics? physics;
//   final bool? shrinkWrap;
//   final EdgeInsetsGeometry? padding;
//
//   const IndexedTreeListView({
//     Key? key,
//     required this.builder,
//     this.initialItems,
//     this.controller,
//     this.onItemTap,
//     this.primary,
//     this.physics,
//     this.shrinkWrap,
//     this.padding,
//     this.showExpansionIndicator = true,
//     this.indentPadding = DEFAULT_INDENT_PADDING,
//     this.expandIcon = DEFAULT_EXPAND_ICON,
//     this.collapseIcon = DEFAULT_COLLAPSE_ICON,
//   }) : super(key: key);
//
//   @override
//   State<StatefulWidget> createState() => _IndexedTreeListViewState<T>();
// }
//
// class _IndexedTreeListViewState<T extends IndexedNode<T>>
//     extends State<IndexedTreeListView<T>>
//     with TreeBuilderMixin<T>
//     implements ITreeListView<T> {
//   static const TAG = "IndexedTreeListView";
//
//   final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
//   late final AutoScrollController scrollController = AutoScrollController();
//   late final AnimatedListController<T> animatedListController;
//   late final ListenableIndexedTree<T> _listenableTree;
//
//   TreeUpdateNotifier<T> get treeUpdateNotifier => _listenableTree;
//   LeveledItemWidgetBuilder<T> get builder => widget.builder;
//   Icon? get collapseIcon => widget.collapseIcon;
//   Icon? get expandIcon => widget.expandIcon;
//   double? get indentPadding => widget.indentPadding;
//   ValueSetter<T>? get onItemTap => widget.onItemTap;
//   EdgeInsetsGeometry? get padding => widget.padding;
//   ScrollPhysics? get physics => widget.physics;
//   bool? get primary => widget.primary;
//   bool? get showExpansionIndicator => widget.showExpansionIndicator;
//   bool? get shrinkWrap => widget.shrinkWrap;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _listenableTree = ListenableIndexedTree<T>(widget.initialItems == null
//         ? IndexedTree<T>()
//         : IndexedTree<T>.fromList(widget.initialItems!));
//
//     animatedListController = AnimatedListController.indexedTree(
//       listKey: listKey,
//       listenableIndexedTree: _listenableTree,
//       removedItemBuilder: buildRemovedItem,
//     );
//
//     widget.controller?.attach(
//       tree: _listenableTree,
//       scrollController: scrollController,
//       listController: animatedListController,
//     );
//
//     observeTreeUpdates();
//   }
//
//   @override
//   void dispose() {
//     cancelTreeUpdates();
//     _listenableTree.dispose();
//     super.dispose();
//   }
// }
