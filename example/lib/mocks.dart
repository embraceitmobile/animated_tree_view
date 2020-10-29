import 'package:flutter/foundation.dart';
import 'package:multi_level_list_view/multi_level_list_view.dart';

class RowItem with Entry<RowItem> {
  final List<RowItem> children;
  final String title;
  final String subTitle;

  RowItem({
    @required this.title,
    this.subTitle = "",
    this.children = const <RowItem>[],
  });
}

List<RowItem> items = [
  RowItem(title: "Item 0-A", subTitle: "Level 0", children: <RowItem>[
    RowItem(title: "Item 1-A", subTitle: "Level 1", children: <RowItem>[]),
  ]),
  RowItem(
    title: "Item 0-B",
    subTitle: "Level 0",
  ),
  RowItem(title: "Item 0-C", subTitle: "Level 0", children: <RowItem>[
    RowItem(
      title: "Item 1-A",
      subTitle: "Level 1",
    ),
    RowItem(
      title: "Item 1-B",
      subTitle: "Level 1",
    ),
    RowItem(title: "Item 1-C", subTitle: "Level 1", children: <RowItem>[
      RowItem(title: "Item 2-A", subTitle: "Level 2", children: <RowItem>[
        RowItem(
          title: "Item 3-A",
          subTitle: "Level 3",
        ),
        RowItem(
          title: "Item 3-B",
          subTitle: "Level 3",
        ),
        RowItem(
          title: "Item 3-C",
          subTitle: "Level 3",
        ),
      ]),
    ]),
  ]),
  RowItem(
    title: "Item 0-D",
    subTitle: "Level 0",
  ),
];
