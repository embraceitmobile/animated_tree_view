import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:example/utils/utils.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TreeView Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'TreeView Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: TreeView.simple(
        tree: TreeNode.root(),
        expansionBehavior: ExpansionBehavior.scrollToLastChild,
        shrinkWrap: true,
        showRootNode: true,
        builder: (context, node) =>
            node.isRoot ? buildRootItem(node) : buildListItem(node),
      ),
    );
  }

  Widget buildRootItem(TreeNode node) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ListTile(
              title: Text("Item ${node.level}-${node.key}"),
              subtitle: Text('Level ${node.level}'),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildAddItemChildButton(node),
                if (node.children.isNotEmpty) buildClearAllItemButton(node)
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildListItem(TreeNode node) {
    return Card(
      color: colorMapper[node.level.clamp(0, colorMapper.length - 1)]!,
      child: ListTile(
        title: Text("Item ${node.level}-${node.key}"),
        subtitle: Text('Level ${node.level}'),
        dense: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildRemoveItemButton(node),
            buildAddItemButton(node),
          ],
        ),
      ),
    );
  }

  Widget buildAddItemButton(TreeNode item) {
    return IconButton(
      onPressed: () => item.add(TreeNode()),
      icon: Icon(Icons.add_circle, color: Colors.green),
    );
  }

  Widget buildRemoveItemButton(TreeNode item) {
    return IconButton(
      onPressed: () => item.delete(),
      icon: Icon(Icons.delete, color: Colors.red),
    );
  }

  Widget buildAddItemChildButton(TreeNode item) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: TextButton.icon(
        style: TextButton.styleFrom(
          foregroundColor: Colors.green[800],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
        ),
        icon: Icon(Icons.add_circle, color: Colors.green),
        label: Text("Add Child", style: TextStyle(color: Colors.green)),
        onPressed: () => item.add(TreeNode()),
      ),
    );
  }

  Widget buildClearAllItemButton(TreeNode item) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: TextButton.icon(
          style: TextButton.styleFrom(
            foregroundColor: Colors.red[800],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
          ),
          icon: Icon(Icons.delete, color: Colors.red),
          label: Text("Clear All", style: TextStyle(color: Colors.red)),
          onPressed: () => item.clear()),
    );
  }
}
