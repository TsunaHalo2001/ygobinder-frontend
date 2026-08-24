import 'package:flutter/material.dart';
import 'dart:math' as math;

class SpinningCardLoader extends StatefulWidget {
  final double width;
  final double height;

  const SpinningCardLoader({
    super.key,
    this.width = 60,
    this.height = 84, // Standard card aspect ratio
  });

  @override
  State<SpinningCardLoader> createState() => _SpinningCardLoaderState();
}

class _SpinningCardLoaderState extends State<SpinningCardLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
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
        final angle = _controller.value * 2 * math.pi;

        // 1. setEntry(3, 2, 0.002) adds 3D perspective
        // 2. rotateX(0.25) tilts it slightly forward (inclination)
        // 3. rotateY(angle) spins it around the vertical axis
        final transform = Matrix4.identity()
          ..setEntry(3, 2, 0.002)
          ..rotateX(0.25)
          ..rotateY(angle);

        return Transform(
          alignment: Alignment.center,
          transform: transform,
          child: child,
        );
      },
      child: _buildCardDesign(),
    );
  }

  Widget _buildCardDesign() {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        // Classic Yu-Gi-Oh card back colors (Dark brown/orange gradient)
        gradient: const LinearGradient(
          colors: [Color(0xFF6D4C41), Color(0xFF3E2723)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        // Gold border
        border: Border.all(color: const Color(0xFFFFD54F), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            blurRadius: 12,
            offset: const Offset(0, 8), // Shadow drops down to enhance 3D effect
          ),
        ],
      ),
      child: Center(
        // The iconic swirl/eye symbol in the center
        child: Icon(
          Icons.auto_awesome,
          color: const Color(0xFFFFD54F),
          size: widget.width * 0.4,
        ),
      ),
    );
  }
}