import 'package:flutter/foundation.dart';
import 'package:value_notifier_ext/value_notifier_ext.dart';

extension ValueListenableExt<A> on ValueListenable<A> {
  ValueListenable<B> map<B>(B Function(A a) f) => MapValueNotifier(this, f);

  VoidCallback listen(void Function(A a) onValue) {
    void listenHandler() {
      onValue(value);
    }

    addListener(listenHandler);
    return () => removeListener(listenHandler);
  }
}

class MapValueNotifier<A, B> extends LazyChangeNotifier
    implements ValueListenable<B> {
  MapValueNotifier(this._parent, this._transform);

  final ValueListenable<A> _parent;
  final B Function(A a) _transform;
  B? _previousValue;

  @override
  B get value => _previousValue ?? _transform(_parent.value);

  @override
  void resume() {
    _previousValue = value;
    _parent.addListener(_maybeNotifyListeners);
  }

  @override
  void pause() {
    _parent.removeListener(_maybeNotifyListeners);
    _previousValue = null;
  }

  void _maybeNotifyListeners() {
    final newValue = _transform(_parent.value);

    if (_previousValue == newValue) {
      return;
    }

    _previousValue = newValue;
    notifyListeners();
  }
}
