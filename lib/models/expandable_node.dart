import '../tree_structure_view.dart';

extension ExpandableNode<T extends INode<T>> on INode<T> {
  static const _isExpandedKey = "is_expanded";

  bool get isExpanded => meta[_isExpandedKey] == true;

  void setExpanded(bool isExpanded) => meta[_isExpandedKey] = isExpanded;
}
