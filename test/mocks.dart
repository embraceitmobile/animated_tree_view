import 'package:flutter/foundation.dart';
import 'package:multi_level_list_view/multi_level_list_view.dart';

class EntryItemWithIdImpl with Entry<EntryItemWithIdImpl> {
  final String key;
  final List<EntryItemWithIdImpl> children;

  EntryItemWithIdImpl({
    @required this.key,
    this.children = const <EntryItemWithIdImpl>[],
  });
}

class EntryItemImpl with Entry<EntryItemImpl> {
  final List<EntryItemImpl> children;

  EntryItemImpl({
    this.children = const <EntryItemImpl>[],
  });
}

List<EntryItemWithIdImpl> itemsWithIds = [
  EntryItemWithIdImpl(key: "0A", children: <EntryItemWithIdImpl>[EntryItemWithIdImpl(key: "1A")]),
  EntryItemWithIdImpl(key: "0B"),
  EntryItemWithIdImpl(key: "0C", children: <EntryItemWithIdImpl>[
    EntryItemWithIdImpl(key: "0C1A"),
    EntryItemWithIdImpl(key: "0C1B"),
    EntryItemWithIdImpl(key: "0C1C", children: <EntryItemWithIdImpl>[
      EntryItemWithIdImpl(key: "0C1C2A", children: <EntryItemWithIdImpl>[
        EntryItemWithIdImpl(key: "0C1C2A3A"),
        EntryItemWithIdImpl(key: "0C1C2A3B"),
        EntryItemWithIdImpl(key: "0C1C2A3C"),
      ]),
    ]),
  ]),
  EntryItemWithIdImpl(key: "0D"),
];

List<EntryItemImpl> itemsWithoutIds = [
  EntryItemImpl(children: <EntryItemImpl>[EntryItemImpl()]),
  EntryItemImpl(),
  EntryItemImpl(children: <EntryItemImpl>[
    EntryItemImpl(),
    EntryItemImpl(),
    EntryItemImpl(children: <EntryItemImpl>[
      EntryItemImpl(children: <EntryItemImpl>[
        EntryItemImpl(),
        EntryItemImpl(),
        EntryItemImpl(),
      ]),
    ]),
  ]),
  EntryItemImpl(),
];
