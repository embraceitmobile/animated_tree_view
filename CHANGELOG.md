## [1.1.0]
* Added support for slivers with SliverTreeView
* Fixed issues [#8](https://github.com/embraceitmobile/animated_tree_view/issues/8), [#9](https://github.com/embraceitmobile/animated_tree_view/issues/9)
* Improved documentation 

## [1.0.0]
* First stable release
* ### Changes
* **Breaking:** 
  * [initialItem] param changed to tree in [TreeView].
  * [TreeViewController] is removed from the params list, and can now be accessed using the [GlobalKey] instead.
  * Default TreeView constructor changed to [TreeView.simple]
  * [IndexedTreeView] class removed, and replaced with [TreeView.indexed]
* ### Added
* [TreeDiffUtil] added to update the tree view if the tree is updated using any state management tool.
* [TreeView.simpleTyped] and [TreeView.indexTyped] static constructors
* More samples are added in example

## [0.1.2]
* Update scroll_to_index package to latest version  to support Flutter 3.0
* Update examples to Flutter 3.0

## [0.1.1]
* Add collapseOthers and collapseOthersAndSnapToTop expansion behaviors

## [0.1.0+1]
* Update the public APIs

## [0.1.0]

* Publish the packages to pub.dev
