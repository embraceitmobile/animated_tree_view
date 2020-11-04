import 'package:flutter/foundation.dart';
import 'package:multi_level_list_view/multi_level_list_view.dart';

class RowItem with Node<RowItem> {
  final List<RowItem> children;
  final int index;

  RowItem({
    @required this.index,
    this.children = const <RowItem>[],
  });
}

List<RowItem> items = [
  RowItem(index: 1, children: <RowItem>[
    RowItem(index: 1, children: <RowItem>[]),
  ]),
  RowItem(index: 2),
  RowItem(index: 3, children: <RowItem>[
    RowItem(index: 1),
    RowItem(index: 2),
    RowItem(index: 3, children: <RowItem>[
      RowItem(index: 1, children: <RowItem>[
        RowItem(index: 1),
        RowItem(index: 2),
        RowItem(index: 3),
      ]),
    ]),
  ]),
  RowItem(index: 4),
];

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
