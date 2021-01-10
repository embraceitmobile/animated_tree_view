import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A wrapper on the [Map] that notifies the listeners whenever the state of the
/// wrapped map [_value] is mutated.
///
/// The [ListenableMap] implements the [ValueListenable] interface, so it can
/// be easily used with [ValueListenableBuilder].
///
/// [ListenableMap] is a full replacement for the normal [Map] and it can be
/// used in place of [Map] with the complete availability of [Map] operations.
///
/// Please see the documentation of [Map] for more details.
///
class ListenableMap<K, V> extends ChangeNotifier
    with Map<K, V>
    implements ValueListenable<Map<K, V>> {
  ListenableMap._(Map<K, V> map) : _value = map;

  factory ListenableMap() => ListenableMap._(Map());

  factory ListenableMap.from(Map other) =>
      ListenableMap._(LinkedHashMap<K, V>.from(other));

  factory ListenableMap.of(Map<K, V> other) =>
      ListenableMap._(LinkedHashMap<K, V>.of(other));

  factory ListenableMap.identity() => ListenableMap._(LinkedHashMap.identity());

  factory ListenableMap.fromIterable(Iterable iterable,
          {K key(element)?, V value(element)?}) =>
      ListenableMap._(
          LinkedHashMap<K, V>.fromIterable(iterable, key: key, value: value));

  factory ListenableMap.fromIterables(Iterable<K> keys, Iterable<V> values) =>
      ListenableMap._(LinkedHashMap<K, V>.fromIterables(keys, values));

  factory ListenableMap.fromEntries(Iterable<MapEntry<K, V>> entries) =>
      ListenableMap._(LinkedHashMap<K, V>()..addEntries(entries));

  Map<K, V> _value;

  @protected
  @visibleForTesting
  @override
  Map<K, V> get value => _value;

  set value(Map<K, V> newValue) {
    if (_value == newValue) return;
    _value = newValue;
    notifyListeners();
  }

  @override
  V? operator [](Object? key) => _value[key as K];

  @override
  void operator []=(K key, V value) {
    _value[key] = value;
    notifyListeners();
  }

  @override
  void addAll(Map<K, V> other) {
    _value.addAll(other);
    notifyListeners();
  }

  @override
  void addEntries(Iterable<MapEntry<K, V>> newEntries) {
    _value.addEntries(newEntries);
    notifyListeners();
  }

  @override
  Map<RK, RV> cast<RK, RV>() {
    final cast = _value.cast();
    notifyListeners();
    return cast as Map<RK, RV>;
  }

  @override
  void clear() {
    _value.clear();
    notifyListeners();
  }

  @override
  bool containsKey(Object? key) => _value.containsKey(key);

  @override
  bool containsValue(Object? value) => _value.containsValue(value);

  @override
  Iterable<MapEntry<K, V>> get entries => _value.entries;

  @override
  void forEach(void Function(K key, V value) f) {
    _value.forEach(f);
    notifyListeners();
  }

  @override
  bool get isEmpty => _value.isEmpty;

  @override
  bool get isNotEmpty => _value.isNotEmpty;

  @override
  Iterable<K> get keys => _value.keys;

  @override
  int get length => _value.length;

  @override
  Map<K2, V2> map<K2, V2>(MapEntry<K2, V2> Function(K key, V value) f) {
    return _value.map(f);
  }

  @override
  V putIfAbsent(K key, V Function() ifAbsent) {
    final v = _value.putIfAbsent(key, ifAbsent);
    notifyListeners();
    return v;
  }

  @override
  V? remove(Object? key) {
    final v = _value.remove(key);
    notifyListeners();
    return v;
  }

  @override
  void removeWhere(bool Function(K key, V value) predicate) {
    _value.removeWhere((predicate));
    notifyListeners();
  }

  @override
  V update(K key, V Function(V value) update, {V Function()? ifAbsent}) {
    final v = _value.update(key, update, ifAbsent: ifAbsent);
    notifyListeners();
    return v;
  }

  @override
  void updateAll(V Function(K key, V value) update) {
    _value.updateAll(update);
    notifyListeners();
  }

  @override
  Iterable<V> get values => _value.values;
}
