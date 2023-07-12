import 'dart:async';
import 'dart:ui';

import 'package:flutter/gestures.dart';

class SingleDoubleTapGestureRecognizer extends GestureRecognizer {
  final Duration doubleTapDelay;
  final VoidCallback? onSingleTap;
  final VoidCallback? onDoubleTap;

  Timer? _doubleTapTimer;

  SingleDoubleTapGestureRecognizer({
    this.doubleTapDelay = const Duration(milliseconds: 300),
    this.onSingleTap,
    this.onDoubleTap,
  });

  @override
  void addPointer(PointerDownEvent event) {
    if (_doubleTapTimer == null || _doubleTapTimer?.isActive == false) {
      _doubleTapTimer = Timer(doubleTapDelay, () {
        if (onSingleTap != null) onSingleTap!();
        _doubleTapTimer = null;
      });
    } else {
      _doubleTapTimer?.cancel();
      if (onDoubleTap != null) onDoubleTap!();
      _doubleTapTimer = null;
    }
  }

  @override
  void acceptGesture(int pointer) {}

  @override
  String get debugDescription => 'single-double-tap';

  void didStopTrackingLastPointer(int pointer) {}

  @override
  void dispose() {
    _doubleTapTimer?.cancel();
    super.dispose();
  }

  @override
  void rejectGesture(int pointer) {}

  @override
  void resolve(GestureDisposition disposition) {}
}
