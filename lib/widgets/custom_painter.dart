import 'package:flutter/material.dart';

class CurvePainter extends CustomPainter {
  var color;
  CurvePainter({ this.color});
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = color;
    paint.style = PaintingStyle.fill; // Change this to fill

    var path = Path();

    path.moveTo(0, size.height);
    path.quadraticBezierTo(size.width / (1.7), size.height * (1.5), size.width,
        size.height * 0.98);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}