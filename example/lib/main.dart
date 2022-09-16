import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:flutter/material.dart';

import 'utils/utils.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Animated Tree Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Simple Animated Tree Demo'),
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
  final controller = TreeViewController<SimpleNode>();
  final globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: TreeView<SimpleNode>(
        tree: SimpleNode("#00-Root-Item"),
        controller: controller,
        expansionBehavior: ExpansionBehavior.collapseOthersAndSnapToTop,
        shrinkWrap: true,
        builder: (context, level, item) => item.isRoot
            ? buildRootItem(level, item)
            : buildListItem(level, item),
      ),
    );
  }

  Widget buildRootItem(int level, SimpleNode item) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ListTile(
              title: Text("Item ${item.level}-${item.key}"),
              subtitle: Text('Level $level'),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildAddItemChildButton(item),
                if (item.children.isNotEmpty) buildClearAllItemButton(item)
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildListItem(int level, SimpleNode item) {
    return Card(
      color: colorMapper[level.clamp(0, colorMapper.length - 1)]!,
      child: ListTile(
        title: Text("Item ${item.level}-${item.key}"),
        subtitle: Text('Level $level'),
        dense: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildRemoveItemButton(item),
            buildAddItemButton(item),
          ],
        ),
      ),
    );
  }

  Widget buildAddItemButton(SimpleNode item) {
    return IconButton(
      onPressed: () => item.add(SimpleNode()),
      icon: Icon(Icons.add_circle, color: Colors.green),
    );
  }

  Widget buildRemoveItemButton(SimpleNode item) {
    return IconButton(
      onPressed: () => item.delete(),
      icon: Icon(Icons.delete, color: Colors.red),
    );
  }

  Widget buildAddItemChildButton(SimpleNode item) {
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
        label: Text("Add Child", style: TextStyle(color: Colors.green)),
        onPressed: () => item.add(SimpleNode()),
      ),
    );
  }

  Widget buildClearAllItemButton(SimpleNode item) {
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
