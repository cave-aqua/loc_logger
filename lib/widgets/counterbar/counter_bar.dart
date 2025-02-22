import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loc_logger/models/location.dart';
import 'package:loc_logger/providers/days_visited_located_notifier.dart';
import 'package:loc_logger/providers/selected_date_notifier.dart';
import 'package:loc_logger/models/visited_location.dart';

class CounterBar extends ConsumerStatefulWidget {
  final Location location;

  const CounterBar({
    super.key,
    required this.location,
  });

  @override
  ConsumerState<CounterBar> createState() => _CounterBarState();
}

class _CounterBarState extends ConsumerState<CounterBar>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    int amountOfVisits = _getAmountOfVisits();
    int lengthOfMonth = _getLengthOfMonth();

    double precentageOfMonth = amountOfVisits / lengthOfMonth;

    TweenAnimationBuilder<double> animationProgressBar = TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: precentageOfMonth),
      duration: const Duration(milliseconds: 650),
      builder: (context, value, child) {
        return LinearProgressIndicator(
          backgroundColor: Color(0xFF9E9E9E),
          color: widget.location.color,
          value: value,
          minHeight: 20,
        );
      },
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                  '${widget.location.isHome ? 'Only' : ''} ${widget.location.name} : $amountOfVisits',
                  style: Theme.of(context).textTheme.labelLarge),
            ],
          ),
          animationProgressBar,
          const SizedBox(height: 20)
        ],
      ),
    );
  }

  int _getAmountOfVisits() {
    int counter = 0;

    Map<String, List<VistedLocation>> daysVisitedLocations =
        ref.watch(daysVisitedProvider);

    daysVisitedLocations.forEach((key, vistedLocations) {
      for (var vistedLocation in vistedLocations) {
        //You will always be at home at the start of the day so we need to make sure that it only counted when it's one
        if (widget.location.id == vistedLocation.locationId) {
          if (widget.location.isHome) {
            if (vistedLocations.length == 1) {
              counter++;
            }
          } else {
            counter++;
          }
        }
      }
    });

    return counter;
  }

  int _getLengthOfMonth() {
    DateTime chosenDate = ref.watch(selectedDateNotifierProvider);
    int month = chosenDate.month;
    int year = chosenDate.year;

    return DateTime(year, month + 1, 0).day;
  }
}
