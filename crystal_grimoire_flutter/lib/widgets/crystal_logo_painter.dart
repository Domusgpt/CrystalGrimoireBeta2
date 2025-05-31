import 'package:flutter/material.dart';
import 'dart:math' as math;

class CrystalLogoPainter extends CustomPainter {
  final Animation<double>? animation;
  
  CrystalLogoPainter({this.animation}) : super(repaint: animation);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF00BCD4), // Teal
          Color(0xFFFF5722), // Orange
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    
    final glowPaint = Paint()
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 8)
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF00BCD4).withOpacity(0.6),
          Color(0xFFFF5722).withOpacity(0.6),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    
    final path = Path();
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    
    // Draw glow effect first
    _drawCrystalShape(canvas, size, glowPaint);
    
    // Draw main crystal shape
    _drawCrystalShape(canvas, size, paint);
    
    // Add inner facets for depth
    final innerPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = Colors.white.withOpacity(0.6);
    
    // Draw inner lines for crystal facets
    canvas.drawLine(
      Offset(centerX, centerY - size.height * 0.4),
      Offset(centerX, centerY + size.height * 0.4),
      innerPaint,
    );
    
    // Add horizontal facet lines
    canvas.drawLine(
      Offset(centerX - size.width * 0.3, centerY - size.height * 0.1),
      Offset(centerX + size.width * 0.3, centerY - size.height * 0.1),
      innerPaint,
    );
    
    canvas.drawLine(
      Offset(centerX - size.width * 0.3, centerY + size.height * 0.1),
      Offset(centerX + size.width * 0.3, centerY + size.height * 0.1),
      innerPaint,
    );
    
    // Add sparkle effects if animated
    if (animation != null) {
      _drawSparkles(canvas, size, animation!.value);
    }
  }
  
  void _drawCrystalShape(Canvas canvas, Size size, Paint paint) {
    final path = Path();
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    
    // Create hexagonal crystal shape
    path.moveTo(centerX, centerY - size.height * 0.4);
    path.lineTo(centerX + size.width * 0.3, centerY - size.height * 0.2);
    path.lineTo(centerX + size.width * 0.3, centerY + size.height * 0.1);
    path.lineTo(centerX, centerY + size.height * 0.4);
    path.lineTo(centerX - size.width * 0.3, centerY + size.height * 0.1);
    path.lineTo(centerX - size.width * 0.3, centerY - size.height * 0.2);
    path.close();
    
    canvas.drawPath(path, paint);
  }
  
  void _drawSparkles(Canvas canvas, Size size, double animationValue) {
    final sparklePaint = Paint()
      ..color = Colors.white.withOpacity(0.8 * (1 - animationValue))
      ..style = PaintingStyle.fill;
    
    final sparklePositions = [
      Offset(size.width * 0.2, size.height * 0.2),
      Offset(size.width * 0.8, size.height * 0.3),
      Offset(size.width * 0.3, size.height * 0.7),
      Offset(size.width * 0.7, size.height * 0.8),
    ];
    
    for (final position in sparklePositions) {
      final sparkleSize = 3.0 * (1 + animationValue);
      canvas.drawCircle(position, sparkleSize, sparklePaint);
    }
  }
  
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => animation != null;
}

class AnimatedCrystalLogo extends StatefulWidget {
  final double size;
  
  const AnimatedCrystalLogo({Key? key, this.size = 80}) : super(key: key);
  
  @override
  State<AnimatedCrystalLogo> createState() => _AnimatedCrystalLogoState();
}

class _AnimatedCrystalLogoState extends State<AnimatedCrystalLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    
    _controller.repeat();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: widget.size,
      child: CustomPaint(
        painter: CrystalLogoPainter(animation: _animation),
        size: Size(widget.size, widget.size),
      ),
    );
  }
}