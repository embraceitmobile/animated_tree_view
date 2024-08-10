import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:flutter/material.dart';

import '../../utils/utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Animated Tree Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(title: 'Simple Animated Tree Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<SliverTreeViewState> _simpleTreeKey =
      GlobalKey<SliverTreeViewState>();
  final GlobalKey<SliverTreeViewState> _indexedTreeKey =
      GlobalKey<SliverTreeViewState>();
  final AutoScrollController scrollController = AutoScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: Text(
                "Simple Sliver List",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
          ),

          /// Simple [SliverTreeView] example
          SliverTreeView.simple(
            key: _simpleTreeKey,
            tree: simpleTree,
            scrollController: scrollController,
            expansionBehavior: ExpansionBehavior.none,
            builder: (context, node) => Card(
              color: colorMapper[node.level.clamp(0, colorMapper.length - 1)]!,
              child: ListTile(
                title: Text("Simple Item ${node.level}-${node.key}"),
                subtitle: Text('Level ${node.level}'),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: Text(
                "Indexed Sliver List",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
          ),

          ///Indexed [SliverTreeView] example
          SliverTreeView.indexed(
            key: _indexedTreeKey,
            tree: indexedTree,
            scrollController: scrollController,
            expansionBehavior: ExpansionBehavior.scrollToLastChild,
            builder: (context, node) => Card(
              color: colorMapper[node.level.clamp(0, colorMapper.length - 1)]!,
              child: ListTile(
                title: Text("Indexed Item ${node.level}-${node.key}"),
                subtitle: Text('Level ${node.level}'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final simpleTree = TreeNode.root()
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

final indexedTree = IndexedTreeNode.root()
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
