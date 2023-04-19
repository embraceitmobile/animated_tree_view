import 'package:flutter/material.dart';

enum CornerCap { square, round }

class Indent extends StatelessWidget {
  final Indentation indentation;

  const Indent({super.key, required this.indentation});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(indentation.width, indentation.height ?? double.infinity),
      painter: IndentationPainter(indentation),
    );
  }
}

class IndentationPainter extends CustomPainter {
  final Indentation indentation;

  const IndentationPainter(this.indentation);

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = indentation.decoration.lineWidth ?? 1;
    final paint = Paint()
      ..color = indentation.decoration.color ?? Colors.grey[700]!
      ..style = PaintingStyle.fill;

    final center = size / 2;

    final origin = Offset(
      center.width + indentation.offset.dx,
      0,
    );

    final cornerOuter = Offset(
      center.width + indentation.offset.dx - strokeWidth / 2,
      center.height + indentation.offset.dy + strokeWidth / 2,
    );

    final cornerInner = Offset(
      center.width + indentation.offset.dx + (strokeWidth * 1.5),
      center.height + indentation.offset.dy + strokeWidth / 2,
    );

    final end = Offset(
      size.width,
      center.height + indentation.offset.dy,
    );

    final path = Path();
    path.moveTo(origin.dx - strokeWidth / 2, origin.dy);

    switch (indentation.decoration.cornerCap) {
      case CornerCap.round:
        path.lineTo(cornerOuter.dx, cornerOuter.dy - (strokeWidth * 2));
        path.relativeArcToPoint(
          Offset(strokeWidth * 2, strokeWidth * 2),
          radius: Radius.circular(strokeWidth * 2),
          clockwise: false,
        );
        path.lineTo(end.dx, cornerOuter.dy);
        path.relativeLineTo(0, -(strokeWidth));
        path.lineTo(cornerInner.dx, cornerInner.dy - strokeWidth);
        path.relativeArcToPoint(
          Offset(-strokeWidth, -strokeWidth),
          radius: Radius.circular(strokeWidth),
          clockwise: true,
        );
        break;
      case CornerCap.square:
      default:
        path.lineTo(cornerOuter.dx, cornerOuter.dy);
        path.lineTo(end.dx, end.dy + strokeWidth / 2);
        path.relativeLineTo(0, -strokeWidth);
        path.lineTo(origin.dx + strokeWidth / 2, end.dy - strokeWidth / 2);
        break;
    }

    path.lineTo(origin.dx + strokeWidth / 2, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(IndentationPainter oldDelegate) {
    return indentation != oldDelegate.indentation;
  }
}

class Indentation {
  final double width;
  final double? height;
  final Offset offset;
  final IndentationDecoration decoration;

  const Indentation({
    this.width = 24.0,
    this.height,
    this.offset = Offset.zero,
    this.decoration = const IndentationDecoration(),
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Indentation &&
          runtimeType == other.runtimeType &&
          width == other.width &&
          height == other.height &&
          offset == other.offset &&
          decoration == other.decoration;

  @override
  int get hashCode => width.hashCode ^ height.hashCode ^ decoration.hashCode;
}

class IndentationDecoration {
  final double? lineWidth;
  final CornerCap? cornerCap;
  final Color? color;

  const IndentationDecoration({
    this.lineWidth,
    this.cornerCap,
    this.color,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IndentationDecoration &&
          runtimeType == other.runtimeType &&
          lineWidth == other.lineWidth &&
          color == other.color &&
          cornerCap == other.cornerCap;

  @override
  int get hashCode => lineWidth.hashCode ^ color.hashCode;
}
