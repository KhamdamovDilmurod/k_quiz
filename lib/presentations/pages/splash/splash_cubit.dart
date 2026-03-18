// splash/splash_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k_quiz/services/google_sheets_service.dart';

enum SplashStatus { loading, success, error }

const _noValue = Object();

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
    Object? errorMessage = _noValue,
    double? progress,
    String? loadingMessage,
  }) {
    return SplashState(
      status: status ?? this.status,
      errorMessage:
          identical(errorMessage, _noValue) ? this.errorMessage : errorMessage as String?,
      progress: progress ?? this.progress,
      loadingMessage: loadingMessage ?? this.loadingMessage,
    );
  }
}

class SplashCubit extends Cubit<SplashState> {
  final GoogleSheetsService _sheetsService;
  bool _isInitializing = false;

  SplashCubit(this._sheetsService)
      : super(SplashState(status: SplashStatus.loading));

  Future<void> initialize() async {
    if (_isInitializing) return;
    _isInitializing = true;

    try {
      emit(state.copyWith(
        status: SplashStatus.loading,
        errorMessage: null,
        progress: 0.05,
        loadingMessage: 'Ilova tayyorlanmoqda...',
      ));

      // Database bo'sh yoki yo'qligini tekshirish
      emit(state.copyWith(
        progress: 0.10,
        loadingMessage: 'Ma\'lumotlar bazasi tekshirilmoqda...',
      ));
      final isEmpty = await _sheetsService.isDatabaseEmpty();

      if (isEmpty) {
        await _sheetsService.importAllFromGoogleSheets(
          onProgress: (progress, message) {
            if (isClosed) return;
            emit(state.copyWith(
              status: SplashStatus.loading,
              progress: progress,
              loadingMessage: message,
            ));
          },
        );
      } else {
        emit(state.copyWith(
          progress: 1.0,
          loadingMessage: 'Saqlangan ma\'lumotlar tayyor!',
        ));
      }

      if (!isClosed) {
        emit(state.copyWith(
          status: SplashStatus.success,
          progress: 1.0,
          loadingMessage: 'Tayyor!',
        ));
      }
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(
          status: SplashStatus.error,
          errorMessage: e.toString(),
        ));
      }
    } finally {
      _isInitializing = false;
    }
  }
}
