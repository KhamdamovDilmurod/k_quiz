import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k_quiz/config/app_theme_colors.dart';
import 'package:k_quiz/presentations/pages/main/books/topics/study/writing/writing_widgets.dart';

import '../../../../../../../data/bloc/base/base_state.dart';
import '../../../../../../../di/service_locator.dart';
import '../../../../../../ui/common/custom_appbar.dart';
import '../../../../../../ui/common/empty_state.dart';
import '../flashcards/flashcards_bloc.dart';

class WritingPage extends StatelessWidget {
  final int topicId;

  const WritingPage({Key? key, required this.topicId}) : super(key: key);


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
      title: "Yozish",
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
                icon: Icons.quiz_outlined,
                title: 'So\'zlar topilmadi',
                subtitle: 'Hozircha bu mavzuda so\'zlar yo\'q',
              );
            }

            return WritingWidget(
              words: [
                {'korean': '안녕', 'translation': 'Salom', 'difficulty': 'easy'},
                {'korean': '감사', 'translation': 'Rahmat', 'difficulty': 'easy'},
                // ... boshqa so'zlar
              ],
            );
          }

          if (state is ShowErrorMessage) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      state.message,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF6B7280),
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
                      backgroundColor: const Color(0xFF6B46C1),
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
            icon: Icons.quiz_outlined,
            title: 'So\'zlar topilmadi',
            subtitle: 'Hozircha bu mavzuda so\'zlar yo\'q',
          );
        },
      ),
    ),
  );
}
