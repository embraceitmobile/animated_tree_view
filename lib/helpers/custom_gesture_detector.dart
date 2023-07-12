import 'dart:async';

import 'package:flutter/material.dart';

class CustomGestureDetector extends StatefulWidget {
  final Widget child;
  final VoidCallback? onSingleTap;
  final VoidCallback? onDoubleTap;
  CustomGestureDetector({
    required this.child,
    this.onSingleTap,
    this.onDoubleTap,
  });

  @override
  _CustomGestureDetectorState createState() => _CustomGestureDetectorState();
}

class _CustomGestureDetectorState extends State<CustomGestureDetector> {
  final double swipeThreshold = 10.0;
  final Duration doubleTapDelay = Duration(milliseconds: 300);

  Timer? _doubleTapTimer;
  Offset? _initialPosition;
  bool _isSwiping = false;
  bool _isLongPress = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _handlePointerDown,
      onPointerMove: _handlePointerMove,
      onPointerUp: _handlePointerUp,
      onPointerCancel: _handlePointerCancel, // Handle long press
      child: widget.child,
    );
  }

  void _handlePointerDown(PointerDownEvent event) {
    _initialPosition = event.position;
    _isLongPress = false; // Reset long press flag
    _doubleTapTimer ??= Timer(doubleTapDelay, () {
      if (!_isSwiping && !_isLongPress && widget.onSingleTap != null) {
        widget.onSingleTap!();
      }
      _doubleTapTimer = null;
    });
  }

  void _handlePointerMove(PointerMoveEvent event) {
    if (_initialPosition != null) {
      final gestureDistance = event.position - _initialPosition!;
      if (gestureDistance.distance > swipeThreshold) {
        _isSwiping = true;
        _doubleTapTimer?.cancel();
        _doubleTapTimer = null;
      }
    }
  }

  void _handlePointerUp(PointerUpEvent event) {
    _initialPosition = null;
    if (!_isSwiping && !_isLongPress && widget.onDoubleTap != null) {
      _doubleTapTimer?.cancel();
      _doubleTapTimer = null;
      widget.onDoubleTap!();
    }
    _isSwiping = false;
  }

  void _handlePointerCancel(PointerCancelEvent event) {
    _isLongPress = true;
  }

  @override
  void dispose() {
    _doubleTapTimer?.cancel();
    super.dispose();
  }
}
