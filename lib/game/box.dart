import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Box extends StatelessWidget {
  Box({
    super.key,
    required this.color,
  });
  Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(1),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(5.0), color: color),
    );
  }
}
