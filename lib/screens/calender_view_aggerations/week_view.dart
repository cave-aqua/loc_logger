import 'package:flutter/material.dart';

class WeekView extends StatelessWidget {
  final List<Widget> children;

  const WeekView({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: children,
    );
  }
}
