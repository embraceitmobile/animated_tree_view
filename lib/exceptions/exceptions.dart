import 'package:tree_structure_view/node/base/i_node.dart';

class DuplicateKeyException implements Exception {
  final String message;

  DuplicateKeyException(String key)
      : message = "Key: $key already exists. Please use unique strings as keys";
}

class NodeNotFoundException implements Exception {
  final String message;

  NodeNotFoundException({required String key, String? parentKey})
      : message = "The node <$key> does not exist in the parent <$parentKey>";

  factory NodeNotFoundException.fromNode(INode node) =>
      NodeNotFoundException(key: node.key, parentKey: node.parent?.key);
}

class ChildrenNotFoundException implements Exception {
  final String message;

  ChildrenNotFoundException(INode node)
      : message =
            "The node <${node.key}> of parent <${node.parent?.key}> does not have any children";
}
