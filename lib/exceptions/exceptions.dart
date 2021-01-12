class DuplicateKeyException implements Exception {
  final String message;

  DuplicateKeyException(String key)
      : message = "Key: $key already exists. Please use unique strings as keys";
}
