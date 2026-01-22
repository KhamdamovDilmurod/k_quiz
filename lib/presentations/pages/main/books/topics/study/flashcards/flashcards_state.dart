part of 'flashcards_bloc.dart';

sealed class FlashcardsState extends BaseState {
  FlashcardsState();
}

final class FlashcardsInitial extends FlashcardsState {
  @override
  List<Object> get props => [];
}

final class WordsLoadedState extends FlashcardsState {
  final List<Word> words;

  WordsLoadedState(this.words);

  @override
  List<Object> get props => [words];
}