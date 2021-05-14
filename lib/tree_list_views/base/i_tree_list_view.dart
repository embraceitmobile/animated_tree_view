import 'package:flutter/material.dart';
import 'package:tree_structure_view/node/base/i_node.dart';

typedef LeveledItemWidgetBuilder<T extends INode<T>> = Widget Function(
    BuildContext context, int level, INode<T> item);

const DEFAULT_INDENT_PADDING = 24.0;
const DEFAULT_EXPAND_ICON = const Icon(Icons.keyboard_arrow_down);
const DEFAULT_COLLAPSE_ICON = const Icon(Icons.keyboard_arrow_up);

abstract class ITreeListView<T extends INode<T>> {
  LeveledItemWidgetBuilder<T> get builder;
  bool? get showExpansionIndicator;
  Icon? get expandIcon;
  Icon? get collapseIcon;
  double? get indentPadding;
  ValueSetter<T>? get onItemTap;
  bool? get primary;
  ScrollPhysics? get physics;
  bool? get shrinkWrap;
  EdgeInsetsGeometry? get padding;
}
