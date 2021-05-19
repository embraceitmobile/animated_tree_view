import 'dart:collection';

abstract class INode<T> {
  static const PATH_SEPARATOR = ".";
  static const ROOT_KEY = "/";

  String get key;

  INode<T>? parent;

  Object? get children;

  Map<String, dynamic>? meta;

  UnmodifiableListView<INode<T>> get childrenAsList;

  INode<T> elementAt(String path);

  INode<T> operator [](String path);

  int get level => parent == null ? 0 : parent!.level + 1;

  int get length => childrenAsList.length;

  bool get isLeaf => childrenAsList.isEmpty;

  INode<T> get root => isRoot ? this : this.parent!.root;

  bool get isRoot => parent == null;

  String get path =>
      parent == null ? key : "${parent!.path}${INode.PATH_SEPARATOR}$key";

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is INode<T> && other.key == key;

  @override
  int get hashCode => 0;
}

extension StringUtils on String {
  List<String> get splitToNodes {
    final nodes = this.split(INode.PATH_SEPARATOR);
    if (nodes.isNotEmpty && nodes.first.isEmpty) {
      nodes.removeAt(0);
    }
    return nodes;
  }
}
