import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k_quiz/data/repositories/word_repository.dart';

import '../../../../data/bloc/base/base_state.dart';

part 'saved_words_event.dart';
part 'saved_words_state.dart';

class SavedWordsBloc extends Bloc<SavedWordsEvent, BaseState> {
  final WordRepository _wordRepository;

  SavedWordsBloc(this._wordRepository) : super(InitialState()) {
    on<LoadSavedWordsEvent>(_onLoadSavedWords);
    on<RefreshSavedWordsEvent>(_onRefreshSavedWords);
    on<RemoveSavedWordEvent>(_onRemoveSavedWord);
  }

  Future<void> _onLoadSavedWords(
    LoadSavedWordsEvent event,
    Emitter<BaseState> emit,
  ) async {
    emit(ShowLoadingState(true));
    try {
      final words = await _wordRepository.getSavedWordsWithDetails();
      emit(SavedWordsLoadedState(words));
    } catch (e) {
      emit(ShowErrorMessage('Saqlangan so\'zlarni olishda xatolik: $e'));
    }
  }

  Future<void> _onRefreshSavedWords(
    RefreshSavedWordsEvent event,
    Emitter<BaseState> emit,
  ) async {
    try {
      final words = await _wordRepository.getSavedWordsWithDetails();
      emit(SavedWordsLoadedState(words));
    } catch (e) {
      emit(ShowErrorMessage('Yangilashda xatolik: $e'));
    }
  }

  Future<void> _onRemoveSavedWord(
    RemoveSavedWordEvent event,
    Emitter<BaseState> emit,
  ) async {
    try {
      await _wordRepository.removeFromSaved(event.wordId);
      final words = await _wordRepository.getSavedWordsWithDetails();
      emit(SavedWordsLoadedState(words));
    } catch (e) {
      emit(ShowErrorMessage('So\'zni o\'chirishda xatolik: $e'));
    }
  }
}
