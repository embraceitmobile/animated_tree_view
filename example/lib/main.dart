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
      title: 'Tree List View Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Tree List View Demo'),
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
  static const _showRootNode = false;

  final controller =
      TreeListViewController<RowItem>(initialItem: RowItem("#00-Root-Item"));
  final globalKey = GlobalKey<ScaffoldState>();

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
            TreeListView<RowItem>(
              controller: controller,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              showRootNode: _showRootNode,
              builder: (context, level, item) => Column(
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
                      if (!item.isRoot) buildRemoveItemButton(item),
                      if (item.isRoot && item.children.isNotEmpty)
                        buildClearAllItemButton(item)
                    ],
                  ),
                  Divider(),
                ],
              ),
            ),
            if (!_showRootNode)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: RaisedButton.icon(
                    onPressed: () => controller.root.add(RowItem()),
                    icon: Icon(Icons.add),
                    label: Text("Add Node")),
              )
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
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

  Widget buildRemoveItemButton(RowItem item) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: FlatButton.icon(
          color: Colors.red[800],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          icon: Icon(Icons.delete, color: Colors.white),
          label: Text("Delete", style: TextStyle(color: Colors.white)),
          onPressed: () => item.delete()),
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
