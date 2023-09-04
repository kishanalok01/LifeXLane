import 'dart:math';
import 'package:flutter/material.dart';

class SuccessAnimation extends StatefulWidget {
  @override
  _SuccessAnimationState createState() => _SuccessAnimationState();
}

class _SuccessAnimationState extends State<SuccessAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          painter: _SuccessPainter(progress: _animation.value),
          child: Container(),
        );
      },
    );
  }
}

class _SuccessPainter extends CustomPainter {
  final double progress;

  _SuccessPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0;

    final double angle = pi * 2 * progress;
    final double radius = size.width / 2;
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double tickLength = size.width * 0.3;

    final Path path = Path();
    path.moveTo(center.dx - radius * 0.5, center.dy);
    path.lineTo(center.dx - radius * 0.1, center.dy + tickLength * 0.4);
    path.lineTo(center.dx + radius * 0.5, center.dy - tickLength * 0.6);

    final Path animatedPath = Path.combine(
      PathOperation.intersect,
      path,
      Path()..addArc(Rect.fromCircle(center: center, radius: radius), 0, angle),
    );

    canvas.drawPath(animatedPath, paint);
  }

  @override
  bool shouldRepaint(_SuccessPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
