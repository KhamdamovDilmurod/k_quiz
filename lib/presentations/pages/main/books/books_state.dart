part of 'books_bloc.dart';

sealed class BooksState extends BaseState {
  BooksState();
}

final class BooksInitial extends BooksState {
  @override
  List<Object> get props => [];
}

final class BooksLoadedState extends BooksState {
  final List<Book> books;

  BooksLoadedState(this.books);

  @override
  List<Object> get props => [books];
}