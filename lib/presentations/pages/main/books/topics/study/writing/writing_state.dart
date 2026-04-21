part of 'writing_bloc.dart';

sealed class WritingState extends Equatable {
  const WritingState();

  @override
  List<Object?> get props => [];
}

final class WritingInitial extends WritingState {
}

final class WritingLoading extends WritingState {
  const WritingLoading();
}

final class WritingLoaded extends WritingState {
  final List<Word> words;

  const WritingLoaded(this.words);

  @override
  List<Object?> get props => [words];
}

final class WritingError extends WritingState {
  final String message;

  const WritingError(this.message);

  @override
  List<Object?> get props => [message];
}
