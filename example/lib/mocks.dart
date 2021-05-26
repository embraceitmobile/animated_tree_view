import 'package:animated_tree_view/animated_tree_view.dart';

class RowItem extends ListenableNode<RowItem> {
  RowItem([String? key]) : super(key: key);
}

class IndexedRowItem extends ListenableIndexedNode<IndexedRowItem> {
  IndexedRowItem([String? key]) : super(key: key);
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
