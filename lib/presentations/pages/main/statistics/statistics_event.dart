part of 'statistics_bloc.dart';

sealed class StatisticsEvent extends Equatable {
  const StatisticsEvent();
}

class LoadStatisticsEvent extends StatisticsEvent {
  const LoadStatisticsEvent();

  @override
  List<Object?> get props => [];
}

class RefreshStatisticsEvent extends StatisticsEvent {
  const RefreshStatisticsEvent();

  @override
  List<Object?> get props => [];
}
