import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tree_structure_view/tree_list_views/controllers/tree_list_view_controller.dart';
import 'package:tree_structure_view/tree_structure_view.dart';

import 'mocks.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Indexed Tree List View Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(
        title: 'Indexed Tree List View Demo',
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
  final globalKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
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
                builder: (context, level, item) => buildListItem(level, item)),
            if (!_showRootNode)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: RaisedButton.icon(
                    onPressed: () => controller.root.add(IndexedRowItem()),
                    icon: Icon(Icons.add),
                    label: Text("Add Node")),
              )
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget buildListItem(int level, IndexedRowItem item) {
    return Column(
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
            if (!item.isRoot) ...[
              buildInsertAboveButton(item),
              buildInsertBelowButton(item),
              buildRemoveItemButton(item),
            ],
            if (item.isRoot) buildAddItemChildButton(item),
            if (item.isRoot && item.children.isNotEmpty)
              buildClearAllItemButton(item)
          ],
        ),
        Divider(),
      ],
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
        label: Text("Add Child", style: TextStyle(color: Colors.white)),
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
