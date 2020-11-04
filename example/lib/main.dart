import 'package:flutter/material.dart';
import 'package:multi_level_list_view/multi_level_list_view.dart';

import 'mocks.dart';

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
  final controller = InsertableMultiLevelListViewController<RowItem>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: MultiLevelListView<RowItem>.insertable(
          initialItems: items,
          controller: controller,
          builder: (context, level, item) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title:
                    Text("Item ${item.level}-${ALPHABET_MAPPER[item.index]}"),
                subtitle: Text('Level $level'),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red[900]),
                  onPressed: () {
                    controller.remove(item);
                  },
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    buildButton("Above", () {
                      controller.insert(
                          RowItem(index: item.index), item.index - 1,
                          path: item.path);
                    }),
                    buildButton("Below", () {
                      controller.insert(
                          RowItem(index: item.index + 1), item.index + 1,
                          path: item.path);
                    }),
                    buildButton("Child", () {
                      controller.add(RowItem(index: 1, children: <RowItem>[]),
                          path: item.childrenPath);
                    }),
                  ],
                ),
              ),
              Divider(),
            ],
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget buildButton(String label, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: FlatButton.icon(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.green),
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        icon: Icon(Icons.add_circle, color: Colors.green),
        label: Text(label),
        onPressed: onPressed,
      ),
    );
  }
}
