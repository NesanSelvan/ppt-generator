import 'package:equatable/equatable.dart';

abstract class OtpEvent extends Equatable {
  const OtpEvent();

  @override
  List<Object> get props => [];
}

class OtpSubmitted extends OtpEvent {
  final String email;
  final String token;

  const OtpSubmitted({required this.email, required this.token});

  @override
  List<Object> get props => [email, token];
}
