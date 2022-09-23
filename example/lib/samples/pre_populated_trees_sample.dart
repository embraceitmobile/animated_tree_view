import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:flutter/material.dart';

import '../utils/utils.dart';

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
  int stateCount = 0;

  void _nextTree() {
    setState(() {
      if (stateCount < testTrees.length - 1)
        stateCount++;
      else {
        stateCount = 0;
      }
    });
    print("Current tree: $stateCount");
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
      body: TreeView(
        tree: testTrees[stateCount],
        expansionIndicator: ExpansionIndicator.DownUpChevron,
        expansionBehavior: ExpansionBehavior.none,
        shrinkWrap: true,
        showRootNode: true,
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

late final testTrees = <TreeNode>[
  defaultTree,
  nodesAddedTree,
  levelOneNodesAdded,
  levelTwoNodesAdded,
  nodesRemoved,
  levelOneNodesRemoved,
  levelTwoNodesRemoved,
];

final defaultTree = TreeNode.root()
  ..addAll([
    TreeNode(key: "0A")..add(TreeNode(key: "0A1A")),
    TreeNode(key: "0B"),
    TreeNode(key: "0C"),
  ]);

final nodesAddedTree = TreeNode.root()
  ..addAll([
    TreeNode(key: "0A")..add(TreeNode(key: "0A1A")),
    TreeNode(key: "0B"),
    TreeNode(key: "0C"),
    TreeNode(key: "0D"),
    TreeNode(key: "0E"),
  ]);

final levelOneNodesAdded = TreeNode.root()
  ..addAll([
    TreeNode(key: "0A")..add(TreeNode(key: "0A1A")),
    TreeNode(key: "0C")
      ..addAll([
        TreeNode(key: "0C1A"),
        TreeNode(key: "0C1B"),
        TreeNode(key: "0C1C")..addAll([TreeNode(key: "0C1C2A")]),
      ]),
    TreeNode(key: "0D"),
    TreeNode(key: "0E"),
  ]);

final levelTwoNodesAdded = TreeNode.root()
  ..addAll([
    TreeNode(key: "0A")..add(TreeNode(key: "0A1A")),
    TreeNode(key: "0C")
      ..addAll([
        TreeNode(key: "0C1A"),
        TreeNode(key: "0C1B"),
        TreeNode(key: "0C1C")
          ..addAll([
            TreeNode(key: "0C1C2A")
              ..addAll([
                TreeNode(key: "0C1C2A3A"),
                TreeNode(key: "0C1C2A3B"),
                TreeNode(key: "0C1C2A3C"),
              ]),
          ]),
      ]),
    TreeNode(key: "0D"),
    TreeNode(key: "0E"),
  ]);

final nodesRemoved = TreeNode.root()
  ..addAll([
    TreeNode(key: "0C")
      ..addAll([
        TreeNode(key: "0C1A"),
        TreeNode(key: "0C1B"),
        TreeNode(key: "0C1C")
          ..addAll([
            TreeNode(key: "0C1C2A")
              ..addAll([
                TreeNode(key: "0C1C2A3A"),
                TreeNode(key: "0C1C2A3B"),
                TreeNode(key: "0C1C2A3C"),
              ]),
          ]),
      ]),
  ]);

final levelOneNodesRemoved = TreeNode.root()
  ..addAll([
    TreeNode(key: "0C")
      ..addAll([
        TreeNode(key: "0C1C")
          ..addAll([
            TreeNode(key: "0C1C2A")
              ..addAll([
                TreeNode(key: "0C1C2A3A"),
                TreeNode(key: "0C1C2A3B"),
                TreeNode(key: "0C1C2A3C"),
              ]),
          ]),
      ]),
  ]);

final levelTwoNodesRemoved = TreeNode.root()
  ..addAll([
    TreeNode(key: "0C")
      ..addAll([
        TreeNode(key: "0C1C")
          ..addAll([
            TreeNode(key: "0C1C2A")
              ..addAll([
                TreeNode(key: "0C1C2A3C"),
              ]),
          ]),
      ]),
  ]);
