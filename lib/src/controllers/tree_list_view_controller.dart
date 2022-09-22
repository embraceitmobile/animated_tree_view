// import 'package:animated_tree_view/src/controllers/animated_list_controller.dart';
// import 'package:animated_tree_view/src/listenable_node/base/i_listenable_node.dart';
// import 'package:animated_tree_view/src/listenable_node/indexed_listenable_node.dart';
// import 'package:animated_tree_view/src/listenable_node/listenable_node.dart';
// import 'package:animated_tree_view/src/node/base/i_node.dart';
// import 'package:animated_tree_view/src/node/indexed_node.dart';
// import 'package:animated_tree_view/src/node/node.dart';
// import 'package:animated_tree_view/src/tree_node/tree_node.dart';
// import 'package:flutter/material.dart';
//
// class TreeViewController<T extends Node<T>> extends ITreeViewController<T> {
//   TreeViewController();
//
//   /// Get any item at [path] from the [root]
//   /// see [ITreeViewController.elementAt] for details
//   ListenableNode<T> elementAt(String path) =>
//       super.elementAt(path) as ListenableNode<T>;
//
//   /// Root node of the tree
//   ListenableNode<T> get root => super.root as ListenableNode<T>;
// }
//
// class IndexedTreeViewController<T extends IndexedNode<T>>
//     extends ITreeViewController<T> {
//   IndexedTreeViewController();
//
//   /// Get any item at [path] from the [root]
//   /// see [ITreeViewController.elementAt] for details
//   IndexedListenableNode<T> elementAt(String path) =>
//       super.elementAt(path) as IndexedListenableNode<T>;
//
//   /// Root node of the tree
//   IndexedListenableNode<T> get root => super.root as IndexedListenableNode<T>;
// }
//
// abstract class ITreeViewController<T extends ITreeNode<INode<T>>> {
//   @protected
//   late final AnimatedListController<T> animatedListController;
//
//   /// Root node of the TreeView
//   late final IListenableNode<T> root;
//
//   ITreeViewController();
//
//   @protected
//   void attach(IListenableNode<T> root,
//       AnimatedListController<T> animatedListController) {
//     this.root = root;
//     this.animatedListController = animatedListController;
//   }
//
//   /// Get any item at [path] from the [root]
//   /// The keys of the items to be traversed should be provided in the [path]
//   ///
//   /// For example in a TreeView like this
//   ///
//   /// ```dart
//   /// Node get mockNode1 => Node.root()
//   ///   ..addAll([
//   ///     Node(key: "0A")..add(Node(key: "0A1A")),
//   ///     Node(key: "0B"),
//   ///     Node(key: "0C")
//   ///       ..addAll([
//   ///         Node(key: "0C1A"),
//   ///         Node(key: "0C1B"),
//   ///         Node(key: "0C1C")
//   ///           ..addAll([
//   ///             Node(key: "0C1C2A")
//   ///               ..addAll([
//   ///                 Node(key: "0C1C2A3A"),
//   ///                 Node(key: "0C1C2A3B"),
//   ///                 Node(key: "0C1C2A3C"),
//   ///               ]),
//   ///           ]),
//   ///       ]),
//   ///   ]);
//   ///```
//   ///
//   /// In order to access the Node with key "0C1C", the path would be
//   ///   0C.0C1C
//   ///
//   /// Note: The root node [ROOT_KEY] does not need to be in the path
//   INode<T> elementAt(String path) => root.elementAt(path);
//
//   /// Allows to scroll to any item with [index] in the list.
//   /// If you do not have the [index] of the item, then use the alternate
//   /// [scrollToItem] item instead
//   Future scrollToIndex(int index) async =>
//       animatedListController.scrollToIndex(index);
//
//   /// Utility method to scroll to any visible [item] in the tree.
//   /// An exception maybe thrown, if the item is not visible, that is, it's
//   /// parent node is not expanded,
//   Future scrollToItem(T item) async =>
//       animatedListController.scrollToItem(item);
//
//   /// Utility method to expand or collapse an item.
//   void toggleNodeExpandCollapse(T item) =>
//       animatedListController.toggleExpansion(item);
// }
