import 'package:animated_tree_view/animated_tree_view.dart';

class SimpleNode extends ListenableNode<SimpleNode> {
  /// A [SimpleNode] that can be used with the [TreeView].
  ///
  /// To use your own custom data with [TreeView], extend the [ListenableNode]
  /// like this:
  /// ```dart
  ///   class YourCustomNode extends ListenableNode<YourCustomNode> {
  ///   ...
  ///   }
  /// ```
  SimpleNode([String? key]) : super(key: key);

  factory SimpleNode.root() => SimpleNode(INode.ROOT_KEY);
}

class SimpleIndexedNode extends ListenableIndexedNode<SimpleIndexedNode> {
  /// A [SimpleIndexedNode] that can be used with the [IndexedTreeView].
  ///
  /// To use your own custom data with [IndexedTreeView], extend the [ListenableIndexedNode]
  /// like this:
  /// ```dart
  ///   class YourCustomIndexedNode extends ListenableIndexedNode<YourCustomIndexedNode> {
  ///   ...
  ///   }
  /// ```
  SimpleIndexedNode([String? key]) : super(key: key);

  factory SimpleIndexedNode.root() => SimpleIndexedNode(INode.ROOT_KEY);
}
