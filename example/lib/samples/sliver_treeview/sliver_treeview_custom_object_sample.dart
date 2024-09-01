import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:example/utils/utils.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sliver TreeView Custom Object Sample Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(title: 'Sliver TreeView Modification Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final globalKey = GlobalKey<ScaffoldState>();
  final AutoScrollController scrollController = AutoScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
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
                "Typed Sliver List",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
          ),

          /// Typed [SliverTreeView] example
          SliverTreeView.simpleTyped<UserName, TreeNode<UserName>>(
            tree: simpleTree,
            builder: (context, node) => Card(
              color: colorMapper[node.level.clamp(0, colorMapper.length - 1)]!,
              child: ListTile(
                title: Text("Typed Simple Item ${node.level}-${node.key}"),
                subtitle:
                    Text('${node.data?.firstName} ${node.data?.lastName}'),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: Text(
                "Typed Indexed Sliver List",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
          ),

          /// IndexTyped [SliverTreeView] example
          SliverTreeView.indexTyped<UserName, IndexedTreeNode<UserName>>(
            tree: indexedTree,
            scrollController: scrollController,
            expansionBehavior: ExpansionBehavior.collapseOthersAndSnapToTop,
            builder: (context, node) => Card(
              color: colorMapper[node.level.clamp(0, colorMapper.length - 1)]!,
              child: ListTile(
                title: Text("Typed Indexed Item ${node.level}-${node.key}"),
                subtitle:
                    Text('${node.data?.firstName} ${node.data?.lastName}'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UserName {
  final String firstName;
  final String lastName;

  UserName(this.firstName, this.lastName);
}

final simpleTree = TreeNode<UserName>.root(data: UserName("User", "Names"))
  ..addAll([
    TreeNode<UserName>(key: "0A", data: UserName("Sr. John", "Doe"))
      ..add(TreeNode(key: "0A1A", data: UserName("Jr. John", "Doe"))),
    TreeNode<UserName>(key: "0C", data: UserName("General", "Lee"))
      ..addAll([
        TreeNode<UserName>(key: "0C1A", data: UserName("Major", "Lee")),
        TreeNode<UserName>(key: "0C1B", data: UserName("Happy", "Lee")),
        TreeNode<UserName>(key: "0C1C", data: UserName("Busy", "Lee"))
          ..addAll([
            TreeNode<UserName>(key: "0C1C2A", data: UserName("Jr. Busy", "Lee"))
          ]),
      ]),
    TreeNode<UserName>(key: "0D", data: UserName("Mr. Anderson", "Neo")),
    TreeNode<UserName>(key: "0E", data: UserName("Mr. Smith", "Agent")),
  ]);

final indexedTree = IndexedTreeNode<UserName>.root(
    data: UserName("User", "Names"))
  ..addAll([
    IndexedTreeNode<UserName>(key: "0A", data: UserName("Sr. John", "Doe"))
      ..add(IndexedTreeNode(key: "0A1A", data: UserName("Jr. John", "Doe"))),
    IndexedTreeNode<UserName>(key: "0C", data: UserName("General", "Lee"))
      ..addAll([
        IndexedTreeNode<UserName>(key: "0C1A", data: UserName("Major", "Lee")),
        IndexedTreeNode<UserName>(key: "0C1B", data: UserName("Happy", "Lee")),
        IndexedTreeNode<UserName>(key: "0C1C", data: UserName("Busy", "Lee"))
          ..addAll([
            IndexedTreeNode<UserName>(
                key: "0C1C2A", data: UserName("Jr. Busy", "Lee"))
          ]),
      ]),
    IndexedTreeNode<UserName>(key: "0D", data: UserName("Mr. Anderson", "Neo")),
    IndexedTreeNode<UserName>(key: "0E", data: UserName("Mr. Smith", "Agent")),
  ]);
