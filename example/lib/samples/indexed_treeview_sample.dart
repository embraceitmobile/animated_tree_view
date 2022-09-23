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
      title: 'Animated Indexed Tree View Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(
        title: 'Animated Indexed Tree View Demo',
      ),
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
  static const _showRootNode = true;
  late final tree = IndexedTreeNode.root();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TreeView.indexed(
              tree: IndexedTreeNode.root(),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              showRootNode: _showRootNode,
              builder: (context, level, item) =>
                  buildListItem(level, item as IndexedTreeNode),
            ),
            if (!_showRootNode)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ElevatedButton.icon(
                    onPressed: () => tree.add(IndexedTreeNode()),
                    icon: Icon(Icons.add),
                    label: Text("Add Node")),
              ),
            SizedBox(height: 32),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget buildListItem(int level, IndexedTreeNode item) {
    final color = colorMapper[level.clamp(0, colorMapper.length - 1)]!;
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ListTile(
              title: Text(
                "Item ${item.level}-${item.key}",
                style: TextStyle(color: color.byLuminance()),
              ),
              subtitle: Text(
                'Level $level',
                style: TextStyle(color: color.byLuminance().withOpacity(0.5)),
              ),
              trailing: !item.isRoot ? buildRemoveItemButton(item) : null,
            ),
            if (!item.isRoot)
              FittedBox(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    buildAddItemChildButton(item),
                    buildInsertAboveButton(item),
                    buildInsertBelowButton(item),
                  ],
                ),
              ),
            if (item.isRoot)
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  buildAddItemChildButton(item),
                  if (item.children.isNotEmpty) buildClearAllItemButton(item),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget buildAddItemChildButton(IndexedTreeNode item) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: TextButton.icon(
        style: TextButton.styleFrom(
          primary: Colors.green[800],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
        ),
        icon: Icon(Icons.add_circle, color: Colors.green),
        label: Text("Child", style: TextStyle(color: Colors.green)),
        onPressed: () => item.add(IndexedTreeNode()),
      ),
    );
  }

  Widget buildInsertAboveButton(IndexedTreeNode item) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: TextButton(
        style: TextButton.styleFrom(
          primary: Colors.green[800],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
        ),
        child: Text("Insert Above", style: TextStyle(color: Colors.green)),
        onPressed: () {
          item.parent?.insertBefore(item, IndexedTreeNode());
        },
      ),
    );
  }

  Widget buildInsertBelowButton(IndexedTreeNode item) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: TextButton(
        style: TextButton.styleFrom(
          primary: Colors.green[800],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
        ),
        child: Text("Insert Below", style: TextStyle(color: Colors.green)),
        onPressed: () {
          item.parent?.insertAfter(item, IndexedTreeNode());
        },
      ),
    );
  }

  Widget buildRemoveItemButton(IndexedTreeNode item) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: TextButton(
          style: TextButton.styleFrom(
            primary: Colors.red[800],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
          ),
          child: Icon(Icons.delete, color: Colors.red),
          onPressed: () => item.delete()),
    );
  }

  Widget buildClearAllItemButton(IndexedTreeNode item) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: TextButton.icon(
          style: TextButton.styleFrom(
            primary: Colors.red[800],
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
