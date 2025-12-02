import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object> get props => [];
}

class SignUpInitial extends SignUpState {}

class SignUpLoading extends SignUpState {}

class SignUpSuccess extends SignUpState {
  final User? user;

  const SignUpSuccess({this.user});

  @override
  List<Object> get props => [user ?? ''];
}

class SignUpFailure extends SignUpState {
  final String message;

  const SignUpFailure({required this.message});

  @override
  List<Object> get props => [message];
}
