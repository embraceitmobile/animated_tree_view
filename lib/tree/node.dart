import 'dart:collection';

import 'package:flutter/material.dart';

class ListNode<T> with NodeView<T> implements Node<T> {
  final List<Node<T>> children;
  String path;

  ListNode({this.children = const [], this.path = ""});

  UnmodifiableListView<Node<T>> get nodes => children;
}

class MapNode<T> with NodeView<T> implements Node<T> {
  final Map<String, Node<T>> children;
  String path;

  MapNode({this.children = const {}, this.path});

  UnmodifiableListView<Node<T>> get nodes => children.values;
}

mixin NodeView<T> {
  bool isExpanded = false;

  String get key => UniqueKey().toString();

  String path;

  int get level => Node.PATH_SEPARATOR.allMatches(path).length - 1;

  String get childrenPath => "$path${Node.PATH_SEPARATOR}$key";

  UnmodifiableListView<Node<T>> get nodes;
}

abstract class Node<T> {
  static const PATH_SEPARATOR = ".";
  static const ROOT_KEY = "/";

  String get key;

  Object get children;

  String path;

  bool isExpanded;

  int get level;

  String get childrenPath;
}

abstract class Tree<T> {
  void add(T value, {String path});

  void remove(T element, {String path});

  void addAll(Iterable<T> iterable, {String path});

  void removeAll(Iterable<T> iterable, {String path});

  void removeWhere(bool test(T element), {String path});

  void clear({String path});

  T elementAt(String path);

  T operator [](covariant dynamic at);

  void operator []=(covariant dynamic at, T value);

  int get length;
}

abstract class IndexedTree<T> extends Tree<T> {
  void insert(int index, T element, {String path});

  void insertAll(int index, Iterable<T> iterable, {String path});

  void insertAfter(T element, {String path});

  void insertBefore(T element, {String path});

  T removeAt(int index, {String path});

  set first(T value);

  T get first;

  set last(T value);

  T get last;

  int indexWhere(bool test(T element), {int start = 0, String path});

  T firstWhere(bool test(T element), {T orElse(), String path});

  T lastWhere(bool test(T element), {T orElse(), String path});
}
