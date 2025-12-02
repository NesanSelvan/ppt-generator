import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ppt_generator/core/services/supabase_service.dart';
import 'package:ppt_generator/features/auth/presentation/bloc/auth_event.dart';
import 'package:ppt_generator/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SupabaseService _supabaseService;

  AuthBloc({SupabaseService? supabaseService})
    : _supabaseService = supabaseService ?? SupabaseService(),
      super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = _supabaseService.currentUser;
      if (user != null) {
        emit(AuthAuthenticated(user: user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    await _supabaseService.signOut();
    emit(AuthUnauthenticated());
  }
}
