part of 'books_bloc.dart';

sealed class BooksEvent extends Equatable {
  const BooksEvent();
}

class LoadBooksEvent extends BooksEvent {
  const LoadBooksEvent();

  @override
  List<Object?> get props => [];
}

class RefreshBooksEvent extends BooksEvent {
  const RefreshBooksEvent();

  @override
  List<Object?> get props => [];
}