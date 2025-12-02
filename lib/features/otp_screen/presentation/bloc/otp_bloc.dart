import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ppt_generator/core/services/supabase_service.dart';
import 'package:ppt_generator/features/otp_screen/presentation/bloc/otp_event.dart';
import 'package:ppt_generator/features/otp_screen/presentation/bloc/otp_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  final SupabaseService _supabaseService;

  OtpBloc({SupabaseService? supabaseService})
    : _supabaseService = supabaseService ?? SupabaseService(),
      super(OtpInitial()) {
    on<OtpSubmitted>(_onOtpSubmitted);
  }

  Future<void> _onOtpSubmitted(
    OtpSubmitted event,
    Emitter<OtpState> emit,
  ) async {
    emit(OtpLoading());
    try {
      final response = await _supabaseService.verifyOtp(
        event.email,
        event.token,
      );
      if (response.user != null) {
        await _supabaseService.insertUserData(
          userId: response.user!.id,
          email: event.email,
        );
      }
      emit(OtpSuccess(user: response.user));
    } on AuthException catch (e) {
      log("An unexpected error occured ${e.toString()}");
      emit(OtpFailure(message: e.message));
    } catch (e) {
      log("An unexpected error occured ${e.toString()}");
      emit(const OtpFailure(message: 'An unexpected error occurred'));
    }
  }
}
