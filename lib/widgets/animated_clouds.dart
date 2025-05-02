import 'package:flutter/material.dart';
import 'dart:math';

class AnimatedClouds extends StatefulWidget {
  final int numberOfClouds;

  const AnimatedClouds({
    Key? key,
    required this.numberOfClouds,
  }) : super(key: key);

  @override
  State<AnimatedClouds> createState() => _AnimatedCloudsState();
}

class _AnimatedCloudsState extends State<AnimatedClouds>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;
  late List<double> _positions;
  late List<double> _sizes;
  late List<double> _opacities;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    final random = Random();
    _controllers = List.generate(
      widget.numberOfClouds,
      (index) => AnimationController(
        duration: Duration(seconds: random.nextInt(10) + 20),
        vsync: this,
      ),
    );

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: -0.2, end: 1.2).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.linear,
        ),
      );
    }).toList();

    _positions = List.generate(
      widget.numberOfClouds,
      (index) => random.nextDouble(),
    );

    _sizes = List.generate(
      widget.numberOfClouds,
      (index) => random.nextDouble() * 0.4 + 0.2,
    );

    _opacities = List.generate(
      widget.numberOfClouds,
      (index) => random.nextDouble() * 0.3 + 0.1,
    );

    for (var controller in _controllers) {
      controller.repeat();
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(
        widget.numberOfClouds,
        (index) => AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Positioned(
              left:
                  MediaQuery.of(context).size.width * _animations[index].value,
              top: MediaQuery.of(context).size.height * _positions[index],
              child: Opacity(
                opacity: _opacities[index],
                child: Image.asset(
                  'assets/cloud.svg',
                  width: MediaQuery.of(context).size.width * _sizes[index],
                  height: MediaQuery.of(context).size.width * _sizes[index],
                  color: Colors.white,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
