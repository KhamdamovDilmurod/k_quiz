part of 'writing_bloc.dart';

sealed class WritingEvent extends Equatable {
  const WritingEvent();

  @override
  List<Object?> get props => [];
}

final class LoadWritingWordsEvent extends WritingEvent {
  const LoadWritingWordsEvent();
}

final class RefreshWritingWordsEvent extends WritingEvent {
  const RefreshWritingWordsEvent();
}
