import 'package:equatable/equatable.dart';
import 'package:ppt_generator/features/history/data/models/ppt_history_model.dart';

abstract class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object> get props => [];
}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<PptHistoryModel> history;

  const HistoryLoaded({required this.history});

  @override
  List<Object> get props => [history];
}

class HistoryError extends HistoryState {
  final String message;

  const HistoryError({required this.message});

  @override
  List<Object> get props => [message];
}
