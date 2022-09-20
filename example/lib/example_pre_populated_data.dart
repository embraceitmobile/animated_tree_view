import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:example/mocks/mock_trees.dart';
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
  int currentTree = 0;

  void _nextTree() {
    setState(() {
      if (currentTree < testTrees.length - 1)
        currentTree++;
      else {
        currentTree = 0;
      }
    });
    print("Current tree: $currentTree");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.fast_forward),
        onPressed: _nextTree,
      ),
      body: TreeView<SimpleNode>(
        tree: testTrees[currentTree],
        expansionIndicator: ExpansionIndicator.PlusMinus,
        controller: controller,
        expansionBehavior: ExpansionBehavior.none,
        shrinkWrap: true,
        builder: (context, level, item) => Card(
          color: colorMapper[level.clamp(0, colorMapper.length - 1)]!,
          child: ListTile(
            title: Text("Item ${item.level}-${item.key}"),
            subtitle: Text('Level $level'),
          ),
        ),
      ),
    );
  }
}