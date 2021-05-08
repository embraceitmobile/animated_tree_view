import 'package:tree_structure_view/node/node.dart';

class DuplicateKeyException implements Exception {
  final String message;

  DuplicateKeyException(String key)
      : message = "Key: $key already exists. Please use unique strings as keys";
}

class NodeNotFoundException implements Exception {
  final String message;

  NodeNotFoundException({required String key, String? path})
      : message = "The node <$key> does not exist in the path <${path ?? ""}>";

  factory NodeNotFoundException.fromNode(Node node) =>
      NodeNotFoundException(key: node.key, path: node.path);
}
