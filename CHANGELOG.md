## [2.1.0]
* Fix [#15](https://github.com/embraceitmobile/animated_tree_view/issues/15): nodes duplicate on calling expand or expandAllChildren method from TreeViewController
* Add support for onTreeReady callback
* Update the package to Dart 3.0

## [2.0.1]
* Fix the indentation screenshot links in readme.md

## [2.0.0]
* ### Added
* Add support for indentation and scoping lines
* Add animated expansion indicators
* Add more expand/collapse utility methods to TreeViewController [#5](https://github.com/embraceitmobile/animated_tree_view/issues/5)
* New samples
* ### Changes
* **Breaking:**
  * [expansionIndicator] param replaced with [expansionIndicatorBuilder]
  * [indentPadding] param moved to [indentation] as [width]
  * [level] removed from [TreeNodeWidgetBuilder], it can still be accessed as [node.level]
* ### Improvements
* Simplified APIs
* Improved documentation

## [1.1.1+1]
* Reformat code with dart formatter

## [1.1.1]
* Formatting updates for static analysis checks
* Screenshot update to png format

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
