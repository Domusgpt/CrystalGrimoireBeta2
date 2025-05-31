import 'package:flutter/material.dart';
import 'dart:math' as math;

class FloatingParticles extends StatefulWidget {
  final int particleCount;
  final Color color;
  final double speed;
  
  const FloatingParticles({
    Key? key,
    this.particleCount = 15,
    this.color = Colors.purpleAccent,
    this.speed = 1.0,
  }) : super(key: key);

  @override
  State<FloatingParticles> createState() => _FloatingParticlesState();
}

class _FloatingParticlesState extends State<FloatingParticles>
    with TickerProviderStateMixin {
  late List<Particle> particles;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    )..repeat();
    
    particles = List.generate(
      widget.particleCount,
      (index) => Particle(
        position: Offset(
          math.Random().nextDouble(),
          math.Random().nextDouble(),
        ),
        size: math.Random().nextDouble() * 4 + 2,
        speed: (math.Random().nextDouble() * 0.5 + 0.5) * widget.speed,
        opacity: math.Random().nextDouble() * 0.5 + 0.3,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: ParticlesPainter(
            particles: particles,
            color: widget.color,
            animation: _controller.value,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class Particle {
  Offset position;
  final double size;
  final double speed;
  final double opacity;

  Particle({
    required this.position,
    required this.size,
    required this.speed,
    required this.opacity,
  });
}

class ParticlesPainter extends CustomPainter {
  final List<Particle> particles;
  final Color color;
  final double animation;

  ParticlesPainter({
    required this.particles,
    required this.color,
    required this.animation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (var particle in particles) {
      // Update particle position
      particle.position = Offset(
        particle.position.dx,
        (particle.position.dy - animation * particle.speed * 0.1) % 1.0,
      );
      
      // Wrap around when particle goes off screen
      if (particle.position.dy < 0) {
        particle.position = Offset(
          math.Random().nextDouble(),
          1.0,
        );
      }

      // Draw particle
      paint.color = color.withOpacity(particle.opacity);
      canvas.drawCircle(
        Offset(
          particle.position.dx * size.width,
          particle.position.dy * size.height,
        ),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(ParticlesPainter oldDelegate) => true;
}