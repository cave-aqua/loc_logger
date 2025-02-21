import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_date_notifier.g.dart';

@riverpod
class SelectedDateNotifier extends _$SelectedDateNotifier {
  @override
  DateTime build() => DateTime.now();

  void increaseByMonth() =>
      state = DateTime(state.year, state.month + 1, state.day);

  void decreaseByMonth() =>
      state = DateTime(state.year, state.month - 1, state.day);
}
