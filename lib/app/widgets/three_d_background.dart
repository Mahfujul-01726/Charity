import 'package:flutter/material.dart';
import 'dart:ui';

class ThreeDBackground extends StatefulWidget {
  final Widget child;
  final bool isDark;

  const ThreeDBackground({super.key, required this.child, this.isDark = false});

  @override
  State<ThreeDBackground> createState() => _ThreeDBackgroundState();
}

class _ThreeDBackgroundState extends State<ThreeDBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base Gradient with animated pulse
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: widget.isDark
                      ? [
                          Color.lerp(
                            const Color(0xFF4C1D95),
                            const Color(0xFF1E1B4B),
                            _controller.value,
                          )!,
                          const Color(0xFF1E1B4B),
                        ]
                      : [
                          Color.lerp(
                            const Color(0xFF6366F1),
                            const Color(0xFF8B5CF6),
                            _controller.value,
                          )!,
                          const Color(0xFF8B5CF6),
                        ],
                ),
              ),
            );
          },
        ),

        // Floating 3D Orb 1 (Top Right)
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Positioned(
              top: -60 + (_controller.value * 20),
              right: -60 + (_controller.value * -10),
              child: Transform.rotate(
                angle: _controller.value * 0.1,
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.white.withOpacity(0.1),
                        Colors.white.withOpacity(0.0),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: widget.isDark
                            ? Colors.purple.withOpacity(0.3)
                            : Colors.indigo.withOpacity(0.2),
                        blurRadius: 50,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.favorite_rounded,
                    size: 150,
                    color: Colors.white.withOpacity(0.05),
                  ),
                ),
              ),
            );
          },
        ),

        // Floating 3D Orb 2 (Bottom Left)
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Positioned(
              bottom: 40 + (_controller.value * -20),
              left: -40 + (_controller.value * 10),
              child: Transform.rotate(
                angle: -_controller.value * 0.1,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.pink.withOpacity(0.1),
                        Colors.transparent,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: widget.isDark
                            ? Colors.blue.withOpacity(0.3)
                            : Colors.pink.withOpacity(0.2),
                        blurRadius: 60,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.volunteer_activism_rounded,
                    size: 100,
                    color: Colors.white.withOpacity(0.05),
                  ),
                ),
              ),
            );
          },
        ),

        // Floating Particles
        ...List.generate(5, (index) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Positioned(
                top:
                    100 +
                    (index * 150) +
                    (_controller.value * (index % 2 == 0 ? 50 : -50)),
                left: 50 + (index * 80) + (_controller.value * 30),
                child: Container(
                  width: 10 + (index * 3).toDouble(),
                  height: 10 + (index * 3).toDouble(),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1 + (index * 0.05)),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.2),
                        blurRadius: 15,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),

        // Additional Bottom Orb for Full Screen Depth
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Positioned(
              bottom: -100,
              right: -50,
              child: Transform.rotate(
                angle: _controller.value * 0.2,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.purpleAccent.withOpacity(0.2),
                        Colors.transparent,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple.withOpacity(0.3),
                        blurRadius: 80,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),

        // Depth Layer (Blur) for Glass Effect
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: const BoxDecoration(color: Colors.transparent),
            ),
          ),
        ),

        // Content
        Positioned.fill(child: widget.child),
      ],
    );
  }
}
