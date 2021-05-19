import 'package:flutter/material.dart';
import 'package:tree_structure_view/node/indexed_node.dart';
import 'package:tree_structure_view/node/node.dart';
import 'base/i_tree_list_view.dart';
import 'controllers/tree_list_view_controller.dart';

class TreeListView<T extends Node<T>> extends ITreeListView<T> {
  const TreeListView({
    Key? key,
    required LeveledItemWidgetBuilder<T> builder,
    required TreeListViewController<T> controller,
    ValueSetter<T>? onItemTap,
    bool? primary,
    ScrollPhysics? physics,
    bool? shrinkWrap,
    EdgeInsetsGeometry? padding,
    bool showExpansionIndicator = true,
    double indentPadding = DEFAULT_INDENT_PADDING,
    Icon expandIcon = DEFAULT_EXPAND_ICON,
    Icon collapseIcon = DEFAULT_COLLAPSE_ICON,
  }) : super(
            key: key,
            builder: builder,
            controller: controller,
            showExpansionIndicator: showExpansionIndicator,
            expandIcon: expandIcon,
            collapseIcon: collapseIcon,
            indentPadding: indentPadding,
            onItemTap: onItemTap,
            primary: primary,
            physics: physics,
            shrinkWrap: shrinkWrap,
            padding: padding);
}

class IndexedTreeListView<T extends IndexedNode<T>> extends ITreeListView<T> {
  const IndexedTreeListView({
    Key? key,
    required LeveledItemWidgetBuilder<T> builder,
    required IndexedTreeListViewController<T> controller,
    ValueSetter<T>? onItemTap,
    bool? primary,
    ScrollPhysics? physics,
    bool? shrinkWrap,
    EdgeInsetsGeometry? padding,
    bool showExpansionIndicator = true,
    double indentPadding = DEFAULT_INDENT_PADDING,
    Icon expandIcon = DEFAULT_EXPAND_ICON,
    Icon collapseIcon = DEFAULT_COLLAPSE_ICON,
  }) : super(
            key: key,
            builder: builder,
            controller: controller,
            showExpansionIndicator: showExpansionIndicator,
            expandIcon: expandIcon,
            collapseIcon: collapseIcon,
            indentPadding: indentPadding,
            onItemTap: onItemTap,
            primary: primary,
            physics: physics,
            shrinkWrap: shrinkWrap,
            padding: padding);
}


