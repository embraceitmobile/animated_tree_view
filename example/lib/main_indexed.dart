import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class IndexedRowItem extends ListenableIndexedNode<IndexedRowItem> {
  IndexedRowItem([String? key]) : super(key: key);
}

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

  final controller = IndexedTreeListViewController<IndexedRowItem>(
      initialItems: IndexedRowItem("#00-Root-Item"));

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

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
            IndexedTreeListView<IndexedRowItem>(
              controller: controller,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              showRootNode: _showRootNode,
              builder: (context, level, item) => buildListItem(level, item),
            ),
            if (!_showRootNode)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: RaisedButton.icon(
                    onPressed: () => controller.root.add(IndexedRowItem()),
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

  Widget buildListItem(int level, IndexedRowItem item) {
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

  Widget buildAddItemChildButton(IndexedRowItem item) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: FlatButton.icon(
        color: Colors.green[800],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        icon: Icon(Icons.add_circle, color: Colors.white),
        label: Text("Child", style: TextStyle(color: Colors.white)),
        onPressed: () => item.add(IndexedRowItem()),
      ),
    );
  }

  Widget buildInsertAboveButton(IndexedRowItem item) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: FlatButton(
        color: Colors.green[800],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        child: Text("Insert Above", style: TextStyle(color: Colors.white)),
        onPressed: () => item.parent?.insertBefore(item, IndexedRowItem()),
      ),
    );
  }

  Widget buildInsertBelowButton(IndexedRowItem item) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: FlatButton(
        color: Colors.green[800],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        child: Text("Insert Below", style: TextStyle(color: Colors.white)),
        onPressed: () => item.parent?.insertAfter(item, IndexedRowItem()),
      ),
    );
  }

  Widget buildRemoveItemButton(IndexedRowItem item) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: FlatButton(
          color: Colors.red[800],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          child: Icon(Icons.delete, color: Colors.white),
          onPressed: () => item.delete()),
    );
  }

  Widget buildClearAllItemButton(IndexedRowItem item) {
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
