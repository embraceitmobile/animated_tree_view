// import 'package:animated_tree_view/animated_tree_view.dart';
// import 'package:flutter/material.dart';
//
// import 'mocks/mock_indexed_trees.dart';
// import 'utils/utils.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Example Animated Indexed Tree Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: MyHomePage(title: 'Example Animated Indexed Tree Demo'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key? key, required this.title}) : super(key: key);
//
//   final String title;
//
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   int stateCount = 0;
//
//   void _nextTree() {
//     setState(() {
//       if (stateCount < testIndexedTrees.length - 1)
//         stateCount++;
//       else {
//         stateCount = 0;
//       }
//     });
//     print("Current indexed tree: $stateCount");
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.fast_forward),
//         onPressed: _nextTree,
//       ),
//       body: IndexedTreeView<SimpleIndexedNode>(
//         tree: testIndexedTrees[stateCount],
//         expansionIndicator: ExpansionIndicator.DownUpChevron,
//         expansionBehavior: ExpansionBehavior.none,
//         shrinkWrap: true,
//         showRootNode: true,
//         builder: (context, level, item) => Card(
//           color: colorMapper[level.clamp(0, colorMapper.length - 1)]!,
//           child: ListTile(
//             title: Text("Item ${item.level}-${item.key}"),
//             subtitle: Text('Level $level'),
//           ),
//         ),
//       ),
//     );
//   }
// }
