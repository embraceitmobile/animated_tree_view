# animated_tree_view

A flutter package that provides a heirarchial Tree like data structure that can be visualized as a linear list view.

The widget is based on the Flutter’s [AnimatedList](https://api.flutter.dev/flutter/widgets/AnimatedList-class.html) widget and can even be used as a replacement to the [AnimatedList](https://api.flutter.dev/flutter/widgets/AnimatedList-class.html). The widget data is completely customizable and provides an `LeveledItemWidgetBuilder`  to build the tree items.

![Animated Tree View Demo](https://media.giphy.com/media/LfGExvX5OG9Eg3CyRa/giphy.gif)

## Variants
There are two variants available in the package: the simple `TreeView` and the more comprehensive `TreeView.indexed`. A sliver variant is also available as `SliverTreeView`.

### TreeView.simple
The `TreeView` uses a [Map](https://api.dart.dev/stable/2.13.3/dart-core/Map-class.html) data-structure to handle the Nodes and their children, using a [Map](https://api.dart.dev/stable/2.13.3/dart-core/Map-class.html) makes the `TreeView` more performant with a complexity on traversing the Nodes being O(n), where n is the level of the node. However the simple `TreeView` lacks the indexed based operations like `insertAt` and `removeAt` operations.

### TreeView.indexed
The `TreeView.indexed` uses a [List](https://api.dart.dev/stable/2.10.5/dart-core/List-class.html) data-structure to handle the Nodes and their children. This allows it to perform all the list based operations that require indices, like `insertAt` or `removeAt`. The drawback of using an `TreeView.indexed` instead of `TreeView` is that the Node traversal operations on the `TreeView.indexed` are more expensive with a complexity of O(n^m), where n is the number of children in a node, and m is the node level.

### SliverTreeView
For implementing fancy lists and animations using [slivers](https://docs.flutter.dev/development/ui/advanced/slivers), `SliverTreeView` should be used. It is based on the [SliverAnimatedList](https://api.flutter.dev/flutter/widgets/SliverAnimatedList-class.html). It provides the same APIs as the normal `TreeView` and its usage is also the same. Slivers also provide significant performance improvements over the regular lists, to get to know more about slivers [see here](https://docs.flutter.dev/development/ui/advanced/slivers).

## Features
* Infinite levels and child nodes.
* Animations for Node expansion and collapse.
* Familiar API due to inspiration from AnimatedList.
* Provides plenty of utility methods for adding, inserting and removing child nodes.
* Easily traverse the tree laterally or vertically from the root to the leaf and back.
* Tree Diff Util to compute the difference between two trees, and automatically apply the changes in the tree view.
* Implementation of ValueListenable makes it easy to listen to changes in the data.

## How to use
### TreeView
You can simply use the provided `TreeNode` or extend your data object from `TreeNode<T>` like this

To use your own custom data with [TreeView], wrap your model [T] in [TreeNode] like this:
```dart
   class YourCustomNode extends TreeNode<CustomClass> {
   ...
   }
```
*Note: If the `key` is omitted, then a unique key will be automatically assigned to the Node.*

Finally, initialize the `TreeView` by providing it a builder.

```dart
TreeView.simple(
    tree: TreeNode.root(),
    builder: (context, level, node) {
        // build your node item here
        // return any widget that you need
        return ListTile(
          title: Text("Item ${node.level}-${node.key}"),
          subtitle: Text('Level $level'),
        );
    }
                
```

### TreeView.indexed
The usage of `TreeView.indexed` is exactly the same as a simple `TreeView`. You only need to replace `TreeNode` with `IndexedTreeNode` or extend your `YourCustomNode` from `IndexedTreeNode` like this

```dart
   class YourCustomNode extends IndexedTreeNode<CustomClass> {
   ...
   }
```

Finally initialize the widget like this:

```dart
TreeView.indexed(
    tree: IndexedTreeNode.root(),
    builder: (context, level, node) {
        // build your node item here
        // return any widget that you need
        return ListTile(
          title: Text("Item ${node.level}-${node.key}"),
          subtitle: Text('Level $level'),
        );
    }
                
```

*Please see this [example](https://github.com/embraceitmobile/animated_tree_view/blob/main/example/lib/main.dart) for a more comprehsive code sample.*

## SliverTreeView
The API and usage of `SliverTreeView` is the same as `TreeView`. You just need to wrap the `SliverTreeView`
inside a `CustomScrollView` and provide it a `Tree` and a builder.

```dart
CustomScrollView(
    slivers: [
      SliverTreeView.simple(
        tree: TreeNode.root(),
        builder: (context, level, node) {
          // build your node item here
          // return any widget that you need
          return ListTile(
            title: Text("Item ${node.level}-${node.key}"),
            subtitle: Text('Level $level'),
          );
        },
      ),
    ],
  );
```

## Configuration and Behavior
| Attributes         | Description                                                                                                                                                                                                                                                                         |
|--------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| builder            | The builder function that is provided to the item builder. Called, as needed, to build list item widgets. The built widget is passed to the [AnimatedList](https://api.flutter.dev/flutter/widgets/AnimatedList-class.html)'s itemBuilder.                                          |
| tree               | Tree that is used to populate the `TreeView`. If the `tree` is updated using any state management tools like setState or Bloc, then the [TreeDiffUtil](#treeDiffUtil) is used to get the diff between the two trees, and apply all the changes from the new tree onto the old tree. |
| scrollController   | Provide a scrollController for more granular control over scrolling behavior.                                                                                                                                                                                                       |
| expansionIndicator | Provide an `ExpansionIndicator` to set the expand widget and collapse widget. Typically these are [Icon](https://api.flutter.dev/flutter/widgets/Icon-class.html)  widgets. You can pass in `null` if you do not want to show any expansion indicator.                              |
| indentPadding      | This is the padding is applied to the start of an item. `IndentPadding` will be multiplied by Node-Level before being applied.                                                                                                                                                      |
| onItemTap          | callback that can be used to handle any action when an item is tapped or clicked.                                                                                                                                                                                                   |
| showRootNode       | Flag to show the Root Node in the TreeView.                                                                                                                                                                                                                                         |
| expansionBehavior  | The `ExpansionBehavior` provides control over the behavior of the node when it is expanded. See [ExpansionBehavior](#expansionBehavior) for available behaviors.                                                                                                                    |
| padding            | The amount of space by which to inset the children.                                                                                                                                                                                                                                 |
| primary            | Whether this is the primary scroll view associated with the parent PrimaryScrollController.                                                                                                                                                                                         |
| physics            | An object that can be used to control the position to which this scroll view is scrolled.                                                                                                                                                                                           |
| shrinkWrap         | Whether the extent of the scroll view in the `scrollDirection` should be determined by the contents being viewed.                                                                                                                                                                   |

## ExpansionBehavior <a name="expansionBehavior"></a>
The 'ExpansionBehavior' provides control over the behavior of the node when it is expanded.
There are five available ExpansionBehaviors to choose from.

**Note: For using an `ExpansionBehavior` with a `SliverTreeView`, the same instance of an [AutoScrollController](https://pub.dev/documentation/scroll_to_index/latest/scroll_to_index/AutoScrollController-class.html)
needs to be provided to `SliverTreeView` and the `CustoScrollView`.

### `ExpansionBehavior.none` 
No additional action will be taken on node expansion.

![ExpansionBehavior.none](https://media.giphy.com/media/GA0MIRgxg2checWuVT/giphy.gif)

### `ExpansionBehavior.scrollToLastChild`
The list will be scrolled to the last child of the node if it is not already visible on screen. This ensures that the last child is always visible. 

![ExpansionBehavior.scrollToLastChild](https://media.giphy.com/media/hV0Bvgl7UvJyfl7j6I/giphy.gif)


### `ExpansionBehavior.snapToTop`
The expanded node will be snapped to the top of the list. This ensures that the expanded node is always visible with maximum number of children.

![ExpansionBehavior.snapToTop](https://media.giphy.com/media/eRRmOAErM9ZJhe5IuG/giphy.gif)

### `ExpansionBehavior.collapseOthers`
Collapse all other nodes, only the current node will remain expanded. This ensures that only one node is expanded at one time.

![ExpansionBehavior.collapseOthers](https://media.giphy.com/media/zW1e4X81bZOloyB1JI/giphy.gif)

### `ExpansionBehavior.collapseOthersAndSnapToTop`
Collapse all other nodes, only the current node will remain expanded, also snap the node to the top of the list. This ensures that only one node is expanded at one time.

![ExpansionBehavior.collapseOthersAndSnapToTop](https://media.giphy.com/media/YDOKCA8EmaRxuOFDTQ/giphy.gif)

## Tree Diff Util <a name="treeDiffUtil"></a>
A `TreeDiffUtil` is used to determine the difference between two trees if the `tree` is udpated using any state management tool like setState or Bloc etc.

For `TreeView.simple`, which uses a `Map` internally to store the child nodes, this is a simple difference operation on all the nodes of the tree. Complexity is O(2n), where n is the total number of nodes in the tree.

For `TreeView.indexed`, which uses a `List` internally to store the child nodes, it is a little more complex as Myer's algorithm is used to determine the difference in the children of each respective node. Complexity is O(N + D^2), where D is the length of the edit script. For more details see [diffutil_dart](https://pub.dev/packages/diffutil_dart).

## Available APIs
### Node
| Method          | TreeView           | IndexedTreeView    | Description                                                                                                                   | 
|-----------------|--------------------|--------------------|-------------------------------------------------------------------------------------------------------------------------------|
| `isRoot`        | :white_check_mark: | :white_check_mark: | Getter to check if the node is a root                                                                                         |
| `isLeaf`        | :white_check_mark: | :white_check_mark: | Getter to check if the node is a Leaf                                                                                         |
| `root` (getter) | :white_check_mark: | :white_check_mark: | Getter to get the root node. If the current node is not a root, then the getter will traverse up the path to get the root.    |
| `level`         | :white_check_mark: | :white_check_mark: | Getter to get the level i.e. how many iterations it will take to get to the root.                                             |
| `elementAt`     | :white_check_mark: | :white_check_mark: | Utility method to get a child any child node at the path. The path contains the keys of the node separated by period `.` e.g. |#grandparent_key.#parent_key.#node|
| `add`           | :white_check_mark: | :white_check_mark: | Add a child to the node                                                                                                       |
| `addAll`        | :white_check_mark: | :white_check_mark: | Add a collection of nodes to the node                                                                                         |
| `remove`        | :white_check_mark: | :white_check_mark: | Remove a child from the node                                                                                                  |
| `removeAll`     | :white_check_mark: | :white_check_mark: | Remove a collection of nodes from the node                                                                                    |
| `removeWhere`   | :white_check_mark: | :white_check_mark: | Remove children from the node that meet the criterion in the provided test                                                    |
| `delete`        | :white_check_mark: | :white_check_mark: | Delete the current node                                                                                                       |
| `clear`         | :white_check_mark: | :white_check_mark: | Remove all the child nodes: after this operation the children are empty                                                       |
| `first`         | :o:                | :white_check_mark: | Get/Set first child in the node                                                                                               |
| `last`          | :o:                | :white_check_mark: | Get/Set last child in the node                                                                                                |
| `insert`        | :o:                | :white_check_mark: | Insert a child at an index in the node                                                                                        |
| `insertAll`     | :o:                | :white_check_mark: | Insert a list of children at an index in the node                                                                             |
| `insertAfter`   | :o:                | :white_check_mark: | Insert a child after the node                                                                                                 |
| `insertBefore`  | :o:                | :white_check_mark: | Insert a child before the node                                                                                                |
| `removeAt`      | :o:                | :white_check_mark: | Remove a child at the index                                                                                                   |
| `firstWhere`    | :o:                | :white_check_mark: | Get the first child node that matches the criterion in the test.                                                              |
| `lastWhere`     | :o:                | :white_check_mark: | Get the last child node that matches the criterion in the test.                                                               |
| `indexWhere`    | :o:                | :white_check_mark: | Get the index of the first child node that matches the criterion in the test.                                                 |

### TreeViewController
The `TreeViewController` provides utility methods that allow controlling the `TreeView` programmatically. 

| Method          | Description                                                                                                                                             |
|-----------------|---------------------------------------------------------------------------------------------------------------------------------------------------------|
 | elementAt       | Get any item at path from the root. The keys  of the items to be traversed should be provided in the path                                               |
 | root            | Root node of the TreeView                                                                                                                               |
 | scrollToIndex   | Allows to scroll to any item with index in the list. If you do not have the index of the item, then use the alternate scrollToItem method item instead. |
 | scrollToItem    | Utility method to scroll to any visible item in the tree.                                                                                               |
 | toggleExpansion | Utility method to expand or collapse an item.                                                                                                           |
