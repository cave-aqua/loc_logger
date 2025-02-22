import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loc_logger/providers/days_visited_located_notifier.dart';
import 'package:loc_logger/providers/selected_date_notifier.dart';
import 'package:loc_logger/services/init_database.dart';
import 'package:loc_logger/widgets/calendar/calender_view.dart';
import 'package:loc_logger/widgets/counterbar/counter_bar_list.dart';
import 'package:loc_logger/widgets/main_drawer.dart';
import 'package:workmanager/workmanager.dart';
import 'package:loc_logger/services/register_location.dart';

const String registerLocationKey = 'periodic-visited-location-register';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    DartPluginRegistrant.ensureInitialized();
    return await registerLocation();
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true,
  );
  Workmanager().registerPeriodicTask(
    registerLocationKey,
    'register-location',
    frequency: const Duration(minutes: 15),
    constraints: Constraints(
      networkType: NetworkType.not_required,
      requiresCharging: false,
      requiresBatteryNotLow: false,
      requiresStorageNotLow: false,
    ),
  );

  await initDb();

  runApp(
    const ProviderScope(
      child: MainApp(),
    ),
  );
}

class MainApp extends ConsumerStatefulWidget {
  const MainApp({super.key});

  @override
  ConsumerState<MainApp> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> {
  @override
  void initState() {
    super.initState();
    ref.read(selectedDateNotifierProvider);
  }

  @override
  Widget build(BuildContext context) {
    DateTime currentDateTime = ref.watch(selectedDateNotifierProvider);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Overview'),
          actions: const [],
        ),
        drawer: const MainDrawer(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder(
                future: ref
                    .read(daysVisitedProvider.notifier)
                    .loadDaysVisited(currentDateTime),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 350,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  return CalenderView(givenDate: currentDateTime);
                },
              ),
              const SizedBox(height: 20),
              const CounterBarList()
            ],
          ),
        ),
      ),
    );
  }
}
