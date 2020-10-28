mixin MultiLevelEntry<T extends _Entry<T>> implements _Entry<T> {
  static const PATH_SEPARATOR = ".";

  String get id;

  List<T> get children;

  String entryPath = "";

  bool isExpanded = false;

  bool get hasChildren => children.isNotEmpty;

  int get level => PATH_SEPARATOR.allMatches(entryPath).length;

  @override
  String toString() {
    return 'MultiLevelEntry{id: $id}, path: $entryPath, children: ${children.length}';
  }
}

mixin _Entry<T> {
  String get id;

  String entryPath;

  List<T> get children;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _Entry && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
