import 'package:flutter/foundation.dart';
import 'package:multi_level_list_view/multi_level_list_view.dart';

class RowItem with MultiLevelEntry<RowItem> {
  final String id;
  final List<RowItem> children;
  final String title;
  final String subTitle;

  RowItem({
    @required this.id,
    @required this.title,
    this.subTitle = "",
    this.children = const <RowItem>[],
  });


}

List<RowItem> items = [
  RowItem(id: "0A", title: "Item 0-A", subTitle: "Level 0", children: <RowItem>[
    RowItem(
        id: "1A",
        title: "Item 1-A",
        subTitle: "Level 1",
        children: <RowItem>[]),
  ]),
  RowItem(
    id: "0B",
    title: "Item 0-B",
    subTitle: "Level 0",
  ),
  RowItem(id: "0C", title: "Item 0-C", subTitle: "Level 0", children: <RowItem>[
    RowItem(
      id: "0C1A",
      title: "Item 1-A",
      subTitle: "Level 1",
    ),
    RowItem(
      id: "0C1B",
      title: "Item 1-B",
      subTitle: "Level 1",
    ),
    RowItem(
        id: "0C1C",
        title: "Item 1-C",
        subTitle: "Level 1",
        children: <RowItem>[
          RowItem(
              id: "0C1C2A",
              title: "Item 2-A",
              subTitle: "Level 2",
              children: <RowItem>[
                RowItem(
                  id: "0C1C3A",
                  title: "Item 3-A",
                  subTitle: "Level 3",
                ),
                RowItem(
                  id: "0C1C3B",
                  title: "Item 3-B",
                  subTitle: "Level 3",
                ),
                RowItem(
                  id: "0C1C3C",
                  title: "Item 3-C",
                  subTitle: "Level 3",
                ),
              ]),
        ]),
  ]),
  RowItem(
    id: "0D",
    title: "Item 0-D",
    subTitle: "Level 0",
  ),
];
