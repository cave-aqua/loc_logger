import 'package:flutter/material.dart';

class SettingListItem extends StatelessWidget {
  final String name;
  final Widget settingScreen;

  const SettingListItem(
      {super.key, required this.name, required this.settingScreen});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => settingScreen,
            ));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
        decoration: const BoxDecoration(
          color: Colors.grey,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
