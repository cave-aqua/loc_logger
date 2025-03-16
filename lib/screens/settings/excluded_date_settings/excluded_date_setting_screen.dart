import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class ExcludedDateSettingScreeen extends ConsumerStatefulWidget {
  const ExcludedDateSettingScreeen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ExcludedDateSettingScreeenState();
}

class _ExcludedDateSettingScreeenState
    extends ConsumerState<ExcludedDateSettingScreeen> {
  @override
  Widget build(BuildContext context) {
    DateTime currentDate = DateTime.now();

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            IconButton(
                onPressed: () {
                  showDateRangePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(currentDate.year + 1, currentDate.month,
                        currentDate.day),
                  );
                },
                icon: const Icon(Icons.date_range_outlined))
          ],
        ),
      ),
    );
  }
}
