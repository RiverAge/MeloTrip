import 'package:melo_trip/svc/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_history.g.dart';

@riverpod
class SearchHistory extends _$SearchHistory {
  @override
  Future<List<String>?> build() async {
    final user = await User.instance;
    return user.searchHistory;
  }

  clearAll() async {
    final user = await User.instance;
    user.searchHistory = [];
    state = const AsyncData([]);
  }

  insertHistory(String? item) async {
    if (item == null) {
      return;
    }
    // final items = await ref.watch(searchHistoryProvider.future);
    // final items = state.value ?? [];
    final previousState = await future;

    List<String> newState = [];
    if (previousState != null) {
      final index = previousState.indexOf(item);
      if (index == -1) {
        newState = [item, ...previousState];
      } else {
        newState = [...previousState];
        newState.removeAt(index);
        newState.insert(0, item);
      }
    } else {
      newState.add(item);
    }
    final user = await User.instance;
    user.searchHistory = newState;
    state = AsyncData(newState);
  }
}
