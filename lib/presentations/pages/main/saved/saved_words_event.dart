part of 'saved_words_bloc.dart';

sealed class SavedWordsEvent extends Equatable {
  const SavedWordsEvent();
}

class LoadSavedWordsEvent extends SavedWordsEvent {
  const LoadSavedWordsEvent();

  @override
  List<Object?> get props => [];
}

class RefreshSavedWordsEvent extends SavedWordsEvent {
  const RefreshSavedWordsEvent();

  @override
  List<Object?> get props => [];
}

class RemoveSavedWordEvent extends SavedWordsEvent {
  final int wordId;

  const RemoveSavedWordEvent(this.wordId);

  @override
  List<Object?> get props => [wordId];
}
