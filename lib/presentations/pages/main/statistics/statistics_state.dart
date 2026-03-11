part of 'statistics_bloc.dart';

sealed class StatisticsState extends BaseState {
  StatisticsState();
}

final class StatisticsInitial extends StatisticsState {
  @override
  List<Object> get props => [];
}

final class StatisticsLoadedState extends StatisticsState {
  final Map<String, dynamic> summary;
  final List<Map<String, dynamic>> modeStats;
  final List<Map<String, dynamic>> recentResults;

  StatisticsLoadedState(this.summary, this.modeStats, this.recentResults);

  @override
  List<Object> get props => [summary, modeStats, recentResults];
}
