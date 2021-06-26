import 'package:flutter/material.dart';

class ExpansionIndicator {
  final Widget expandIcon;
  final Widget collapseIcon;
  final Alignment alignment;
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
