import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ppt_generator/core/services/supabase_service.dart';
import 'package:ppt_generator/features/login_screen/presentation/bloc/login_event.dart';
import 'package:ppt_generator/features/login_screen/presentation/bloc/login_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final SupabaseService _supabaseService;

  LoginBloc({SupabaseService? supabaseService})
    : _supabaseService = supabaseService ?? SupabaseService(),
      super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      final response = await _supabaseService.signIn(
        event.email,
        event.password,
      );
      emit(LoginSuccess(user: response.user));
    } on AuthException catch (e) {
      emit(LoginFailure(message: e.message));
    } catch (e) {
      emit(const LoginFailure(message: 'An unexpected error occurred'));
    }
  }
}
