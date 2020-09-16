import 'package:flutter/material.dart';
import 'package:multi_level_list_view/models/entry.dart';

class ListItemContainer<T extends Entry> extends StatelessWidget {
  final Animation<double> animation;
  final ValueSetter<T> onTap;
  final T item;
  final bool showExpansionIndicator;
  final Icon expandedIndicatorIcon;
  final double indentPadding;
  final Widget child;

  const ListItemContainer({
    Key key,
    @required this.animation,
    @required this.onTap,
    @required this.child,
    @required this.item,
    this.expandedIndicatorIcon,
    this.indentPadding,
    this.showExpansionIndicator = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      axis: Axis.vertical,
      sizeFactor: CurvedAnimation(parent: animation, curve: Curves.easeOut),
      child: InkWell(
        onTap: () => onTap(item),
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
