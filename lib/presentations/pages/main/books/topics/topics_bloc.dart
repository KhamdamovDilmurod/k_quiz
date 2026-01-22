
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k_quiz/data/bloc/base/base_state.dart';

import '../../../../../data/repositories/word_repository.dart';

part 'topics_event.dart';
part 'topics_state.dart';

class TopicsBloc extends Bloc<TopicsEvent, BaseState> {

  final int bookId;

  final WordRepository _wordRepository;

  TopicsBloc(this._wordRepository, this.bookId) : super(TopicsInitial()) {
    on<LoadTopicsEvent>(_onLoadTopics);
    on<RefreshTopicsEvent>(_onRefreshTopics);
  }

  Future<void> _onLoadTopics(
      LoadTopicsEvent event,
      Emitter<BaseState> emit,
      ) async {
    emit(ShowLoadingState(true));

    try {
      final books = await _wordRepository.getTopicsByBook(bookId);

      if (books.isEmpty) {
        emit(ShowErrorMessage('Mavzular topilmadi'));
      } else {
        emit(LoadedState(books));
      }
    } catch (e) {
      emit(ShowErrorMessage('Xatolik: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshTopics(
      RefreshTopicsEvent event,
      Emitter<BaseState> emit,
      ) async {
    try {
      final books = await _wordRepository.getTopicsByBook(bookId);
      emit(LoadedState(books));
    } catch (e) {
      emit(ShowErrorMessage('Yangilashda xatolik: ${e.toString()}'));
    }
  }
}
