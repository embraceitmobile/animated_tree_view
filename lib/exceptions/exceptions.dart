class DuplicateKeyException implements Exception {
  final String message;

  DuplicateKeyException(String key)
      : message = "Key: $key already exists. Please use unique strings as keys";
}

class NodeNotFoundException implements Exception {
  final String message;

  NodeNotFoundException(String path, String key)
      : message = "The node <$key> does not exist in the path <$path>";
}
