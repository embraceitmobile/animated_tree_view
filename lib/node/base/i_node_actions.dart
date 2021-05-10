import '../node.dart';

abstract class IMapNodeActions<T> {
  void add(Node<T> value);

  Future<void> addAsync(Node<T> value);

  void addAll(Iterable<Node<T>> iterable);

  Future<void> addAllAsync(Iterable<Node<T>> iterable);

  void remove(String key);

  void removeAll(Iterable<String> keys);

  void clear();
}

abstract class IListNodeActions<T> implements IMapNodeActions<T> {
  void insert(int index, Node<T> element);

  Future<void> insertAsync(int index, Node<T> element);

  void insertAll(int index, Iterable<Node<T>> iterable);

  Future<void> insertAllAsync(int index, Iterable<Node<T>> iterable);

  int insertAfter(Node<T> element);

  Future<int> insertAfterAsync(Node<T> element);

  int insertBefore(Node<T> element);

  Future<int> insertBeforeAsync(Node<T> element);

  Node<T> removeAt(int index);
}
