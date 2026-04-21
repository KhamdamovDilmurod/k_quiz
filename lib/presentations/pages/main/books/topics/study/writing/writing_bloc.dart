import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k_quiz/data/models/word.dart';
import 'package:k_quiz/data/repositories/word_repository.dart';

part 'writing_event.dart';
part 'writing_state.dart';

class WritingBloc extends Bloc<WritingEvent, WritingState> {
  final int topicId;
  final WordRepository _wordRepository;

  WritingBloc(this._wordRepository, this.topicId) : super(WritingInitial()) {
    on<LoadWritingWordsEvent>(_onLoadWords);
    on<RefreshWritingWordsEvent>(_onRefreshWords);
  }

  Future<void> _onLoadWords(
    LoadWritingWordsEvent event,
    Emitter<WritingState> emit,
  ) async {
    emit(WritingLoading());

    try {
      final words = await _wordRepository.getWordsByTopic(topicId);
      if (words.isEmpty) {
        emit(const WritingError('So\'zlar topilmadi'));
      } else {
        emit(WritingLoaded(words));
      }
    } catch (e) {
      emit(WritingError('Xatolik: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshWords(
    RefreshWritingWordsEvent event,
    Emitter<WritingState> emit,
  ) async {
    try {
      final words = await _wordRepository.getWordsByTopic(topicId);
      if (words.isEmpty) {
        emit(const WritingError('So\'zlar topilmadi'));
      } else {
        emit(WritingLoaded(words));
      }
    } catch (e) {
      emit(WritingError('Yangilashda xatolik: ${e.toString()}'));
    }
  }
}
