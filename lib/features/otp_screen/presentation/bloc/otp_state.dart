import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class OtpState extends Equatable {
  const OtpState();

  @override
  List<Object> get props => [];
}

class OtpInitial extends OtpState {}

class OtpLoading extends OtpState {}

class OtpSuccess extends OtpState {
  final User? user;

  const OtpSuccess({this.user});

  @override
  List<Object> get props => [user ?? ''];
}

class OtpFailure extends OtpState {
  final String message;

  const OtpFailure({required this.message});

  @override
  List<Object> get props => [message];
}
