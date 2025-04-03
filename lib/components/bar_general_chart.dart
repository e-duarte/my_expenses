import 'package:flutter/material.dart';

class BarGeneralChart extends StatelessWidget {
  const BarGeneralChart({super.key, required this.width, required this.color});

  final double width;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final height = 30.0;
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
