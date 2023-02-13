import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:animated_tree_view/listenable_node/base/i_listenable_node.dart';
import 'package:flutter/foundation.dart';

/// Base class that allows a data of type [T] to be wrapped in a [ListenableNode]
abstract class ITreeNode<T> extends IListenableNode
    implements ValueListenable<INode> {
  /// Constructor for [ITreeNode] that allows a data of type [T] to be wrapped in a [ListenableNode]
  ITreeNode(this.listenableData);

  /// [ValueNotifier] for data [T] that can be listened for data changes;
  final ValueNotifier<T?> listenableData;

  /// Shows whether the node is expanded or not
  late bool isExpanded;

  /// The data value [T] of wrapped in the [ITreeNode]
  T? get data => listenableData.value;

  /// The setter for data value [T] of wrapped in the Node.
  /// It will notify [listenableData] whenever the value is set.
  set data(T? value) {
    listenableData.value = value;
  }
}

/// A [TreeNode] that can be used with the [TreeView].
///
/// To use your own custom data with [TreeView], wrap your model [T] in [TreeNode]
/// like this:
/// ```dart
///   class YourCustomNode extends TreeNode<CustomClass> {
///   ...
///   }
/// ```
class TreeNode<T> extends ListenableNode implements ITreeNode<T> {
  /// A [TreeNode] constructor that can be used with the [TreeView].
  /// Any data of type [T] can be wrapped with [TreeNode]
  TreeNode({T? data, this.isExpanded = false, super.key, super.parent})
      : this.listenableData = ValueNotifier(data);

  /// Factory constructor to be used only for root [TreeNode]
  factory TreeNode.root({T? data}) => TreeNode(key: INode.ROOT_KEY, data: data);

  /// [ValueNotifier] for data [T] that can be listened for data changes;
  final ValueNotifier<T?> listenableData;

  /// Shows whether the node is expanded or not
  @override
  bool isExpanded;

  /// The data value [T] of wrapped in the [TreeNode]
  @override
  T? get data => listenableData.value;

  /// The setter for data value [T] of wrapped in the [TreeNode].
  /// It will notify [listenableData] whenever the value is set.
  @override
  set data(T? value) {
    listenableData.value = value;
  }
}

/// A [IndexedTreeNode] that can be used with the [IndexedTreeView].
///
/// To use your own custom data with [IndexedTreeView], wrap your model [T] in [IndexedTreeNode]
/// like this:
/// ```dart
///   class YourCustomNode extends IndexedTreeView<CustomClass> {
///   ...
///   }
/// ```
class IndexedTreeNode<T> extends IndexedListenableNode implements ITreeNode<T> {
  /// A [IndexedTreeNode] constructor that can be used with the [IndexedTreeView].
  /// Any data of type [T] can be wrapped with [IndexedTreeView]
  IndexedTreeNode({T? data, this.isExpanded = false, super.key, super.parent})
      : this.listenableData = ValueNotifier(data);

  /// Factory constructor to be used only for root [IndexedTreeNode]
  factory IndexedTreeNode.root({T? data}) =>
      IndexedTreeNode(key: INode.ROOT_KEY, data: data);

  /// [ValueNotifier] for data [T] that can be listened for data changes;
  final ValueNotifier<T?> listenableData;

  /// Shows whether the node is expanded or not
  @override
  bool isExpanded;

  /// The data value [T] of wrapped in the [IndexedTreeNode]
  @override
  T? get data => listenableData.value;

  /// The setter for data value [T] of wrapped in the [TreeNode].
  /// It will notify [listenableData] whenever the value is set.
  @override
  set data(T? value) {
    listenableData.value = value;
  }
}
