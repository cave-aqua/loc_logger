import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loc_logger/models/location.dart';
import 'package:loc_logger/providers/location_notifier.dart';
import 'package:loc_logger/widgets/counterbar/counter_bar.dart';

class CounterBarList extends ConsumerWidget {
  const CounterBarList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Location> locations = ref.watch(locationProvider);

    return SingleChildScrollView(
      child: Column(
        children: _getCounterBars(locations),
      ),
    );
  }

  List<CounterBar> _getCounterBars(List<Location> locations) {
    List<CounterBar> counterBars = [];
    for (var location in locations) {
      counterBars.add(CounterBar(location: location));
    }
    return counterBars;
  }
}
