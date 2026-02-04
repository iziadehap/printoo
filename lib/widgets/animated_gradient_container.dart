import 'package:flutter/material.dart';

class AnimatedGradientContainer extends StatefulWidget {
  final String text;
  final double height;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final double borderRadius;
  final double fontSize;

  const AnimatedGradientContainer({
    Key? key,
    required this.text,
    this.height = 50,
    this.margin = const EdgeInsets.only(right: 8),
    this.padding = const EdgeInsets.symmetric(horizontal: 30, vertical: 2),
    this.borderRadius = 15,
    this.fontSize = 15,
  }) : super(key: key);

  @override
  State<AnimatedGradientContainer> createState() =>
      _AnimatedGradientContainerState();
}

class _AnimatedGradientContainerState extends State<AnimatedGradientContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      margin: widget.margin,
      padding: widget.padding,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  HSLColor.fromAHSL(
                    1,
                    (_controller.value * 360) % 360,
                    0.7,
                    0.5,
                  ).toColor(),
                  HSLColor.fromAHSL(
                    1,
                    ((_controller.value * 360) + 120) % 360,
                    0.7,
                    0.5,
                  ).toColor(),
                  HSLColor.fromAHSL(
                    1,
                    ((_controller.value * 360) + 240) % 360,
                    0.7,
                    0.5,
                  ).toColor(),
                ],
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  // vertical: 10,
                ),
                child: Text(
                  widget.text,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: widget.fontSize,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
