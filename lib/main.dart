import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
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

@pragma('vm:entry-point')
void onStart(ServiceInstance serviceInstance) {
  Timer.periodic(Duration(minutes: 5), (timer) async {
    await registerLocation();
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeService();

  await initDb();

  runApp(
    const ProviderScope(
      child: MainApp(),
    ),
  );
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
      iosConfiguration: IosConfiguration(),
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: true,
        isForegroundMode: true,
        autoStartOnBoot: true,
        foregroundServiceTypes: [AndroidForegroundType.location],
      ));
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
        body: FutureBuilder(
          future: Geolocator.requestPermission(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    FutureBuilder(
                      future: ref
                          .read(daysVisitedProvider.notifier)
                          .loadDaysVisited(currentDateTime),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
              );
            }

            return const Center(child: Text('Enable location to use the app'));
          },
        ),
      ),
    );
  }
}
