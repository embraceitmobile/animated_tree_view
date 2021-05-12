import 'dart:collection';

mixin INodeViewData<T> {
  bool isExpanded = false;

  String get key;

  String path = "";

  int get level => INode.PATH_SEPARATOR.allMatches(path).length - 1;

  String get childrenPath => "$path${INode.PATH_SEPARATOR}$key";

  UnmodifiableListView<INode<T>> get childrenAsList;

  int get length => childrenAsList.length;

  bool get isLeaf => childrenAsList.isEmpty;

  bool get isRoot => path.isEmpty || path.endsWith(INode.ROOT_KEY);
}

abstract class INode<T> with INodeViewData<T> {
  static const PATH_SEPARATOR = ".";
  static const ROOT_KEY = "/";

  String get key;

  Object get children;

  INode<T> elementAt(String path);

  INode<T> operator [](String path);

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
