import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:k_quiz/data/repositories/word_repository.dart';
import '../../../../data/bloc/base/base_state.dart';
import '../../../../data/models/book.dart';

part 'books_event.dart';
part 'books_state.dart';

class BooksBloc extends Bloc<BooksEvent, BaseState> {
  final WordRepository _wordRepository;

  BooksBloc(this._wordRepository) : super(InitialState()) {
    on<LoadBooksEvent>(_onLoadBooks);
    on<RefreshBooksEvent>(_onRefreshBooks);
  }

  Future<void> _onLoadBooks(
      LoadBooksEvent event,
      Emitter<BaseState> emit,
      ) async {
    emit(ShowLoadingState(true));

    try {
      final books = await _wordRepository.getAllBooks();

      if (books.isEmpty) {
        emit(ShowErrorMessage('Kitoblar topilmadi'));
      } else {
        emit(BooksLoadedState(books));
      }
    } catch (e) {
      emit(ShowErrorMessage('Xatolik: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshBooks(
      RefreshBooksEvent event,
      Emitter<BaseState> emit,
      ) async {
    try {
      final books = await _wordRepository.getAllBooks();
      emit(BooksLoadedState(books));
    } catch (e) {
      emit(ShowErrorMessage('Yangilashda xatolik: ${e.toString()}'));
    }
  }
}