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
