import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k_quiz/config/theme/app_theme_colors.dart';
import 'package:k_quiz/presentations/pages/main/books/topics/study/matching/widget/matching_widget.dart';

import '../../../../../../../data/bloc/base/base_state.dart';
import '../../../../../../../di/service_locator.dart';
import '../../../../../../ui/common/custom_appbar.dart';
import '../../../../../../ui/common/empty_state.dart';
import '../flashcards/flashcards_bloc.dart';

class MatchingPage extends StatelessWidget {
  final int topicId;

  const MatchingPage({super.key, required this.topicId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FlashcardsBloc(getIt.get(), topicId)..add(LoadWordsEvent()),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }
}

Widget _buildPage(BuildContext context) {
  final extra = context.appColors;

  return Scaffold(
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    appBar: CustomAppBar(
      title: "Matching",
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new, color: extra.textPrimary),
        onPressed: () => Navigator.pop(context),
      ),
    ),
    body: SafeArea(
      child: BlocBuilder<FlashcardsBloc, BaseState>(
        builder: (context, state) {
          if (state is ShowLoadingState && state.show) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is WordsLoadedState) {
            final words = state.words;

            if (words.isEmpty) {
              return EmptyStateWidget(
                icon: Icons.compare_arrows_rounded,
                title: 'So\'zlar topilmadi',
                subtitle: 'Hozircha bu mavzuda so\'zlar yo\'q',
              );
            }

            if (words.length < 4) {
              return EmptyStateWidget(
                icon: Icons.compare_arrows_rounded,
                title: 'Yetarli so\'z yo\'q',
                subtitle: 'Matching uchun kamida 4 ta so\'z kerak',
              );
            }

            return MatchingWidget(words: words);
          }

          if (state is ShowErrorMessage) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: extra.danger,
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      state.message,
                      style: TextStyle(
                        fontSize: 16,
                        color: extra.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      context.read<FlashcardsBloc>().add(RefreshWordsEvent());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: extra.gradientStart,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Qayta urinish',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return EmptyStateWidget(
            icon: Icons.compare_arrows_rounded,
            title: 'So\'zlar topilmadi',
            subtitle: 'Hozircha bu mavzuda so\'zlar yo\'q',
          );
        },
      ),
    ),
  );
}
