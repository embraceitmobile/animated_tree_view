// import 'package:animated_tree_view/animated_tree_view.dart';
//
// late final testIndexedTrees = [
//   defaultIndexedTree,
//   nodesAddedTree,
//   levelOneNodesAdded,
//   levelTwoNodesAdded,
//   nodesRemoved,
//   levelOneNodesRemoved,
//   levelTwoNodesRemoved,
// ];
//
// final defaultIndexedTree = SimpleIndexedNode.root()
//   ..addAll([
//     SimpleIndexedNode("0A")..add(SimpleIndexedNode("0A1A")),
//     SimpleIndexedNode("0B"),
//     SimpleIndexedNode("0C"),
//   ]);
//
// final nodesAddedTree = SimpleIndexedNode.root()
//   ..addAll([
//     SimpleIndexedNode("0A")..add(SimpleIndexedNode("0A1A")),
//     SimpleIndexedNode("0B"),
//     SimpleIndexedNode("0C"),
//     SimpleIndexedNode("0D"),
//     SimpleIndexedNode("0E"),
//   ]);
//
// final levelOneNodesAdded = SimpleIndexedNode.root()
//   ..addAll([
//     SimpleIndexedNode("0A")..add(SimpleIndexedNode("0A1A")),
//     SimpleIndexedNode("0C")
//       ..addAll([
//         SimpleIndexedNode("0C1A"),
//         SimpleIndexedNode("0C1B"),
//         SimpleIndexedNode("0C1C")..addAll([SimpleIndexedNode("0C1C2A")]),
//       ]),
//     SimpleIndexedNode("0D"),
//     SimpleIndexedNode("0E"),
//   ]);
//
// final levelTwoNodesAdded = SimpleIndexedNode.root()
//   ..addAll([
//     SimpleIndexedNode("0A")..add(SimpleIndexedNode("0A1A")),
//     SimpleIndexedNode("0C")
//       ..addAll([
//         SimpleIndexedNode("0C1A"),
//         SimpleIndexedNode("0C1B"),
//         SimpleIndexedNode("0C1C")
//           ..addAll([
//             SimpleIndexedNode("0C1C2A")
//               ..addAll([
//                 SimpleIndexedNode("0C1C2A3A"),
//                 SimpleIndexedNode("0C1C2A3B"),
//                 SimpleIndexedNode("0C1C2A3C"),
//               ]),
//           ]),
//       ]),
//     SimpleIndexedNode("0D"),
//     SimpleIndexedNode("0E"),
//   ]);
//
// final nodesRemoved = SimpleIndexedNode.root()
//   ..addAll([
//     SimpleIndexedNode("0C")
//       ..addAll([
//         SimpleIndexedNode("0C1A"),
//         SimpleIndexedNode("0C1B"),
//         SimpleIndexedNode("0C1C")
//           ..addAll([
//             SimpleIndexedNode("0C1C2A")
//               ..addAll([
//                 SimpleIndexedNode("0C1C2A3A"),
//                 SimpleIndexedNode("0C1C2A3B"),
//                 SimpleIndexedNode("0C1C2A3C"),
//               ]),
//           ]),
//       ]),
//   ]);
//
// final levelOneNodesRemoved = SimpleIndexedNode.root()
//   ..addAll([
//     SimpleIndexedNode("0C")
//       ..addAll([
//         SimpleIndexedNode("0C1C")
//           ..addAll([
//             SimpleIndexedNode("0C1C2A")
//               ..addAll([
//                 SimpleIndexedNode("0C1C2A3A"),
//                 SimpleIndexedNode("0C1C2A3B"),
//                 SimpleIndexedNode("0C1C2A3C"),
//               ]),
//           ]),
//       ]),
//   ]);
//
// final levelTwoNodesRemoved = SimpleIndexedNode.root()
//   ..addAll([
//     SimpleIndexedNode("0C")
//       ..addAll([
//         SimpleIndexedNode("0C1C")
//           ..addAll([
//             SimpleIndexedNode("0C1C2A")
//               ..addAll([
//                 SimpleIndexedNode("0C1C2A3C"),
//               ]),
//           ]),
//       ]),
//   ]);
