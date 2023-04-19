import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:example/utils/utils.dart';
import 'package:flutter/material.dart';

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
      home: MyHomePage(title: 'Pre populated TreeView sample'),
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
    Future.microtask(
      () => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(testTrees[stateCount].key),
          duration: const Duration(seconds: 2),
        ),
      ),
    );
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
      body: TreeView.simple(
        tree: testTrees[stateCount].value,
        expansionBehavior: ExpansionBehavior.none,
        shrinkWrap: true,
        showRootNode: true,
        builder: (context, node) => Card(
          color: colorMapper[node.level.clamp(0, colorMapper.length - 1)]!,
          child: ListTile(
            title: Text("Item ${node.level}-${node.key}"),
            subtitle: Text('Level ${node.level}'),
          ),
        ),
      ),
    );
  }
}

late final testTrees = <MapEntry<String, TreeNode>>[
  MapEntry("Default tree", defaultTree),
  MapEntry("Add two nodes in root (L0)", nodesAddedTree),
  MapEntry("Add nodes in 0C (L1)", levelOneNodesAdded),
  MapEntry("Add nodes in 0C1C (L2)", levelTwoNodesAdded),
  MapEntry("Add nodes in 0C1C2A (L3)", levelThreeNodesAdded),
  MapEntry("Removes nodes from root (L0)", nodesRemoved),
  MapEntry("Remove nodes from 0C (L1)", levelOneNodesRemoved),
  MapEntry("Remove nodes from 0C1C2A(L3) ", levelTwoNodesRemoved),
  MapEntry("Remove nodes from 0C1C(L2) ", levelThreeNodesRemoved),
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
        TreeNode(key: "0C1C"),
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
        TreeNode(key: "0C1C")..addAll([TreeNode(key: "0C1C2A")]),
      ]),
    TreeNode(key: "0D"),
    TreeNode(key: "0E"),
  ]);

final levelThreeNodesAdded = TreeNode.root()
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

final levelThreeNodesRemoved = TreeNode.root()
  ..addAll([
    TreeNode(key: "0C")..addAll([TreeNode(key: "0C1C")]),
  ]);
