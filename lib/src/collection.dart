import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:value_notifier_ext/value_notifier_ext.dart';

class ValueNotifierCollection<A> extends LazyChangeNotifier
    implements ValueListenable<List<ValueNotifier<A>>> {
  ValueNotifierCollection(
    Iterable<ValueNotifier<A>> notifiers, {
    int? hashCodeOverride,
  })  : _notifiers = notifiers.toList(),
        _hashCodeOverride = hashCodeOverride;

  factory ValueNotifierCollection.seed(Iterable<A> iterable) =>
      ValueNotifierCollection(
        iterable.map(ValueNotifier.new),
        hashCodeOverride: const ListEquality().hash(iterable.toList()),
      );

  factory ValueNotifierCollection.empty() => ValueNotifierCollection(
        const [],
        hashCodeOverride: const ListEquality().hash(const []),
      );

  final List<ValueNotifier<A>> _notifiers;

  int get length => _notifiers.length;

  operator [](int index) => _notifiers[index];

  final int? _hashCodeOverride;

  @override
  int get hashCode => _hashCodeOverride ?? super.hashCode;

  @override
  operator ==(other) =>
      other is ValueNotifierCollection<A> && other.hashCode == hashCode;

  @override
  List<ValueNotifier<A>> get value => _notifiers;

  @override
  void resume() {
    for (final n in _notifiers) {
      n.addListener(notifyListeners);
    }
  }

  @override
  void pause() {
    for (final n in _notifiers) {
      n.removeListener(notifyListeners);
    }
  }

  void add(ValueNotifier<A> notifier) {
    _notifiers.add(notifier);
    _register(notifier);
  }

  void insert(int index, ValueNotifier<A> notifier) {
    _notifiers.insert(index, notifier);
    _register(notifier);
  }

  void remove(ValueNotifier<A> notifier) {
    _notifiers.remove(notifier);

    if (hasListeners) {
      notifier.removeListener(notifyListeners);
      notifyListeners();
    }
  }

  void _register(ValueNotifier<A> notifier) {
    if (hasListeners) {
      notifier.addListener(notifyListeners);
      notifyListeners();
    }
  }
}
