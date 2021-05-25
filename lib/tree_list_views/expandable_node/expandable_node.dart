import 'package:tree_structure_view/node/base/i_node.dart';
import 'package:tree_structure_view/node/node.dart';

extension ExpandableINode on INode {
  static const _isExpandedKey = "is_expanded";

  bool get isExpanded => meta?[_isExpandedKey] == true;

  void setExpanded(bool isExpanded) {
    if (meta == null) meta = {};
    meta![_isExpandedKey] = isExpanded;
  }
}
