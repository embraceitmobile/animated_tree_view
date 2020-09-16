import 'package:flutter/foundation.dart';
import 'package:multi_level_list_view/multi_level_list_view.dart';

class EntryItemImpl implements Entry {
  String id;
  List<Entry> children;

  EntryItemImpl({
    @required this.id,
    this.children = const <Entry>[],
  });
}

List<EntryItemImpl> items = [
  EntryItemImpl(id: "0A", children: <EntryItemImpl>[
    EntryItemImpl(id: "1A"),
  ]),
  EntryItemImpl(id: "0B"),
  EntryItemImpl(id: "0C", children: <EntryItemImpl>[
    EntryItemImpl(id: "0C1A"),
    EntryItemImpl(id: "0C1B"),
    EntryItemImpl(id: "0C1C", children: <EntryItemImpl>[
      EntryItemImpl(id: "0C1C2A", children: <EntryItemImpl>[
        EntryItemImpl(id: "0C1C2A3A"),
        EntryItemImpl(id: "0C1C2A3B"),
        EntryItemImpl(id: "0C1C2A3C"),
      ]),
    ]),
  ]),
  EntryItemImpl(id: "0D"),
];
