# animated_tree_view

A flutter package that provides a heirarchial Tree like data structure that can be visualized as a linear list view.

The widget is based on the Flutter’s [AnimatedList](https://api.flutter.dev/flutter/widgets/AnimatedList-class.html) widget and can even be used as a replacement to the [AnimatedList](https://api.flutter.dev/flutter/widgets/AnimatedList-class.html). The widget data is completely customizable and provides an `LeveledItemWidgetBuilder`  to build the tree items.

![Animated Tree View Demo](https://media.giphy.com/media/LfGExvX5OG9Eg3CyRa/giphy.gif)

## Variants
There are two variants available in the package: the simple `TreeView` and the more comprehensive `IndexedTreeView`. 

### TreeView
The `TreeView` uses a [Map](https://api.dart.dev/stable/2.13.3/dart-core/Map-class.html) data-structure to handle the Nodes and their children, using a [Map](https://api.dart.dev/stable/2.13.3/dart-core/Map-class.html) makes the `TreeView` more performant with a complexity on traversing the Nodes being O(n), where n is the level of the node. However the simple `TreeView` lacks the indexed based operations like `insertAt` and `removeAt` operations.

### IndexedTreeView
The `IndexedTreeView` uses a [List](https://api.dart.dev/stable/2.10.5/dart-core/List-class.html) data-structure to handle the Nodes and their children. This allows it to perform all the list based operations that require indices, like `insertAt` or `removeAt`. The drawback of using an `IndexedTreeView` instead of `TreeView` is that the Node traversal operations on the `IndexedTreeView` are more expensive with a complexity of O(n^m), where n is the number of children in a node, and m is the node level.

## Features
* Infinite levels and child nodes.
* Animations for Node expansion and collapse.
* Familiar API due to inspiration from AnimatedList.
* Provides plenty of utility methods for adding, inserting and removing child nodes.
* Easily traverse the tree laterally or vertically from the root to the leaf and back.
* Implementation of ValueListenable makes it easy to listen to changes in the data.

## How to use
### TreeView
You can simply use the provided `SimpleNode` or extend your data object from `ListenableNode<T>` like this

```dart
class CustomNode extends ListenableNode<CustomNode> {
  CustomNode([String? key]) : super(key: key);
}
```
*Note: If the `key` is omitted, then a unique key will be automatically assigned to the Node.*

You can provide an optional `TreeListViewController<T>` and `initialItems` to the TreeListView if required. 

If no `initialItems` are provided to the `TreeView`, then the `TreeView` will only contain a Root-Node until some children are added to it.

Finally, initialize the `TreeView` by providing it a builder.

```dart
TreeListView<SimpleNode>(
    builder: (context, level, node) {
        // build your node item here
        // return any widget that you need
        return ListTile(
          title: Text("Item ${node.level}-${node.key}"),
          subtitle: Text('Level $level'),
        );
    }
                
```

### IndexedTreeView
The usage of `IndexedTreeView` is exactly the same as a simple `TreeView`. You only need to replace `SimpleNode` with `SimpleIndexedNode` or extend you `CustomNode` from `ListenableIndexedNode` like this

```dart
class CustomIndexedNode extends ListenableIndexedNode<CustomIndexedNode> {
  CustomIndexedNode([String? key]) : super(key: key);
}
```

Finally initialize the widget like this:

```dart
IndexedTreeListView<CustomIndexedNode>(
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

## Configuration and Behavior
Attributes              | Description
------------------------|-------------
builder                 | The builder function that is provided to the item builder. Called, as needed, to build list item widgets. The built widget is passed to the [AnimatedList](https://api.flutter.dev/flutter/widgets/AnimatedList-class.html)'s itemBuilder.
controller              | Allows controlling the [TreeView] programmatically using utility methods. Use `TreeViewController` for the `TreeView`, and `IndexedTreeViewController` for the `IndexedTreeView`.
initialItems            | Node that is used to populate the `TreeView` initially. If no `initialItems` are provided, then the Tree will only contain the RootNode.
scrollController        | Provide a scrollController for more granular control over scrolling behavior.
expansionIndicator      | Provide an `ExpansionIndicator` to set the expand widget and collapse widget. Typically these are [Icon](https://api.flutter.dev/flutter/widgets/Icon-class.html) widgets. You can pass in `null` if you do not want to show any expansion indicator.
indentPadding           | This is the padding is applied to the start of an item. `IndentPadding` will be multiplied by Node-Level before being applied. 
onItemTap               | callback that can be used to handle any action when an item is tapped or clicked.
showRootNode            | Flag to show the Root Node in the TreeView.
expansionBehavior       | The `ExpansionBehavior` provides control over the behavior of the node when it is expanded.
padding                 | The amount of space by which to inset the children.
primary                 | Whether this is the primary scroll view associated with the parent PrimaryScrollController.
physics                 | An object that can be used to control the position to which this scroll view is scrolled.
shrinkWrap              | Whether the extent of the scroll view in the `scrollDirection` should be determined by the contents being viewed.


## Available APIs
### Node
Method          | TreeView                | IndexedTreeView   | Description 
--------------- | ------------------------| ------------------| ------------
`isRoot`        | :white_check_mark:      | :white_check_mark:|Getter to check if the node is a root
`isLeaf`        | :white_check_mark:      | :white_check_mark:|Getter to check if the node is a Leaf
`root` (getter) | :white_check_mark:      | :white_check_mark:|Getter to get the root node. If the current node is not a root, then the getter will traverse up the path to get the root.
`level`         | :white_check_mark:      | :white_check_mark:| Getter to get the level i.e. how many iterations it will take to get to the root.
`elementAt`     | :white_check_mark:      | :white_check_mark:| Utility method to get a child any child node at the path. The path contains the keys of the node separated by period `.` e.g. #grandparent_key.#parent_key.#node
`add`           | :white_check_mark:      | :white_check_mark:| Add a child to the node
`addAll`        | :white_check_mark:      | :white_check_mark:| Add a collection of nodes to the node
`remove`        | :white_check_mark:      | :white_check_mark:| Remove a child from the node
`removeAll`     | :white_check_mark:      | :white_check_mark:| Remove a collection of nodes from the node
`removeWhere`   | :white_check_mark:      | :white_check_mark:| Remove children from the node that meet the criterion in the provided test
`delete`        | :white_check_mark:      | :white_check_mark:| Delete the current node
`clear`         | :white_check_mark:      | :white_check_mark:| Remove all the child nodes: after this operation the children are empty
`first`         | :o:                     | :white_check_mark:| Get/Set first child in the node
`last`          | :o:                     | :white_check_mark:| Get/Set last child in the node
`insert`        | :o:                     | :white_check_mark:| Insert a child at an index in the node
`insertAll`     | :o:                     | :white_check_mark:| Insert a list of children at an index in the node
`insertAfter`   | :o:                     | :white_check_mark:| Insert a child after the node
`insertBefore`  | :o:                     | :white_check_mark:| Insert a child before the node
`removeAt`      | :o:                     | :white_check_mark:| Remove a child at the index
`firstWhere`    | :o:                     | :white_check_mark:| Get the first child node that matches the criterion in the test.
`lastWhere`     | :o:                     | :white_check_mark:| Get the last child node that matches the criterion in the test.
`indexWhere`    | :o:                     | :white_check_mark:| Get the index of the first child node that matches the criterion in the test.

### TreeViewController
The `TreeViewController` provides utility methods that allow controlling the [TreeView] programmatically. 

There are two different `TreeViewController`s for the two variants of `TreeView`. Namely the `TreeViewController` for `TreeView`, and the `IndexedTreeViewController` for `IndexedTreeView`

Method                    | Description
--------------------------| -----------
elementAt                 | Get any item at path from the root. The keys  of the items to be traversed should be provided in the path
root                      | Root node of the TreeView
scrollToIndex             | Allows to scroll to any item with index in the list. If you do not have the index of the item, then use the alternate scrollToItem method item instead.
scrollToItem              | Utility method to scroll to any visible item in the tree.
toggleNodeExpandCollapse  |  Utility method to expand or collapse an item.


## Future Goals
* [ ] Improve documentation
* [ ] Add more examples
* [ ] Add more utility functions for Node
* [ ] Add a `DiffUtil` to the controller to update the whole tree data more easily

## Development Status
This library is under development. We are trying to provide you a performant and easy to use library, however at this stage we cannot guarantee a bug free experience. Please feel free to equest any feature or report any issues that you may face.