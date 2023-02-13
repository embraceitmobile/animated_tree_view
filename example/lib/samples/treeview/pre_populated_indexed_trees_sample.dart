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
      title: 'Example Animated Indexed Tree Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Pre populated Indexed TreeView sample'),
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
      if (stateCount < testIndexedTrees.length - 1)
        stateCount++;
      else {
        stateCount = 0;
      }
    });

    Future.microtask(
      () => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(testIndexedTrees[stateCount].key),
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
      body: TreeView.indexed(
        tree: testIndexedTrees[stateCount].value,
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

late final testIndexedTrees = <MapEntry<String, IndexedTreeNode>>[
  MapEntry("Default tree", defaultIndexedTree),
  MapEntry("Add two nodes in root (L0)", nodesAddedTree),
  MapEntry("Add nodes in 0C (L1)", levelOneNodesAdded),
  MapEntry("Add nodes in 0C1C (L2)", levelTwoNodesAdded),
  MapEntry("Add nodes in 0C1C2A (L3)", levelThreeNodesAdded),
  MapEntry("Removes nodes from root (L0)", nodesRemoved),
  MapEntry("Remove nodes from 0C (L1)", levelOneNodesRemoved),
  MapEntry("Remove nodes from 0C1C2A(L3) ", levelTwoNodesRemoved),
  MapEntry("Remove nodes from 0C1C(L2) ", levelThreeNodesRemoved),
];

final defaultIndexedTree = IndexedTreeNode.root()
  ..addAll([
    IndexedTreeNode(key: "0A")..add(IndexedTreeNode(key: "0A1A")),
    IndexedTreeNode(key: "0B"),
    IndexedTreeNode(key: "0C"),
  ]);

final nodesAddedTree = IndexedTreeNode.root()
  ..addAll([
    IndexedTreeNode(key: "0A")..add(IndexedTreeNode(key: "0A1A")),
    IndexedTreeNode(key: "0B"),
    IndexedTreeNode(key: "0C"),
    IndexedTreeNode(key: "0D"),
    IndexedTreeNode(key: "0E"),
  ]);

final levelOneNodesAdded = IndexedTreeNode.root()
  ..addAll([
    IndexedTreeNode(key: "0A")..add(IndexedTreeNode(key: "0A1A")),
    IndexedTreeNode(key: "0C")
      ..addAll([
        IndexedTreeNode(key: "0C1A"),
        IndexedTreeNode(key: "0C1B"),
        IndexedTreeNode(key: "0C1C"),
      ]),
    IndexedTreeNode(key: "0D"),
    IndexedTreeNode(key: "0E"),
  ]);

final levelTwoNodesAdded = IndexedTreeNode.root()
  ..addAll([
    IndexedTreeNode(key: "0A")..add(IndexedTreeNode(key: "0A1A")),
    IndexedTreeNode(key: "0C")
      ..addAll([
        IndexedTreeNode(key: "0C1A"),
        IndexedTreeNode(key: "0C1B"),
        IndexedTreeNode(key: "0C1C")..addAll([IndexedTreeNode(key: "0C1C2A")]),
      ]),
    IndexedTreeNode(key: "0D"),
    IndexedTreeNode(key: "0E"),
  ]);

final levelThreeNodesAdded = IndexedTreeNode.root()
  ..addAll([
    IndexedTreeNode(key: "0A")..add(IndexedTreeNode(key: "0A1A")),
    IndexedTreeNode(key: "0C")
      ..addAll([
        IndexedTreeNode(key: "0C1A"),
        IndexedTreeNode(key: "0C1B"),
        IndexedTreeNode(key: "0C1C")
          ..addAll([
            IndexedTreeNode(key: "0C1C2A")
              ..addAll([
                IndexedTreeNode(key: "0C1C2A3A"),
                IndexedTreeNode(key: "0C1C2A3B"),
                IndexedTreeNode(key: "0C1C2A3C"),
              ]),
          ]),
      ]),
    IndexedTreeNode(key: "0D"),
    IndexedTreeNode(key: "0E"),
  ]);

final nodesRemoved = IndexedTreeNode.root()
  ..addAll([
    IndexedTreeNode(key: "0C")
      ..addAll([
        IndexedTreeNode(key: "0C1A"),
        IndexedTreeNode(key: "0C1B"),
        IndexedTreeNode(key: "0C1C")
          ..addAll([
            IndexedTreeNode(key: "0C1C2A")
              ..addAll([
                IndexedTreeNode(key: "0C1C2A3A"),
                IndexedTreeNode(key: "0C1C2A3B"),
                IndexedTreeNode(key: "0C1C2A3C"),
              ]),
          ]),
      ]),
  ]);

final levelOneNodesRemoved = IndexedTreeNode.root()
  ..addAll([
    IndexedTreeNode(key: "0C")
      ..addAll([
        IndexedTreeNode(key: "0C1C")
          ..addAll([
            IndexedTreeNode(key: "0C1C2A")
              ..addAll([
                IndexedTreeNode(key: "0C1C2A3A"),
                IndexedTreeNode(key: "0C1C2A3B"),
                IndexedTreeNode(key: "0C1C2A3C"),
              ]),
          ]),
      ]),
  ]);

final levelTwoNodesRemoved = IndexedTreeNode.root()
  ..addAll([
    IndexedTreeNode(key: "0C")
      ..addAll([
        IndexedTreeNode(key: "0C1C")
          ..addAll([
            IndexedTreeNode(key: "0C1C2A")
              ..addAll([
                IndexedTreeNode(key: "0C1C2A3C"),
              ]),
          ]),
      ]),
  ]);

final levelThreeNodesRemoved = IndexedTreeNode.root()
  ..addAll([
    IndexedTreeNode(key: "0C")..addAll([IndexedTreeNode(key: "0C1C")]),
  ]);
