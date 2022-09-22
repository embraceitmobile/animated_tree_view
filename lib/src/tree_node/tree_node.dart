import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:animated_tree_view/src/listenable_node/base/i_listenable_node.dart';
import 'package:flutter/foundation.dart';

abstract class ITreeNode<T> extends IListenableNode
    implements ValueListenable<INode> {
  ValueNotifier<T?>? data;
  late bool isExpanded;
}

class TreeNode<T> extends ListenableNode implements ITreeNode<T> {
  /// A [TreeNode] that can be used with the [TreeView].
  ///
  /// To use your own custom data with [TreeView], wrap your model [T] in [TreeNode]
  /// like this:
  /// ```dart
  ///   class YourCustomNode extends TreeNode<CustomClass> {
  ///   ...
  ///   }
  /// ```
  TreeNode({T? data, this.isExpanded = false, super.key})
      : this.data = ValueNotifier(data);

  factory TreeNode.root() => TreeNode(key: INode.ROOT_KEY);

  @override
  bool isExpanded;

  @override
  ValueNotifier<T?>? data;
}

class IndexedTreeNode<T> extends IndexedListenableNode implements ITreeNode<T> {
  /// A [IndexedTreeNode] that can be used with the [IndexedTreeView].
  ///
  /// To use your own custom data with [IndexedTreeView], wrap your model [T] in [IndexedTreeNode]
  /// like this:
  /// ```dart
  ///   class YourCustomNode extends TreeNode<CustomClass> {
  ///   ...
  ///   }
  /// ```
  IndexedTreeNode({T? data, this.isExpanded = false, super.key})
      : this.data = ValueNotifier(data);

  factory IndexedTreeNode.root() => IndexedTreeNode(key: INode.ROOT_KEY);

  @override
  bool isExpanded;

  @override
  ValueNotifier<T?>? data;
}
