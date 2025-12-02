import 'package:equatable/equatable.dart';

abstract class PptGeneratorState extends Equatable {
  const PptGeneratorState();

  @override
  List<Object> get props => [];
}

class PptGeneratorInitial extends PptGeneratorState {}

class PptGeneratorLoading extends PptGeneratorState {}

class PptGeneratorSuccess extends PptGeneratorState {
  final String pptUrl;

  const PptGeneratorSuccess({required this.pptUrl});

  @override
  List<Object> get props => [pptUrl];
}

class PptGeneratorFailure extends PptGeneratorState {
  final String message;

  const PptGeneratorFailure({required this.message});

  @override
  List<Object> get props => [message];
}
