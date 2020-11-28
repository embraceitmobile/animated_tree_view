import 'package:flutter/material.dart';
import 'node.dart';

class MapTree<T> implements Tree<T> {
  MapTree({this.children = const {}});

  final Map<String, Node<T>> children;

  @override
  int get length => children.length;

  T operator [](String at) {
    // TODO: implement []
    throw UnimplementedError();
  }

  void operator []=(String at, T value) {
    // TODO: implement []=
  }

  void add(T value, {String path}) {
    // TODO: implement add
  }

  void addAll(Iterable<T> iterable, {String path}) {
    // TODO: implement addAll
  }

  void clear({String path}) {
    // TODO: implement clear
  }

  T elementAt(String path) {
    // TODO: implement elementAt
    throw UnimplementedError();
  }

  void remove(T element, {String path}) {
    // TODO: implement remove
  }

  void removeAll(Iterable<T> iterable, {String path}) {
    // TODO: implement removeAll
  }

  void removeWhere(bool Function(T element) test, {String path}) {
    // TODO: implement removeWhere
  }
}
