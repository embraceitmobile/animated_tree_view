import 'package:flutter/foundation.dart';
import '../multi_level_list_view.dart';

class Utils {
  Utils._();

  static Future<List<T>> normalize<T extends MultiLevelEntry<T>>(List<T> list) async {
    return List<T>.from(await compute(generateLevelAwareEntries, list));
  }

  @visibleForTesting
  static List<dynamic> generateLevelAwareEntries(List<dynamic> list,
      {String parentId = ""}) {
    //create a copy of the list
    final normalList = List.of(list);

    for (final entry in normalList) {
      if (parentId.isNotEmpty) entry.id = '$parentId.${entry.id}';
      if (entry.children.isNotEmpty) {
        generateLevelAwareEntries(entry.children, parentId: entry.id);
      }
    }

    return normalList;
  }
}
