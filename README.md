# animated_tree_view

A flutter package that provides a heirarchial Tree like data structure that can be visualized as a linear list view.

The widget is based on the Flutter’s [AnimatedList](https://api.flutter.dev/flutter/widgets/AnimatedList-class.html) widget and can even be used as a replacement to the [AnimatedList](https://api.flutter.dev/flutter/widgets/AnimatedList-class.html). The widget data is completely customizable and provides an `LeveledItemWidgetBuilder`  to build the tree items.

![Animated Tree View Demo](https://media.giphy.com/media/HMR9U5wfx3jPX1lIg3/giphy.gif)

## Implementations
There are two implementations for the `AnimatedTreeView`, the simple `TreeView` and the more comprehensive `IndexedTreeView`. 

### TreeView
The `TreeView` uses a [Map](https://api.dart.dev/stable/2.13.3/dart-core/Map-class.html) data-structure to handle the Nodes and their children, using a [Map](https://api.dart.dev/stable/2.13.3/dart-core/Map-class.html) makes the `TreeView` more performant with a complexity on traversing the Nodes being O(n), where n is the level of the node. However the simple `TreeView` lacks the indexed based operations like `insertAt` and `removeAt` operations.

### IndexedTreeView
The `IndexedTreeView` uses a [List](https://api.dart.dev/stable/2.10.5/dart-core/List-class.html) data-structure to handle the Nodes and their children. This allows it to perform all the list based operations that require indices, like `insertAt` or `removeAt`. The drawback of using an `IndexedTreeView` instead of `TreeView` is that the Node traversal operations on the `IndexedTreeView` are more expensive with a complexity of O(n^m), where n is the number of children in a node, and m is the node level.

## Features
* Infinite levels and child nodes.
* Animations for Node expansion and collapse.
* Familiar API due to inspiration from AnimatedList.
* Provides plenty of utility methods for adding, inserting and removing child nodes.
* Implementation of ValueListenable makes it easy to listen to changes in the data.

## Usage
### TreeView
Extend your data object from `ListenableNode<T>` like
```dart
class CustomNode extends ListenableNode<CustomNode> {
  CustomNode([String? key]) : super(key: key);
}
```
*Note: If the `key` is omitted, then a unique key will be automatically assigned to the Node.*

You will also need to provide a `TreeListViewController<T>` to the TreeListView. You can provide the `TreeListViewController` with an optional set of initial items if required. If no `initialItems` are provided to the controller, then the `TreeView` will only contain a Root-Node until some children are added to it.

Finally, initialize the `TreeView` by providing it a builder.

```dart
TreeListView<RowItem>(
    controller: controller,
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
The usage of `IndexedTreeView` is exactly the same as a simple `TreeView`. You only need to replace `ListenableNode` with `ListenableIndexedNode` to extend your `CustomData` like this

```dart
class CustomNode extends ListenableIndexedNode<CustomNode> {
  CustomNode([String? key]) : super(key: key);
}
```
The controller provided will be of the type `IndexedTreeListViewController`.
Finally initialize the widget like this:

```dart
IndexedTreeListView<RowItem>(
    controller: controller,
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


## Available APIs
Method          | TreeView | IndexedTreeView
--------------- | -------- | ---------------
`isRoot`        | [x]      | [x]
`isLeaf`        | [x]      | [x]
`root` (getter) | [x]      | [x]
`elementAt`     | [x]      | [x]
`add`           | [x]      | [x]
`addAll`        | [x]      | [x]
`remove`        | [x]      | [x]
`removeAll`     | [x]      | [x]
`removeWhere`   | [x]      | [x]
`delete`        | [x]      | [x]
`clear`         | [x]      | [x]
`first`         | [ ]      | [x]
`last`          | [ ]      | [x]
`insert`        | [ ]      | [x]
`insertAll`     | [ ]      | [x]
`insertAfter`   | [ ]      | [x]
`insertBefore`  | [ ]      | [x]
`removeAt`      | [ ]      | [x]
`firstWhere`    | [ ]      | [x]
`lastWhere`     | [ ]      | [x]
`indexWhere`    | [ ]      | [x]


## Development Status
This library is under development. We are trying to provide you a performant and easy to use library, however at this stage we cannot guarantee a bug free experience. Please feel free to equest any feature or report any issues that you may face.

## Future Goals
* [ ] Improve documentation
* [ ] Add a `DiffUtil` to the controller to update the whole tree data more easily











