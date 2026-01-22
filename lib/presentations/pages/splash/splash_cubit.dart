// splash/splash_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k_quiz/services/google_sheets_service.dart';

enum SplashStatus { loading, success, error }

class SplashState {
  final SplashStatus status;
  final String? errorMessage;
  final double progress;
  final String loadingMessage;

  SplashState({
    required this.status,
    this.errorMessage,
    this.progress = 0.0,
    this.loadingMessage = 'Boshlash...',
  });

  SplashState copyWith({
    SplashStatus? status,
    String? errorMessage,
    double? progress,
    String? loadingMessage,
  }) {
    return SplashState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      progress: progress ?? this.progress,
      loadingMessage: loadingMessage ?? this.loadingMessage,
    );
  }
}

class SplashCubit extends Cubit<SplashState> {
  final GoogleSheetsService _sheetsService;

  SplashCubit(this._sheetsService)
      : super(SplashState(status: SplashStatus.loading));

  Future<void> initialize() async {
    try {
      emit(state.copyWith(
        status: SplashStatus.loading,
        progress: 0.0,
        loadingMessage: 'Ilovani tayyorlanmoqda...',
      ));

      await Future.delayed(Duration(milliseconds: 500));
      emit(state.copyWith(progress: 0.2));

      emit(state.copyWith(
        progress: 0.3,
        loadingMessage: 'Ma\'lumotlar bazasini tekshirish...',
      ));

      await Future.delayed(Duration(milliseconds: 300));

      // Database bo'sh yoki yo'qligini tekshirish
      final isEmpty = await _sheetsService.isDatabaseEmpty();
      emit(state.copyWith(progress: 0.5));

      if (isEmpty) {
        emit(state.copyWith(
          progress: 0.6,
          loadingMessage: 'Darsliklar yuklanmoqda...',
        ));

        // Google Sheets'dan data import qilish
        await _sheetsService.importAllFromGoogleSheets();

        emit(state.copyWith(progress: 0.9));
      } else {
        emit(state.copyWith(
          progress: 0.8,
          loadingMessage: 'Ma\'lumotlar tayyor!',
        ));
      }

      await Future.delayed(Duration(milliseconds: 500));

      emit(state.copyWith(
        progress: 1.0,
        loadingMessage: 'Tayyor!',
      ));

      await Future.delayed(Duration(milliseconds: 300));
      emit(state.copyWith(status: SplashStatus.success));

    } catch (e) {
      emit(state.copyWith(
        status: SplashStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}