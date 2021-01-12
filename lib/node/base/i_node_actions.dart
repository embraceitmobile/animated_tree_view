import '../node.dart';

abstract class IMapNodeActions<T> {
  void add(Node<T> value);

  Future<void> addAsync(Node<T> value);

  void addAll(Iterable<Node<T>> iterable);

  Future<void> addAllAsync(Iterable<Node<T>> iterable);

  void remove(Node<T> element);

  void removeAll(Iterable<Node<T>> iterable);

  void removeWhere(bool test(Node<T> element));

  void clear();
}

abstract class IListNodeActions<T> implements IMapNodeActions<T> {
  void insert(int index, Node<T> element);

  Future<void> insertAsync(int index, Node<T> element);

  void insertAll(int index, Iterable<Node<T>> iterable);

  Future<void> insertAllAsync(int index, Iterable<Node<T>> iterable);

  void insertAfter(Node<T> element);

  Future<void> insertAfterAsync(Node<T> element);

  void insertBefore(Node<T> element);

  Future<void> insertBeforeAsync(Node<T> element);

  Node<T> removeAt(int index);

  Future<Node<T>> removeAtAsync(int index);
}
