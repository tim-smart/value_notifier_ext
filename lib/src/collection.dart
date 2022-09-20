import 'package:flutter/foundation.dart';
import 'package:value_notifier_ext/value_notifier_ext.dart';

class ValueNotifierCollection<A> extends LazyChangeNotifier
    implements ValueListenable<Iterable<A>> {
  ValueNotifierCollection(Iterable<ValueNotifier<A>> notifiers)
      : _notifiers = notifiers.toList();

  factory ValueNotifierCollection.seed(Iterable<A> iterable) =>
      ValueNotifierCollection(iterable.map(ValueNotifier.new));

  factory ValueNotifierCollection.empty() => ValueNotifierCollection(const []);

  static ValueNotifier<A> Function(ValueNotifierCollection<A> coll) Function(
      Id id) finder<A, Id>(
          Id Function(A a) f) =>
      (id) => (coll) => coll.notifiers.firstWhere((n) => f(n.value) == id);

  final List<ValueNotifier<A>> _notifiers;
  Iterable<ValueNotifier<A>> get notifiers => _notifiers;

  int get length => _notifiers.length;

  operator [](int index) => _notifiers[index];

  @override
  Iterable<A> get value => _notifiers.map((n) => n.value);

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
