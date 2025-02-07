import 'package:flutter/material.dart';

class LegendItem extends StatelessWidget {
  const LegendItem({
    super.key,
    required this.icon,
    required this.label,
  });

  final Widget icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final iconHeigth = MediaQuery.of(context).size.height * 0.037;
    final iconWidth = MediaQuery.of(context).size.width * 0.037;
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.04,
      width: MediaQuery.of(context).size.height * 0.1,
      // color: Colors.amber,
      child: FittedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: iconHeigth,
              width: iconWidth,
              child: icon,
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
