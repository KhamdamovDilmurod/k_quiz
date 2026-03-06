part of 'saved_words_bloc.dart';

sealed class SavedWordsState extends BaseState {
  SavedWordsState();
}

final class SavedWordsInitial extends SavedWordsState {
  @override
  List<Object> get props => [];
}

final class SavedWordsLoadedState extends SavedWordsState {
  final List<Map<String, dynamic>> savedWords;

  SavedWordsLoadedState(this.savedWords);

  @override
  List<Object> get props => [savedWords];
}
