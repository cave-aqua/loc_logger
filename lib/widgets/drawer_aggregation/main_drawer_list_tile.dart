import 'package:flutter/material.dart';

class MainDrawerListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final void Function() onTap;

  const MainDrawerListTile(
      {super.key,
      required this.icon,
      required this.title,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Row(
        children: [Icon(icon), const SizedBox(width: 18), Text(title)],
      ),
    );
  }
}
