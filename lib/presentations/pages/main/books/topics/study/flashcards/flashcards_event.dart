part of 'flashcards_bloc.dart';

sealed class FlashcardsEvent extends Equatable {
  const FlashcardsEvent();
}

class LoadWordsEvent extends FlashcardsEvent {
  const LoadWordsEvent();

  @override
  List<Object?> get props => [];
}

class RefreshWordsEvent extends FlashcardsEvent {
  const RefreshWordsEvent();

  @override
  List<Object?> get props => [];
}