import 'package:tree_structure_view/node/map_node.dart';
import 'package:tree_structure_view/tree/indexed_tree.dart';
import 'package:tree_structure_view/tree/tree.dart';
import 'package:tree_structure_view/tree_structure_view.dart';

IndexedTree get mockIndexedTreeWithIds => IndexedTree()
  ..addAll([
    ListNode("0A")..add(ListNode("0A1A")),
    ListNode("0B"),
    ListNode("0C")
      ..addAll([
        ListNode("0C1A"),
        ListNode("0C1B"),
        ListNode("0C1C")
          ..addAll([
            ListNode("0C1C2A")
              ..addAll([
                ListNode("0C1C2A3A"),
                ListNode("0C1C2A3B"),
                ListNode("0C1C2A3C"),
              ]),
          ]),
      ]),
  ]);

ListNode get mockListNode1 => ListNode("M1")
  ..addAll([
    ListNode("0A")..add(ListNode("0A1A")),
    ListNode("0B"),
    ListNode("0C")
      ..addAll([
        ListNode("0C1A"),
        ListNode("0C1B"),
        ListNode("0C1C")
          ..addAll([
            ListNode("0C1C2A")
              ..addAll([
                ListNode("0C1C2A3A"),
                ListNode("0C1C2A3B"),
                ListNode("0C1C2A3C"),
              ]),
          ]),
      ]),
  ]);

ListNode get mockListNode2 => ListNode("M2")
  ..addAll([
    ListNode("0A")..add(ListNode("0A1A")),
    ListNode("0B"),
    ListNode("0C")
      ..addAll([
        ListNode("0C1A"),
        ListNode("0C1B"),
        ListNode("0C1C")
          ..addAll([
            ListNode("0C1C2A")
              ..addAll([
                ListNode("0C1C2A3A"),
                ListNode("0C1C2A3B"),
                ListNode("0C1C2A3C"),
              ]),
          ]),
      ]),
  ]);

ListNode get mockListNode3 => ListNode("M3")
  ..addAll([
    ListNode("0A")..add(ListNode("0A1A")),
    ListNode("0B"),
    ListNode("0C")
      ..addAll([
        ListNode("0C1A"),
        ListNode("0C1B"),
        ListNode("0C1C")
          ..addAll([
            ListNode("0C1C2A")
              ..addAll([
                ListNode("0C1C2A3A"),
                ListNode("0C1C2A3B"),
                ListNode("0C1C2A3C"),
              ]),
          ]),
      ]),
  ]);

IndexedTree get mockIndexedTreeWithOutIds => IndexedTree()
  ..addAll([
    ListNode()..add(ListNode()),
    ListNode(),
    ListNode()
      ..addAll([
        ListNode(),
        ListNode(),
        ListNode()
          ..addAll([
            ListNode()
              ..addAll([
                ListNode(),
                ListNode(),
                ListNode(),
              ]),
          ]),
      ]),
  ]);
