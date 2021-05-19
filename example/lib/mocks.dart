import 'package:flutter/foundation.dart';
import 'package:tree_structure_view/listenable_node/listenable_node.dart';
import 'package:tree_structure_view/tree_structure_view.dart';

class RowItem extends ListenableNode<RowItem> {
  RowItem([String? key]) : super(key:key);
}

const Map<int, String> ALPHABET_MAPPER = {
  1: "A",
  2: "B",
  3: "C",
  4: "D",
  5: "E",
  6: "F",
  7: "G",
  8: "H",
  9: "I",
  10: "J"
};
