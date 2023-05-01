import 'package:animated_tree_view/tree_view/tree_node.dart';
import 'package:flutter/material.dart';

enum IndentStyle { none, scopingLine, squareJoint, roundJoint }

class Indent extends StatelessWidget {
  final Indentation indentation;
  final ITreeNode node;
  final Widget child;
  final int minLevelToIndent;

  const Indent({
    super.key,
    required this.indentation,
    required this.child,
    required this.node,
    required this.minLevelToIndent,
  });

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: EdgeInsets.only(
        left: (indentation.width * (node.level - minLevelToIndent)).clamp(
          0.0,
          double.maxFinite,
        ),
      ),
      child: child,
    );

    if (node.level <= minLevelToIndent ||
        indentation.decoration.style == IndentStyle.none) return content;

    return CustomPaint(
      foregroundPainter: IndentationPainter.fromIndentation(
        indentation: indentation,
        node: node,
        minLevelToIndent: minLevelToIndent,
      ),
      child: content,
    );
  }
}

class IndentationPainter extends CustomPainter {
  final double indentWidth;
  final IndentationDecoration decoration;
  final ITreeNode node;
  final int minLevelToIndent;

  const IndentationPainter({
    required this.indentWidth,
    required this.decoration,
    required this.node,
    required this.minLevelToIndent,
  });

  factory IndentationPainter.fromIndentation({
    required Indentation indentation,
    required ITreeNode node,
    required int minLevelToIndent,
  }) =>
      IndentationPainter(
        indentWidth: indentation.width,
        decoration: indentation.decoration,
        minLevelToIndent: minLevelToIndent,
        node: node,
      );

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = decoration.lineWidth;
    final totalWidth = (indentWidth * (node.level - minLevelToIndent))
        .clamp(0.0, double.maxFinite);
    final shouldDrawBottom = !node.isLastChild;

    final paint = Paint()
      ..color = decoration.color
      ..style = PaintingStyle.fill;

    final center = Size(totalWidth - 12, size.height / 2);

    final topOrigin = Offset(
      center.width + decoration.offset.dx,
      0,
    );

    final cornerOuter = Offset(
      center.width + decoration.offset.dx - strokeWidth / 2,
      center.height + decoration.offset.dy + strokeWidth / 2,
    );

    final cornerInner = Offset(
      center.width + decoration.offset.dx + (strokeWidth * 1.5),
      center.height + decoration.offset.dy + strokeWidth / 2,
    );

    final end = Offset(
      totalWidth,
      center.height + decoration.offset.dy,
    );

    final bottom = Offset(
      center.width + decoration.offset.dx,
      size.height,
    );

    switch (decoration.style) {
      case IndentStyle.scopingLine:
        canvas.drawRect(
            Rect.fromLTRB(
              topOrigin.dx - 0.35,
              topOrigin.dy,
              topOrigin.dx + strokeWidth - 0.35,
              bottom.dy,
            ),
            paint);
        break;
      case IndentStyle.roundJoint:
        _drawWithRoundedCorners(
          canvas: canvas,
          paint: paint,
          drawBottom: shouldDrawBottom,
          center: center,
          strokeWidth: strokeWidth,
          topOrigin: topOrigin,
          cornerOuter: cornerOuter,
          cornerInner: cornerInner,
          end: end,
          bottom: bottom,
        );
        break;
      case IndentStyle.squareJoint:
      default:
        _drawWithSquareCorners(
          canvas: canvas,
          paint: paint,
          drawBottom: shouldDrawBottom,
          center: center,
          strokeWidth: strokeWidth,
          topOrigin: topOrigin,
          cornerOuter: cornerOuter,
          cornerInner: cornerInner,
          end: end,
          bottom: bottom,
        );
        break;
    }

