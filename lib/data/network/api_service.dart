// import 'dart:async';
// import 'dart:io';
//
// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
//
// import '../../di/locator.dart';
// import '../../main.dart';
// import '../../presentation/pages/splash/splash_page.dart';
// import '../../utils/app_router.dart';
// import '../../utils/constants.dart';
// import '../../utils/pref_utils.dart';
// import '../model/response/base_response.dart';
// import 'fake_response.dart';
//
// class ApiService {
//   final dio = Dio();
//
//   FakeDio dioFake({
//     required dynamic data,
//     bool success = true,
//     String message = "Fake Dio Error",
//     int errorCode = 0,
//     int statusCode = 200,
//     int waitSeconds = 2,
//   }) {
//     return FakeDio(
//       fakeResponses: FakeResponseConfig(
//         data: data,
//         success: success,
//         message: message,
//         errorCode: errorCode,
//         statusCode: statusCode,
//         waitSeconds: waitSeconds,
//       ),
//     );
//   }
//
//   Future<void> addHeaders() async {
//     dio.interceptors.add(alice.getDioInterceptor());
//     dio.options.baseUrl = baseUrl;
//     dio.options.headers.addAll({
//       'Accept': "application/json",
//       "Authorization": "Bearer ${getIt.get<PrefUtils>().getToken()}",
//       'app-lang': getIt.get<PrefUtils>().getCurrentLang().getKey(),
//     });
//     return;
//   }
//
//   BaseResponse<T> wrapResponse<T>(Response response, T Function(dynamic json) fromJsonT) {
//     final statusCode = response.statusCode ?? 0;
//
//     if (statusCode == 200) {
//       final raw = response.data;
//       final parsed = BaseResponse<T>.fromJson(raw, fromJsonT);
//
//       if (parsed.success) {
//         return parsed;
//       } else if (parsed.errorStatus == 401) {
//         _clearToken();
//         return BaseResponse(false, "Token expired", -1, null);
//       }
//
//       return parsed;
//     } else if (statusCode == 401) {
//       _clearToken();
//       return BaseResponse(false, "Token expired", -1, null);
//     } else {
//       return BaseResponse(
//         false,
//         response.data['message'] ?? (response.statusMessage ?? "Unknown error $statusCode"),
//         -1,
//         null,
//       );
//     }
//   }
//
//   void _clearToken() {
//     getIt.get<PrefUtils>().setToken("");
//     AppRouter.pushAndClear(SplashPage());
//   }
//
//   String wrapError(dynamic error) {
//     if (error is DioException) {
//       final res = error.response;
//
//       if (res?.statusCode == 401) {
//         getIt.get<PrefUtils>().setToken("");
//         AppRouter.pushAndClear(SplashPage());
//         return "Kirish muddati tugadi. Iltimos, qayta kiring.";
//       }
//       if (res != null && res.data is Map<String, dynamic>) {
//         final data = res.data as Map<String, dynamic>;
//         final message = data['message'];
//         if (message != null && message.toString().isNotEmpty) {
//           return "$message";
//         }
//       }
//       switch (error.type) {
//         case DioExceptionType.connectionTimeout:
//           return "Ulanish vaqti tugadi. Qayta urinib ko'ring.";
//         case DioExceptionType.sendTimeout:
//           return "So'rov vaqti tugadi. Ulanishingizni tekshiring.";
//         case DioExceptionType.receiveTimeout:
//           return "Server javobi vaqti tugadi.";
//         case DioExceptionType.badCertificate:
//           return "Xavfsizlik muammosi. Tarmog'ingizni tekshiring.";
//         case DioExceptionType.badResponse:
//           return "Server xatosi. Keyinroq urinib ko'ring.";
//         case DioExceptionType.cancel:
//           return "So'rov bekor qilindi.";
//         case DioExceptionType.connectionError:
//           return "Tarmoq xatosi. Internetingizni tekshiring.";
//         case DioExceptionType.unknown:
//           return "Xato yuz berdi. Qayta urinib ko'ring.";
//       }
//     } else if (error is SocketException) {
//       return "Internet ulanishi yo'q.";
//     } else if (error is HttpException) {
//       return error.message.isNotEmpty ? error.message : "HTTP xatosi.";
//     }
//
//     if (kDebugMode) {
//       return error.toString();
//     }
//     return "Kutilmagan xato. Qayta urinib ko'ring.";
//   }
// }
