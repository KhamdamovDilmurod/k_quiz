part of 'topics_bloc.dart';

sealed class TopicsEvent extends Equatable {
  const TopicsEvent();
}

class LoadTopicsEvent extends TopicsEvent {
  const LoadTopicsEvent();

  @override
  List<Object?> get props => [];
}

class RefreshTopicsEvent extends TopicsEvent {
  const RefreshTopicsEvent();

  @override
  List<Object?> get props => [];
}