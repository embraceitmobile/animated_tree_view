import 'package:flutter/foundation.dart';
import '../multi_level_list_view.dart';
import 'package:multi_level_list_view/tree_list/node.dart';


class Utils {
  Utils._();

  static Future<List<T>> normalize<T extends Node<T>>(
      List<T> list) async {
    return List<T>.from(await compute(generateLevelAwareEntries, list));
  }

  @visibleForTesting
  static List<dynamic> generateLevelAwareEntries(List<dynamic> list,
      {String path = ""}) {
    //create a copy of the list
    final normalList = List.of(list);

    for (final entry in normalList) {
      entry.path = path;
      if (entry.children.isNotEmpty) {
        generateLevelAwareEntries(entry.children, path: '$path.${entry.key}');
      }
    }

    return normalList;
  }
}
