import 'package:animated_tree_view/src/controllers/animated_list_controller.dart';
import 'package:animated_tree_view/src/listenable_node/base/i_listenable_node.dart';
import 'package:animated_tree_view/src/listenable_node/listenable_indexed_node.dart';
import 'package:animated_tree_view/src/listenable_node/listenable_node.dart';
import 'package:animated_tree_view/src/node/base/i_node.dart';
import 'package:animated_tree_view/src/node/indexed_node.dart';
import 'package:animated_tree_view/src/node/node.dart';
import 'package:flutter/material.dart';

class TreeListViewController<T extends Node<T>>
    extends ITreeListViewController<T> {
  TreeListViewController();

  /// Get any item at [path] from the [root]
  /// see [ITreeListViewController.elementAt] for details
  ListenableNode<T> elementAt(String path) =>
      super.elementAt(path) as ListenableNode<T>;

  /// Root node of the tree
  ListenableNode<T> get root => super.root as ListenableNode<T>;
}

class IndexedTreeListViewController<T extends IndexedNode<T>>
    extends ITreeListViewController<T> {
  IndexedTreeListViewController();

  /// Get any item at [path] from the [root]
  /// see [ITreeListViewController.elementAt] for details
  ListenableIndexedNode<T> elementAt(String path) =>
      super.elementAt(path) as ListenableIndexedNode<T>;

  /// Root node of the tree
  ListenableIndexedNode<T> get root => super.root as ListenableIndexedNode<T>;
}

abstract class ITreeListViewController<T extends INode<T>> {
  late final AnimatedListController<T> animatedListController;
  late final IListenableNode<T> root;

  ITreeListViewController();

  @protected
  void attach(IListenableNode<T> root,
      AnimatedListController<T> animatedListController) {
    this.root = root;
    this.animatedListController = animatedListController;
  }

  /// Get any item at [path] from the [root]
  /// The keys of the items to be traversed should be provided in the [path]
  ///
  /// For example in a TreeView like this
  ///
  /// ```dart
  /// Node get mockNode1 => Node.root()
  ///   ..addAll([
  ///     Node(key: "0A")..add(Node(key: "0A1A")),
  ///     Node(key: "0B"),
  ///     Node(key: "0C")
  ///       ..addAll([
  ///         Node(key: "0C1A"),
  ///         Node(key: "0C1B"),
  ///         Node(key: "0C1C")
  ///           ..addAll([
  ///             Node(key: "0C1C2A")
  ///               ..addAll([
  ///                 Node(key: "0C1C2A3A"),
  ///                 Node(key: "0C1C2A3B"),
  ///                 Node(key: "0C1C2A3C"),
  ///               ]),
  ///           ]),
  ///       ]),
  ///   ]);
  ///```
  ///
  /// In order to access the Node with key "0C1C", the path would be
  ///   0C.0C1C
  ///
  INode<T> elementAt(String path) => root.elementAt(path);

  /// Allows to scroll to any item with [index] in the list.
  /// If you do not have the [index] of the item, then use the alternate
  /// [scrollToItem] item instead
  Future scrollToIndex(int index) async =>
      animatedListController.scrollToIndex(index);

  /// Utility method to scroll to any visible [item] in the tree.
  /// An exception maybe thrown, if the item is not visible, that is, it's
  /// parent node is not expanded,
  Future scrollToItem(T item) async =>
      animatedListController.scrollToItem(item);

  /// Utility method to expand or collapse an item.
  void toggleNodeExpandCollapse(T item) =>
      animatedListController.toggleExpansion(item);
}
