import 'package:animated_tree_view/constants/constants.dart';
import 'package:flutter/material.dart';

import 'tree_node.dart';

abstract class ExpansionIndicator extends StatefulWidget {
  /// Value to set the expansion state of the indicator
  final ITreeNode tree;

  /// By default the [alignment] is [Alignment.topRight]
  final Alignment alignment;

  /// The [padding] around the [expandIcon] and [collapseIcon]
  final EdgeInsets padding;

  /// The animation curve for the expansion indicator animation
  final Curve curve;

  ExpansionIndicator({
    Key? key,
    required this.tree,
    this.alignment = Alignment.topRight,
    this.padding = EdgeInsets.zero,
    this.curve = Curves.easeOut,
  }) : super(key: key ?? ValueKey(tree.key));
}

abstract class ExpansionIndicatorState<T extends ExpansionIndicator>
    extends State<T> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: animationDuration,
    vsync: this,
  );

  @override
  void initState() {
    super.initState();
    widget.tree.expansionNotifier.addListener(_onExpandedChangeListener);
    if (widget.tree.isExpanded) _controller.value = 1;
  }

  void _onExpandedChangeListener() {
    if (!mounted) return;

    if (widget.tree.isExpanded)
      _controller.animateTo(1, curve: widget.curve);
    else
      _controller.animateBack(0, curve: widget.curve);
  }

  @override
  void dispose() {
    _controller.dispose();
    widget.tree.removeListener(_onExpandedChangeListener);
    super.dispose();
  }
}

class ChevronIndicator extends ExpansionIndicator {
  final Tween<double> tween;
  final IconData icon;

  ChevronIndicator._({
    super.key,
    required super.tree,
    required this.tween,
    required this.icon,
    super.alignment,
    super.padding,
    super.curve,
  });

  factory ChevronIndicator.rightDown({
    Key? key,
    required ITreeNode tree,
    Alignment alignment = Alignment.topRight,
    EdgeInsets padding = EdgeInsets.zero,
    Curve curve = Curves.linearToEaseOut,
  }) =>
      ChevronIndicator._(
        key: key,
        tree: tree,
        tween: Tween(begin: 0, end: 0.25),
        icon: Icons.keyboard_arrow_right_rounded,
        alignment: alignment,
        padding: padding,
        curve: curve,
      );

  factory ChevronIndicator.upDown({
    Key? key,
    required ITreeNode tree,
    Alignment alignment = Alignment.topRight,
    EdgeInsets padding = EdgeInsets.zero,
    Curve curve = Curves.linearToEaseOut,
  }) =>
      ChevronIndicator._(
        key: key,
        tree: tree,
        tween: Tween(begin: 0, end: 0.50),
        icon: Icons.keyboard_arrow_up_rounded,
        alignment: alignment,
        padding: padding,
        curve: curve,
      );

  @override
  State<StatefulWidget> createState() => _RotatedIndicatorState();
}

class _RotatedIndicatorState extends ExpansionIndicatorState<ChevronIndicator> {
  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: widget.tween.animate(_controller),
      child: Icon(widget.icon),
    );
  }
}

class PlusMinusIndicator extends ExpansionIndicator {
  PlusMinusIndicator({
    required ITreeNode tree,
    Key? key,
    Alignment alignment = Alignment.topRight,
    EdgeInsets padding = EdgeInsets.zero,
    Curve curve = Curves.easeOutExpo,
  }) : super(
          key: key,
          tree: tree,
          alignment: alignment,
          padding: padding,
          curve: curve,
        );

  @override
  State<StatefulWidget> createState() => _PlusMinusIndicatorState();
}

class _PlusMinusIndicatorState
    extends ExpansionIndicatorState<PlusMinusIndicator> {
  late final tween = Tween<double>(begin: 0, end: 0.25);

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 24,
      child: Stack(
        children: [
          RotationTransition(
            turns: tween.animate(_controller),
            child: RotatedBox(quarterTurns: 1, child: Icon(Icons.remove)),
          ),
          Icon(Icons.remove),
        ],
      ),
    );
  }
}
