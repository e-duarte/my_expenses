import 'package:flutter/material.dart';
import 'package:my_expenses/models/tag.dart';

class TagLeading extends StatelessWidget {
  const TagLeading(this.tag, {super.key, this.color});
  final Tag tag;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: color ?? tag.color,
      radius: 26,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Image.asset(
          tag.iconPath,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
