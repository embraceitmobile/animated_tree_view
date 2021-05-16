// import 'package:tree_structure_view/node/node.dart';
// import 'package:tree_structure_view/tree/indexed_tree.dart';
// import 'package:tree_structure_view/tree/tree.dart';
// import 'package:tree_structure_view/tree_structure_view.dart';
//
// IndexedTree get mockIndexedTreeWithIds => IndexedTree()
//   ..addAll([
//     IndexedNode("0A")..add(IndexedNode("0A1A")),
//     IndexedNode("0B"),
//     IndexedNode("0C")
//       ..addAll([
//         IndexedNode("0C1A"),
//         IndexedNode("0C1B"),
//         IndexedNode("0C1C")
//           ..addAll([
//             IndexedNode("0C1C2A")
//               ..addAll([
//                 IndexedNode("0C1C2A3A"),
//                 IndexedNode("0C1C2A3B"),
//                 IndexedNode("0C1C2A3C"),
//               ]),
//           ]),
//       ]),
//   ]);
//
// IndexedNode get mockIndexedNode1 => IndexedNode("M1")
//   ..addAll([
//     IndexedNode("0A")..add(IndexedNode("0A1A")),
//     IndexedNode("0B"),
//     IndexedNode("0C")
//       ..addAll([
//         IndexedNode("0C1A"),
//         IndexedNode("0C1B"),
//         IndexedNode("0C1C")
//           ..addAll([
//             IndexedNode("0C1C2A")
//               ..addAll([
//                 IndexedNode("0C1C2A3A"),
//                 IndexedNode("0C1C2A3B"),
//                 IndexedNode("0C1C2A3C"),
//               ]),
//           ]),
//       ]),
//   ]);
//
// IndexedNode get mockIndexedNode2 => IndexedNode("M2")
//   ..addAll([
//     IndexedNode("0A")..add(IndexedNode("0A1A")),
//     IndexedNode("0B"),
//     IndexedNode("0C")
//       ..addAll([
//         IndexedNode("0C1A"),
//         IndexedNode("0C1B"),
//         IndexedNode("0C1C")
//           ..addAll([
//             IndexedNode("0C1C2A")
//               ..addAll([
//                 IndexedNode("0C1C2A3A"),
//                 IndexedNode("0C1C2A3B"),
//                 IndexedNode("0C1C2A3C"),
//               ]),
//           ]),
//       ]),
//   ]);
//
// IndexedNode get mockIndexedNode3 => IndexedNode("M3")
//   ..addAll([
//     IndexedNode("0A")..add(IndexedNode("0A1A")),
//     IndexedNode("0B"),
//     IndexedNode("0C")
//       ..addAll([
//         IndexedNode("0C1A"),
//         IndexedNode("0C1B"),
//         IndexedNode("0C1C")
//           ..addAll([
//             IndexedNode("0C1C2A")
//               ..addAll([
//                 IndexedNode("0C1C2A3A"),
//                 IndexedNode("0C1C2A3B"),
//                 IndexedNode("0C1C2A3C"),
//               ]),
//           ]),
//       ]),
//   ]);
//
// IndexedTree get mockIndexedTreeWithOutIds => IndexedTree()
//   ..addAll([
//     IndexedNode()..add(IndexedNode()),
//     IndexedNode(),
//     IndexedNode()
//       ..addAll([
//         IndexedNode(),
//         IndexedNode(),
//         IndexedNode()
//           ..addAll([
//             IndexedNode()
//               ..addAll([
//                 IndexedNode(),
//                 IndexedNode(),
//                 IndexedNode(),
//               ]),
//           ]),
//       ]),
//   ]);
