import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k_quiz/data/repositories/study_progress_repository.dart';

import '../../../../data/bloc/base/base_state.dart';

part 'statistics_event.dart';
part 'statistics_state.dart';

class StatisticsBloc extends Bloc<StatisticsEvent, BaseState> {
  final StudyProgressRepository _studyProgressRepository;

  StatisticsBloc(this._studyProgressRepository) : super(InitialState()) {
    on<LoadStatisticsEvent>(_onLoadStatistics);
    on<RefreshStatisticsEvent>(_onRefreshStatistics);
  }

  Future<void> _onLoadStatistics(
    LoadStatisticsEvent event,
    Emitter<BaseState> emit,
  ) async {
    emit(ShowLoadingState(true));
    try {
      final summary = await _studyProgressRepository.getSummary();
      final modeStats = await _studyProgressRepository.getModeStatistics();
      final recentResults = await _studyProgressRepository.getRecentResults();
      emit(StatisticsLoadedState(summary, modeStats, recentResults));
    } catch (e) {
      emit(ShowErrorMessage('Statistikani olishda xatolik: $e'));
    }
  }

  Future<void> _onRefreshStatistics(
    RefreshStatisticsEvent event,
    Emitter<BaseState> emit,
  ) async {
    try {
      final summary = await _studyProgressRepository.getSummary();
      final modeStats = await _studyProgressRepository.getModeStatistics();
      final recentResults = await _studyProgressRepository.getRecentResults();
      emit(StatisticsLoadedState(summary, modeStats, recentResults));
    } catch (e) {
      emit(ShowErrorMessage('Yangilashda xatolik: $e'));
    }
  }
}
