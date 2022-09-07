import 'package:flutter/foundation.dart';
import 'package:value_notifier_ext/value_notifier_ext.dart';

extension ValueListenableExt<A> on ValueListenable<A> {
  ValueListenable<B> map<B>(B Function(A a) f) => MapValueNotifier(this, f);
}

class MapValueNotifier<A, B> extends LazyChangeNotifier
    implements ValueListenable<B> {
  MapValueNotifier(this._parent, this._transform);

  final ValueListenable<A> _parent;
  final B Function(A a) _transform;

  @override
  B get value => _transform(_parent.value);

  @override
  void resume() {
    _parent.addListener(notifyListeners);
  }

  @override
  void pause() {
    _parent.removeListener(notifyListeners);
  }
}
