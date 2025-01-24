import 'package:flutter/material.dart';
import 'package:loc_logger/models/settings/day_setting.dart';
import 'package:loc_logger/services/day_settings.dart';

class DaySettingRow extends StatefulWidget {
  final DaySetting daySetting;

  const DaySettingRow({super.key, required this.daySetting});

  @override
  State<DaySettingRow> createState() => _DaySettingRowState();
}

class _DaySettingRowState extends State<DaySettingRow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.all(2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.daySetting.name,
              style: Theme.of(context).textTheme.titleLarge),
          Checkbox(
            value: widget.daySetting.isActive,
            onChanged: (value) {
              setState(() {
                widget.daySetting.isActive = value!;
              });
              setDaySetting(widget.daySetting);
            },
          )
        ],
      ),
    );
  }
}
