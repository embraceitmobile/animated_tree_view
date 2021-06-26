import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RowItem extends ListenableNode<RowItem> {
  RowItem([String? key]) : super(key: key);
}

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
  final controller = TreeListViewController<RowItem>();
  final globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: TreeView<RowItem>(
        initialItem: RowItem("#00-Root-Item"),
        controller: controller,
        shrinkWrap: true,
        builder: (context, level, item) => item.isRoot
            ? buildRootItem(level, item)
            : buildListItem(level, item),
      ),
    );
  }

  Widget buildRootItem(int level, RowItem item) {
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

  Widget buildListItem(int level, RowItem item) {
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

  Widget buildAddItemButton(RowItem item) {
    return IconButton(
      onPressed: () => item.add(RowItem()),
      icon: Icon(Icons.add_circle, color: Colors.green),
    );
  }

  Widget buildRemoveItemButton(RowItem item) {
    return IconButton(
      onPressed: () => item.delete(),
      icon: Icon(Icons.delete, color: Colors.red),
    );
  }

  Widget buildAddItemChildButton(RowItem item) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: FlatButton.icon(
        color: Colors.green[800],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        icon: Icon(Icons.add_circle, color: Colors.white),
        label: Text("Add Child", style: TextStyle(color: Colors.white)),
        onPressed: () => item.add(RowItem()),
      ),
    );
  }

  Widget buildClearAllItemButton(RowItem item) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: FlatButton.icon(
          color: Colors.red[800],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          icon: Icon(Icons.delete, color: Colors.white),
          label: Text("Clear All", style: TextStyle(color: Colors.white)),
          onPressed: () => item.clear()),
    );
  }
}

final Map<int, Color> colorMapper = {
  0: Colors.white,
  1: Colors.blueGrey[50]!,
  2: Colors.blueGrey[100]!,
  3: Colors.blueGrey[200]!,
  4: Colors.blueGrey[300]!,
  5: Colors.blueGrey[400]!,
  6: Colors.blueGrey[500]!,
  7: Colors.blueGrey[600]!,
  8: Colors.blueGrey[700]!,
  9: Colors.blueGrey[800]!,
  10: Colors.blueGrey[900]!,
};

extension ColorUtil on Color {
  Color byLuminance() =>
      this.computeLuminance() > 0.4 ? Colors.black87 : Colors.white;
}
