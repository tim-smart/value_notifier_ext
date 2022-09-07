import 'package:flutter/foundation.dart';

extension ValueNotifierExt<A> on ValueNotifier<A> {
  ValueNotifier<A> update(A Function(A a) f) {
    value = f(value);
    return this;
  }

  ValueNotifier<A> put(A a) {
    value = a;
    return this;
  }
}
