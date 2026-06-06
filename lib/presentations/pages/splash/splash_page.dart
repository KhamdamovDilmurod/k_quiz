import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:k_quiz/config/theme/app_theme_colors.dart';
import 'package:k_quiz/di/service_locator.dart';
import 'package:k_quiz/presentations/pages/auth/login_screen.dart';
import 'package:k_quiz/presentations/pages/auth/widgets/auth_chrome.dart';
import 'package:k_quiz/presentations/pages/main/books/books_page.dart';
import 'package:k_quiz/services/google_sheets_service.dart';
import 'package:k_quiz/utils/pref_utils.dart';

import 'splash_cubit.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => SplashCubit(getIt<GoogleSheetsService>())..initialize(),
      child: const SplashView(),
    );
  }
}

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final extra = context.appColors;
    final theme = Theme.of(context);

    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state.status == SplashStatus.success) {
          final savedUser = getIt<PrefUtils>().getUserData();
          final nextPage =
              savedUser != null ? const BooksScreen() : const LoginScreen();

          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => nextPage,
              transitionsBuilder: (
                context,
                animation,
                secondaryAnimation,
                child,
              ) {
                return FadeTransition(opacity: animation, child: child);
              },
              transitionDuration: const Duration(milliseconds: 450),
            ),
          );
        }
      },
      child: Scaffold(
        body: AuthDecoratedBackground(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 36,
                  ),
                  child: BlocBuilder<SplashCubit, SplashState>(
                    builder: (context, state) {
                      if (state.status == SplashStatus.error) {
                        return Center(
                          child: AuthSurfaceCard(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 72,
                                  height: 72,
                                  decoration: BoxDecoration(
                                    color: extra.danger.withValues(alpha: 0.12),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.error_outline_rounded,
                                    size: 34,
                                    color: extra.danger,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'splash.load_error'.tr(),
                                  style: theme.textTheme.headlineSmall
                                      ?.copyWith(
                                        color: extra.textPrimary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  state.errorMessage ??
                                      'common.unknown_error'.tr(),
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: extra.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                SizedBox(
                                  width: double.infinity,
                                  height: 52,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          extra.gradientStart,
                                          extra.gradientEnd,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    child: ElevatedButton.icon(
                                      onPressed:
                                          () =>
                                              context
                                                  .read<SplashCubit>()
                                                  .initialize(),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            18,
                                          ),
                                        ),
                                      ),
                                      icon: const Icon(
                                        Icons.refresh_rounded,
                                        color: Colors.white,
                                      ),
                                      label:
                                          const Text(
                                            'common.retry',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ).tr(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 540),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const AuthBrandHeader(
                                title: 'Korean Quiz',
                                logoSize: 112,
                              ),
                              const SizedBox(height: 28),
                              AuthSurfaceCard(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 44,
                                          height: 44,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                extra.gradientStart,
                                                extra.gradientEnd,
                                              ],
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.cloud_download_rounded,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'splash.preparing'.tr(),
                                                style: theme
                                                    .textTheme
                                                    .titleMedium
                                                    ?.copyWith(
                                                      color: extra.textPrimary,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                'splash.progress_bound'.tr(),
                                                style: theme
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      color:
                                                          extra.textSecondary,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 24),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(999),
                                      child: TweenAnimationBuilder<double>(
                                        tween: Tween<double>(
                                          begin: 0,
                                          end: state.progress.clamp(0.0, 1.0),
                                        ),
                                        duration: const Duration(
                                          milliseconds: 220,
                                        ),
                                        builder: (context, value, child) {
                                          return LinearProgressIndicator(
                                            value: value,
                                            minHeight: 12,
                                            backgroundColor: extra.mutedSurface
                                                .withValues(alpha: 0.9),
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  extra.gradientStart,
                                                ),
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: AnimatedSwitcher(
                                            duration: const Duration(
                                              milliseconds: 220,
                                            ),
                                            child: Text(
                                              state.loadingMessage,
                                              key: ValueKey(
                                                state.loadingMessage,
                                              ),
                                              style: theme.textTheme.bodyMedium
                                                  ?.copyWith(
                                                    color: extra.textSecondary,
                                                  ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          '${(state.progress * 100).toInt()}%',
                                          style: theme.textTheme.titleMedium
                                              ?.copyWith(
                                                color: extra.textPrimary,
                                                fontWeight: FontWeight.w800,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
