import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:example/utils/utils.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Indexed TreeView Modification Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(
        title: 'Indexed TreeView Modification Demo',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

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
              physics: const NeverScrollableScrollPhysics(),
              showRootNode: _showRootNode,
              indentation: Indentation(
                style: IndentStyle.roundJoint,
              ),
              builder: buildListItem,
            ),
            if (!_showRootNode)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ElevatedButton.icon(
                    onPressed: () => tree.add(IndexedTreeNode()),
                    icon: const Icon(Icons.add),
                    label: const Text("Add Node")),
              ),
            const SizedBox(height: 32),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget buildListItem(BuildContext context, IndexedTreeNode node) {
    final color = colorMapper[node.level.clamp(0, colorMapper.length - 1)]!;
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
                "Item ${node.level} - ${node.key}",
                style: TextStyle(color: color.byLuminance()),
              ),
              subtitle: Text(
                'Level ${node.level}',
                style: TextStyle(color: color.byLuminance().withOpacity(0.5)),
              ),
              trailing: !node.isRoot ? buildRemoveItemButton(node) : null,
            ),
            if (!node.isRoot)
              FittedBox(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    buildAddItemChildButton(node),
                    buildInsertAboveButton(node),
                    buildInsertBelowButton(node),
                  ],
                ),
              ),
            if (node.isRoot)
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  buildAddItemChildButton(node),
                  if (node.children.isNotEmpty) buildClearAllItemButton(node),
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
          foregroundColor: Colors.green[800],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
        ),
        icon: const Icon(Icons.add_circle, color: Colors.green),
        label: const Text("Child", style: TextStyle(color: Colors.green)),
        onPressed: () => item.add(IndexedTreeNode(key: UniqueKey().toString())),
      ),
    );
  }

  Widget buildInsertAboveButton(IndexedTreeNode item) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Colors.green[800],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
        ),
        child:
            const Text("Insert Above", style: TextStyle(color: Colors.green)),
        onPressed: () {
          item.parent?.insertBefore(item, IndexedTreeNode(key: UniqueKey().toString()));
        },
      ),
    );
  }

  Widget buildInsertBelowButton(IndexedTreeNode item) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Colors.green[800],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
        ),
        child:
            const Text("Insert Below", style: TextStyle(color: Colors.green)),
        onPressed: () {
          item.parent?.insertAfter(item, IndexedTreeNode(key: UniqueKey().toString()));
        },
      ),
    );
  }

  Widget buildRemoveItemButton(IndexedTreeNode item) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.red[800],
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
          ),
          child: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => item.delete()),
    );
  }

  Widget buildClearAllItemButton(IndexedTreeNode item) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: TextButton.icon(
          style: TextButton.styleFrom(
            foregroundColor: Colors.red[800],
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
          ),
          icon: const Icon(Icons.delete, color: Colors.red),
          label: const Text("Clear All", style: TextStyle(color: Colors.red)),
          onPressed: () => item.clear()),
    );
  }
}
