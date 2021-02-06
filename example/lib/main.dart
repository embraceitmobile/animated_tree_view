import 'package:flutter/material.dart';
import 'package:multi_level_list_view/multi_level_list_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multi Level List View Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Multi Level List View Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

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
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MultiLevelListView<RowItem>(
              controller: controller,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              onItemTap: (item) => globalKey.currentState.showSnackBar(SnackBar(
                  duration: Duration(milliseconds: 500),
                  content:
                      Text('on tap item \nItem ${item.level}-${item.key}'))),
              builder: (context, level, item) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text("Item ${item.level}-${item.key}"),
                    subtitle: Text('Level $level'),
                    trailing: IconButton(
                      color: Colors.red[900],
                      icon: Icon(Icons.delete, color: Colors.white),
                      onPressed: () => controller.remove(item.key),
                    ),
                  ),
                  buildAddItemChildButton(item),
                  Divider(),
                ],
              ),
            ),
            RaisedButton.icon(
                onPressed: () => controller.add(RowItem()),
                icon: Icon(Icons.add),
                label: Text("Add Child"))
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
        onPressed: () => controller.add(RowItem(), path: item.childrenPath),
      ),
    );
  }
}
