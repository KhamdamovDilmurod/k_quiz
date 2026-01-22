import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:k_quiz/data/models/word.dart';

import '../../../../../../../data/bloc/base/base_state.dart';
import '../../../../../../../data/repositories/word_repository.dart';

part 'flashcards_event.dart';
part 'flashcards_state.dart';

class FlashcardsBloc extends Bloc<FlashcardsEvent, BaseState> {

  final int topicId;
  final WordRepository _wordRepository;

  FlashcardsBloc(this._wordRepository, this.topicId) : super(FlashcardsInitial()) {
    on<LoadWordsEvent>(_onLoadWords);
    on<RefreshWordsEvent>(_onRefreshWords);
  }

  Future<void> _onLoadWords(
      LoadWordsEvent event,
      Emitter<BaseState> emit,
      ) async {
    emit(ShowLoadingState(true));

    try {
      final words = await _wordRepository.getWordsByTopic(topicId);

      print("Topic words: ${words.length}");

      if (words.isEmpty) {
        emit(ShowErrorMessage('Kitoblar topilmadi'));
      } else {
        emit(WordsLoadedState(words));
      }
    } catch (e) {
      emit(ShowErrorMessage('Xatolik: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshWords(
      RefreshWordsEvent event,
      Emitter<BaseState> emit,
      ) async {
    try {
      final words = await _wordRepository.getWordsByTopic(topicId);
      emit(WordsLoadedState(words));
    } catch (e) {
      emit(ShowErrorMessage('Yangilashda xatolik: ${e.toString()}'));
    }
  }
}
