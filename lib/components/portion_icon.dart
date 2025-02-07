import 'package:flutter/material.dart';

class PortionIcon extends StatelessWidget {
  const PortionIcon({
    super.key,
    required this.color,
  });

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
