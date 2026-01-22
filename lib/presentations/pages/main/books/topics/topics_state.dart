part of 'topics_bloc.dart';

sealed class TopicsState extends BaseState {
  TopicsState();
}

final class TopicsInitial extends TopicsState {
  @override
  List<Object> get props => [];
}
