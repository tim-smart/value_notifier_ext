import 'package:flutter/material.dart';

abstract class LazyChangeNotifier extends ChangeNotifier {
  bool _running = false;

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);

    if (hasListeners && !_running) {
      _running = true;
      resume();
    }
  }

  @override
  void removeListener(VoidCallback listener) {
    super.removeListener(listener);

    if (!hasListeners) {
      _running = false;
      pause();
    }
  }

  void resume();
  void pause();
}
