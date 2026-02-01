part of 'writing_bloc.dart';

sealed class WritingState extends Equatable {
  const WritingState();
}

final class WritingInitial extends WritingState {
  @override
  List<Object> get props => [];
}
