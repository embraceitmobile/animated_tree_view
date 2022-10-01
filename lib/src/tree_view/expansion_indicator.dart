import 'package:flutter/material.dart';

class ExpansionIndicator {
  /// An expansion indicator to show that the Node is currently in expanded state.
  /// It is typically an [Icon] widget.
  final Widget expandIcon;

  /// A collapse indicator to show that the Node is currently in collapsed state.
  /// It is typically an [Icon] widget.
  final Widget collapseIcon;

  /// Alignment of the [ExpansionIndicator] on the [ListTile].
  /// By default the [alignment] is [Alignment.topRight]
  final Alignment alignment;

  /// The [padding] around the [expandIcon] and [collapseIcon]
  final EdgeInsets padding;

  const ExpansionIndicator({
    required this.expandIcon,
    required this.collapseIcon,
    this.alignment = Alignment.topRight,
    this.padding = const EdgeInsets.all(4),
  });

  static const RightUpChevron = ExpansionIndicator(
    expandIcon: const Icon(Icons.keyboard_arrow_right),
    collapseIcon: const Icon(Icons.keyboard_arrow_up),
  );

  static const DownUpChevron = ExpansionIndicator(
    expandIcon: const Icon(Icons.keyboard_arrow_down),
    collapseIcon: const Icon(Icons.keyboard_arrow_up),
  );

  static const PlusMinus = ExpansionIndicator(
    expandIcon: const Icon(Icons.add),
    collapseIcon: const Icon(Icons.remove),
  );
}
