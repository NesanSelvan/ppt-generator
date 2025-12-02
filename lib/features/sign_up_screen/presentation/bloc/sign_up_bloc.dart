import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ppt_generator/core/services/supabase_service.dart';
import 'package:ppt_generator/features/sign_up_screen/presentation/bloc/sign_up_event.dart';
import 'package:ppt_generator/features/sign_up_screen/presentation/bloc/sign_up_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final SupabaseService _supabaseService;

  SignUpBloc({SupabaseService? supabaseService})
    : _supabaseService = supabaseService ?? SupabaseService(),
      super(SignUpInitial()) {
    on<SignUpSubmitted>(_onSignUpSubmitted);
  }

  Future<void> _onSignUpSubmitted(
    SignUpSubmitted event,
    Emitter<SignUpState> emit,
  ) async {
    emit(SignUpLoading());
    try {
      final response = await _supabaseService.signUp(
        event.email,
        event.password,
      );
      // await _supabaseService.insertUserData(
      //   userId: response.user!.id,
      //   email: event.email,
      // );
      emit(SignUpSuccess(user: response.user));
    } on AuthException catch (e) {
      emit(SignUpFailure(message: e.message));
    } catch (e) {
      log("An unexpected error occured ${e.toString()}");
      emit(const SignUpFailure(message: 'An unexpected error occurred'));
    }
  }
}
