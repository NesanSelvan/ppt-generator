import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ppt_generator/core/services/supabase_service.dart';
import 'package:ppt_generator/features/history/data/models/ppt_history_model.dart';
import 'package:ppt_generator/features/history/presentation/bloc/history_event.dart';
import 'package:ppt_generator/features/history/presentation/bloc/history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final SupabaseService _supabaseService;

  HistoryBloc({SupabaseService? supabaseService})
    : _supabaseService = supabaseService ?? SupabaseService.instance,
      super(HistoryInitial()) {
    on<FetchHistoryRequested>(_onFetchHistoryRequested);
  }

  Future<void> _onFetchHistoryRequested(
    FetchHistoryRequested event,
    Emitter<HistoryState> emit,
  ) async {
    emit(HistoryLoading());
    try {
      final user = _supabaseService.currentUser;
      if (user == null) {
        emit(const HistoryError(message: 'User not authenticated'));
        return;
      }

      final userInfoId = await _supabaseService.getUserInfoId(user.id);
      if (userInfoId == null) {
        emit(const HistoryError(message: 'User info not found'));
        return;
      }

      final data = await _supabaseService.getPptHistory(userInfoId);
      final history = data.map((e) => PptHistoryModel.fromJson(e)).toList();
      emit(HistoryLoaded(history: history));
    } catch (e) {
      emit(HistoryError(message: e.toString()));
    }
  }
}
