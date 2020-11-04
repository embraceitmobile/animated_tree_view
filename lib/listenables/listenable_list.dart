import 'dart:math';
import 'package:flutter/foundation.dart';

/// A wrapper on the [List] that notifies the listeners whenever the state of the
/// wrapped list [_value] is mutated.
///
/// The [ListenableList] implements the [ValueListenable] interface, so it can
/// be easily used with [ValueListenableBuilder].
///
/// [ListenableList] is a full replacement for the normal [List] and it can be
/// used in place of [List] with the complete availability of [List] operations.
///
/// Please see the documentation of [List] for more details.
///
class ListenableList<T> extends ChangeNotifier
    with List<T>
    implements ValueListenable<List<T>> {
  ListenableList._(List<T> list) : _value = list;

  factory ListenableList([int length = 0]) {
    assert(length >= 0);
    return ListenableList._(List<T>(length));
  }

  factory ListenableList.filled(int length, T fill, {bool growable = false}) {
    assert(length >= 0);
    return ListenableList._(List<T>.filled(length, fill, growable: growable));
  }

  factory ListenableList.from(Iterable elements, {bool growable = true}) =>
      ListenableList._(List<T>.from(elements, growable: growable));

  factory ListenableList.of(Iterable<T> elements, {bool growable = true}) =>
      ListenableList._(List<T>.of(elements, growable: growable));

  factory ListenableList.generate(int length, T generator(int index),
      {bool growable = true}) {
    assert(length >= 0);
    return ListenableList._(
        List<T>.generate(length, generator, growable: growable));
  }

  factory ListenableList.unmodifiable(Iterable elements) =>
      ListenableList._(List<T>.unmodifiable(elements));

  List<T> _value;

  @override
  List<T> get value => _value;

  set value(List<T> newValue) {
    if (_value == newValue) return;
    _value = newValue;
    notifyListeners();
  }

  void forceUpdate() => notifyListeners();

  @override
  int get length => _value.length;

  @override
  set length(int newLength) {
    _value.length = newLength;
  }

  @override
  T get first => _value.first;

  @override
  T get last => _value.last;

  @override
  set first(T value) {
    _value.first = value;
    notifyListeners();
  }

  @override
  set last(T value) {
    _value.last = value;
    notifyListeners();
  }

  @override
  List<T> operator +(List<T> other) {
    _value += other;
    notifyListeners();
    return _value;
  }

  @override
  T operator [](int index) => _value[index];

  @override
  void operator []=(int index, T value) {
    _value[index] = value;
    notifyListeners();
  }

  @override
  void add(T value) {
    _value.add(value);
    notifyListeners();
  }

  @override
  void addAll(Iterable<T> iterable) {
    _value.addAll(iterable);
    notifyListeners();
  }

  @override
  bool any(bool Function(T element) test) => _value.any(test);

  @override
  Map<int, T> asMap() => _value.asMap();

  @override
  List<R> cast<R>() => _value.cast<R>();

  @override
  void clear() {
    _value.clear();
    notifyListeners();
  }

  @override
  bool contains(Object element) => _value.contains(element);

  @override
  T elementAt(int index) => _value.elementAt(index);

  @override
  bool every(bool Function(T element) test) => _value.every(test);

  @override
  void fillRange(int start, int end, [T fillValue]) {
    _value.fillRange(start, end, fillValue);
    notifyListeners();
  }

  @override
  T firstWhere(bool Function(T element) test, {T Function() orElse}) =>
      _value.firstWhere(test, orElse: orElse);

  @override
  Iterable<T> followedBy(Iterable<T> other) => _value.followedBy(other);

  @override
  void forEach(void Function(T element) f) {
    _value.forEach(f);
    notifyListeners();
  }

  @override
  Iterable<T> getRange(int start, int end) => _value.getRange(start, end);

  @override
  int indexOf(T element, [int start = 0]) => _value.indexOf(element, start);

  @override
  int indexWhere(bool Function(T element) test, [int start = 0]) =>
      _value.indexWhere(test, start);

  @override
  void insert(int index, T element) {
    _value.insert(index, element);
    notifyListeners();
  }

  @override
  void insertAll(int index, Iterable<T> iterable) {
    _value.insertAll(index, iterable);
    notifyListeners();
  }

  @override
  bool get isEmpty => _value.isEmpty;

  @override
  bool get isNotEmpty => _value.isNotEmpty;

  @override
  Iterator<T> get iterator => _value.iterator;

  @override
  String join([String separator = ""]) => _value.join(separator);

  @override
  int lastIndexOf(T element, [int start]) => _value.lastIndexOf(element, start);

  @override
  int lastIndexWhere(bool Function(T element) test, [int start]) =>
      _value.lastIndexWhere(test, start);

  @override
  T lastWhere(bool Function(T element) test, {T Function() orElse}) =>
      _value.lastWhere(test, orElse: orElse);

  @override
  bool remove(Object value) {
    final removed = _value.remove(value);
    notifyListeners();
    return removed;
  }

  @override
  T removeAt(int index) {
    final removed = _value.removeAt(index);
    notifyListeners();
    return removed;
  }

  @override
  T removeLast() {
    final removed = _value.removeLast();
    notifyListeners();
    return removed;
  }

  @override
  void removeRange(int start, int end) {
    _value.removeRange(start, end);
    notifyListeners();
  }

  @override
  void removeWhere(bool Function(T element) test) {
    _value.removeWhere(test);
    notifyListeners();
  }

  @override
  void replaceRange(int start, int end, Iterable<T> replacement) {
    _value.replaceRange(start, end, replacement);
    notifyListeners();
  }

  @override
  void retainWhere(bool Function(T element) test) {
    _value.retainWhere(test);
    notifyListeners();
  }

  @override
  Iterable<T> get reversed => _value.reversed;

  @override
  void setAll(int index, Iterable<T> iterable) {
    _value.setAll(index, iterable);
    notifyListeners();
  }

  @override
  void setRange(int start, int end, Iterable<T> iterable, [int skipCount = 0]) {
    _value.setRange(start, end, iterable, skipCount);
    notifyListeners();
  }

  @override
  void shuffle([Random random]) {
    _value.shuffle(random);
    notifyListeners();
  }

  @override
  T get single => _value.single;

  @override
  T singleWhere(bool Function(T element) test, {T Function() orElse}) =>
      _value.singleWhere(test, orElse: orElse);

  @override
  Iterable<T> skip(int count) => _value.skip(count);

  @override
  Iterable<T> skipWhile(bool Function(T value) test) => _value.skipWhile(test);

  @override
  void sort([int Function(T a, T b) compare]) {
    _value.sort(compare);
    notifyListeners();
  }

  @override
  List<T> sublist(int start, [int end]) => _value.sublist(start, end);

  @override
  Iterable<T> take(int count) => _value.take(count);

  @override
  Iterable<T> takeWhile(bool Function(T value) test) => _value.takeWhile(test);

  @override
  List<T> toList({bool growable = true}) => _value.toList(growable: growable);

  @override
  Set<T> toSet() => _value.toSet();

  @override
  Iterable<T> where(bool Function(T element) test) => _value.where(test);

  @override
  Iterable<T> whereType<T>() => _value.whereType<T>();

  @override
  T reduce(T Function(T value, T element) combine) => _value.reduce(combine);

  @override
  S fold<S>(S initialValue, S Function(S previousValue, T element) combine) =>
      _value.fold(initialValue, combine);

  @override
  Iterable<S> expand<S>(Iterable<S> Function(T element) f) => _value.expand(f);

  @override
  Iterable<S> map<S>(S Function(T e) f) => _value.map(f);
}
