import 'package:tree_structure_view/node/list_node.dart';

import '../node.dart';

abstract class IMapNodeActions<T> {
  void add(Node<T> value);

  Future<void> addAsync(Node<T> value);

  void addAll(Iterable<Node<T>> iterable);

  Future<void> addAllAsync(Iterable<Node<T>> iterable);

  void remove(String key);

  void removeAll(Iterable<String> keys);

  void removeWhere(bool test(Node<T> element));

  void clear();
}

abstract class IListNodeActions<T> implements IMapNodeActions<T> {
  void insert(int index, ListNode<T> element);

  Future<void> insertAsync(int index, ListNode<T> element);

  void insertAll(int index, Iterable<ListNode<T>> iterable);

  Future<void> insertAllAsync(int index, Iterable<ListNode<T>> iterable);

  int insertAfter(ListNode<T> after, ListNode<T> element);

  Future<int> insertAfterAsync(ListNode<T> after, ListNode<T> element);

  int insertBefore(ListNode<T> before, ListNode<T> element);

  Future<int> insertBeforeAsync(ListNode<T> before,ListNode<T> element);

  ListNode<T> removeAt(int index);
  
  ListNode<T> at(int index);

}
