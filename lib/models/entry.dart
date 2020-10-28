mixin MultiLevelEntry<T extends _Entry<T>> implements _Entry<T> {
  String id;

  List<T> children;

  bool get hasChildren => children.isNotEmpty;

  @override
  String toString() {
    return 'MultiLevelEntry{id: $id}, children: ${children.length}';
  }
}

mixin _Entry<T> {
  String id;

  List<T> children;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _Entry && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
