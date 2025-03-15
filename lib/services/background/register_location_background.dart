import 'package:background_fetch/background_fetch.dart';
import 'package:loc_logger/services/register_location.dart';

// @pragma('vm:entry-point')
// void backgroundFetchHeadlessTask(HeadlessTask task) async {
//   print('background_fetch');
//   String taskId = task.taskId;
//   bool isTimeout = task.timeout;
//   if (isTimeout) {
//     // This task has exceeded its allowed running-time.
//     // You must stop what you're doing and immediately .finish(taskId)
//     BackgroundFetch.finish(taskId);
//     return;
//   }

//   await registerLocation();

//   BackgroundFetch.finish(taskId);
// }