    if (node.parent != null)
      _drawScopingLines(
        canvas: canvas,
        origin: Offset(topOrigin.dx - indentWidth, topOrigin.dy),
        strokeWidth: strokeWidth,
        bottom: bottom.dy,
        node: node.parent! as ITreeNode,
        paint: paint,
        drawLastChild: decoration.style == IndentStyle.scopingLine,
      );
  }

  @override
  bool shouldRepaint(IndentationPainter oldDelegate) {
    return decoration != oldDelegate.decoration ||
        indentWidth != oldDelegate.indentWidth;
  }

  void _drawWithRoundedCorners({
    required Canvas canvas,
    required Paint paint,
    required double strokeWidth,
    required Size center,
    required Offset topOrigin,
    required Offset cornerOuter,
    required Offset cornerInner,
    required Offset end,
    required Offset bottom,
    required bool drawBottom,
  }) {
    final pathTop = Path()
      ..moveTo(topOrigin.dx - strokeWidth / 2, topOrigin.dy)
      ..lineTo(cornerOuter.dx, cornerOuter.dy - (strokeWidth * 2))
      ..relativeArcToPoint(
        Offset(strokeWidth * 2, strokeWidth * 2),
        radius: Radius.circular(strokeWidth * 2),
        clockwise: false,
      )
      ..lineTo(end.dx, cornerOuter.dy)
      ..relativeLineTo(0, -strokeWidth)
      ..lineTo(cornerInner.dx, cornerInner.dy - strokeWidth)
      ..relativeArcToPoint(
        Offset(-strokeWidth, -strokeWidth),
        radius: Radius.circular(strokeWidth),
        clockwise: true,
      )
      ..lineTo(topOrigin.dx + strokeWidth / 2, 0)
      ..close();

    if (!drawBottom) {
      canvas.drawPath(pathTop, paint);
      return;
    }

    final pathBottom = Path()
      ..moveTo(cornerInner.dx, cornerInner.dy - strokeWidth)
      ..relativeArcToPoint(
        Offset(-strokeWidth * 2, strokeWidth * 2),
        radius: Radius.circular(strokeWidth * 2),
        clockwise: false,
      )
      ..lineTo(cornerOuter.dx, bottom.dy)
      ..relativeLineTo(strokeWidth, 0)
      ..lineTo(cornerOuter.dx + strokeWidth, cornerInner.dy + strokeWidth)
      ..relativeArcToPoint(
        Offset(strokeWidth, -strokeWidth),
        radius: Radius.circular(strokeWidth),
        clockwise: true,
      )
      ..close();

    final combinedPath = Path.combine(PathOperation.union, pathTop, pathBottom);
    canvas.drawPath(combinedPath, paint);
  }

  void _drawWithSquareCorners({
    required Canvas canvas,
    required Paint paint,
    required double strokeWidth,
    required Size center,
    required Offset topOrigin,
    required Offset cornerOuter,
    required Offset cornerInner,
    required Offset end,
    required Offset bottom,
    required bool drawBottom,
  }) {
    final pathTop = Path()
      ..moveTo(topOrigin.dx - strokeWidth / 2, topOrigin.dy)
      ..lineTo(cornerOuter.dx, cornerOuter.dy)
      ..lineTo(end.dx, end.dy + strokeWidth / 2)
      ..relativeLineTo(0, -strokeWidth)
      ..lineTo(topOrigin.dx + strokeWidth / 2, end.dy - strokeWidth / 2)
      ..lineTo(topOrigin.dx + strokeWidth / 2, 0)
      ..close();

    if (!drawBottom) {
      canvas.drawPath(pathTop, paint);
      return;
    }

    final pathBottom = Path()
      ..moveTo(cornerOuter.dx, cornerOuter.dy)
      ..lineTo(cornerOuter.dx, bottom.dy)
      ..relativeLineTo(strokeWidth, 0)
      ..lineTo(cornerOuter.dx + strokeWidth, cornerOuter.dy)
      ..close();

    final combinedPath = Path.combine(PathOperation.union, pathTop, pathBottom);
    canvas.drawPath(combinedPath, paint);
  }

  void _drawScopingLines({
    required Canvas canvas,
    required Offset origin,
    required double strokeWidth,
    required double bottom,
    required ITreeNode node,
    required Paint paint,
    bool drawLastChild = false,
  }) {
    if (drawLastChild || node.isLastChild == false)
      canvas.drawRect(
          Rect.fromLTRB(
            origin.dx - 0.5,
            origin.dy,
            origin.dx + strokeWidth - 0.5,
            bottom,
          ),
          paint);

    if (node.parent != null) {
      _drawScopingLines(
        canvas: canvas,
        origin: Offset(origin.dx - indentWidth, origin.dy),
        strokeWidth: strokeWidth,
        bottom: bottom,
        node: node.parent! as ITreeNode,
        paint: paint,
        drawLastChild: drawLastChild,
      );
    }
  }
}

class Indentation {
  static const DEF_INDENT_WIDTH = 24.0;

  final double width;
  final IndentationDecoration decoration;

  const Indentation({
    this.width = DEF_INDENT_WIDTH,
    this.decoration = const IndentationDecoration(style: IndentStyle.none),
  });

  Indentation copyWith({IndentationDecoration? decoration}) => Indentation(
        width: width,
        decoration: decoration ?? this.decoration,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Indentation &&
          runtimeType == other.runtimeType &&
          width == other.width &&
          decoration == other.decoration;

  @override
  int get hashCode => width.hashCode ^ decoration.hashCode;
}

class IndentationDecoration {
  final Offset offset;
  final double lineWidth;
  final IndentStyle style;
  final Color color;

  const IndentationDecoration({
    this.lineWidth = 1,
    this.style = IndentStyle.roundJoint,
    this.color = const Color(0xFFBDBDBD),
    this.offset = Offset.zero,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IndentationDecoration &&
          runtimeType == other.runtimeType &&
          lineWidth == other.lineWidth &&
          color == other.color &&
          offset == other.offset &&
          style == other.style;

  @override
  int get hashCode => lineWidth.hashCode ^ color.hashCode;

  @override
  String toString() {
    return 'IndentationDecoration{offset: $offset, lineWidth: $lineWidth, cornerCap: $style, color: $color}';
  }
}
