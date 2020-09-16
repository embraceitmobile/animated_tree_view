abstract class Entry {
  String id;
  List<Entry> children;

  Entry(this.id, this.children);

  @override
  String toString() {
    return 'MultiLevelEntry{id: $id}, children: ${children.length}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Entry && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
