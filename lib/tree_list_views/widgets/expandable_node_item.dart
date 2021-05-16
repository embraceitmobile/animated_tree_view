// import 'package:flutter/material.dart';
// import 'package:tree_structure_view/tree_list_views/base/i_tree_list_view.dart';
// import 'package:tree_structure_view/tree_list_views/controllers/animated_list_controller.dart';
// import 'package:tree_structure_view/tree_list_views/widgets/expandable_node_container.dart';
// import 'package:tree_structure_view/tree_structure_view.dart';
// import 'package:scroll_to_index/scroll_to_index.dart';
// import 'package:tree_structure_view/tree_list_views/models/expandable_node.dart';
//
// class ExpandableNodeItem<T extends INode<T>> extends StatelessWidget {
//   final LeveledItemWidgetBuilder<T> builder;
//   final AnimatedListController<T> animatedListController;
//   final AutoScrollController scrollController;
//   final INode<T> node;
//   final Animation<double> animation;
//   final double? indentPadding;
//   final bool? showExpansionIndicator;
//   final Icon? expandIcon;
//   final Icon? collapseIcon;
//   final bool remove;
//   final int? index;
//   final ValueSetter<T>? onItemTap;
//
//   const ExpandableNodeItem(
//       {Key? key,
//       required this.builder,
//       required this.animatedListController,
//       required this.scrollController,
//       required this.node,
//       required this.animation,
//       this.remove = false,
//       this.index,
//       this.indentPadding,
//       this.showExpansionIndicator,
//       this.expandIcon,
//       this.collapseIcon,
//       this.onItemTap})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final itemContainer = ExpandableNodeContainer(
//       animation: animation,
//       item: node,
//       child: builder(context, node.level, node as T),
//       indentPadding: indentPadding! * node.level,
//       showExpansionIndicator:
//           showExpansionIndicator! && node.childrenAsList.isNotEmpty,
//       expandedIndicatorIcon: node.isExpanded ? collapseIcon : expandIcon,
//       onTap: remove
//           ? null
//           : (dynamic item) {
//               animatedListController.toggleExpansion(item);
//               if (onItemTap != null) onItemTap!(item);
//             },
//     );
//
//     if (index == null || remove) return itemContainer;
//
//     return AutoScrollTag(
//       key: ValueKey(node.key),
//       controller: scrollController,
//       index: index!,
//       child: itemContainer,
//     );
//   }
// }
