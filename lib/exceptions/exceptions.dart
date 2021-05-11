import 'package:tree_structure_view/node/base/i_node.dart';

class DuplicateKeyException implements Exception {
  final String message;

  DuplicateKeyException(String key)
      : message = "Key: $key already exists. Please use unique strings as keys";
}

class NodeNotFoundException implements Exception {
  final String message;

  NodeNotFoundException({required String key, String? path})
      : message = "The node <$key> does not exist in the path <${path ?? ""}>";

  factory NodeNotFoundException.fromNode(INode node) =>
      NodeNotFoundException(key: node.key, path: node.path);
}

class ChildrenNotFoundException implements Exception {
  final String message;

  ChildrenNotFoundException(INode node)
      : message = "The node <${node.key}> at path <${node.path}> does not have any children";
}
