import 'package:flutter/foundation.dart';
import 'package:tree_structure_view/listenable_node/base/i_listenable_node.dart';
import 'package:tree_structure_view/node/base/i_node.dart';
import 'package:tree_structure_view/node/node.dart';

class ListenableNode<T> extends Node<T>
    with ChangeNotifier
    implements IListenableNode<T> {
  ListenableNode({String? key, INode<T>? parent})
      : super(key: key, parent: parent);

  factory ListenableNode.root() => ListenableNode(key: INode.ROOT_KEY);

  Node<T> get value => this;

  void add(INode<T> value) {
    super.add(value);
    notifyListeners();
  }

  void addAll(Iterable<INode<T>> iterable) {
    super.addAll(iterable);
    notifyListeners();
  }

  void remove(String key) {
    super.remove(key);
    notifyListeners();
  }

  void removeAll(Iterable<String> keys) {
    super.removeAll(keys);
    notifyListeners();
  }

  void removeWhere(bool test(INode<T> element)) {
    super.removeWhere(test);
    notifyListeners();
  }

  void clear() {
    super.clear();
    notifyListeners();
  }
}
