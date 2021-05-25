import 'package:flutter/material.dart';
import 'package:tree_structure_view/node/base/i_node.dart';

class ExpandableNodeContainer<T extends INode<T>> extends StatelessWidget {
  final Animation<double> animation;
  final ValueSetter<T>? onTap;
  final T item;
  final bool showExpansionIndicator;
  final Icon expandedIndicatorIcon;
  final double indentPadding;
  final Widget child;

  const ExpandableNodeContainer({
    Key? key,
    required this.animation,
    required this.onTap,
    required this.child,
    required this.item,
    required this.expandedIndicatorIcon,
    required this.indentPadding,
    required this.showExpansionIndicator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      axis: Axis.vertical,
      sizeFactor: CurvedAnimation(parent: animation, curve: Curves.easeOut),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => onTap!(item),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: indentPadding),
              child: child,
            ),
            if (showExpansionIndicator)
              Align(
                alignment: Alignment.topRight,
                child: expandedIndicatorIcon,
              ),
          ],
        ),
      ),
    );
  }
}
