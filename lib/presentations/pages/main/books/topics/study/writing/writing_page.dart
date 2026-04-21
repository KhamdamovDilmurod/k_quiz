import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k_quiz/config/theme/app_theme_colors.dart';
import 'package:k_quiz/presentations/pages/main/books/topics/study/writing/writing_widgets.dart';

import '../../../../../../../di/service_locator.dart';
import '../../../../../../ui/common/custom_appbar.dart';
import '../../../../../../ui/common/empty_state.dart';
import 'writing_bloc.dart';

class WritingPage extends StatelessWidget {
  final int topicId;

  const WritingPage({super.key, required this.topicId});


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          WritingBloc(getIt.get(), topicId)..add(const LoadWritingWordsEvent()),
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
      child: BlocBuilder<WritingBloc, WritingState>(
        builder: (context, state) {
          if (state is WritingLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is WritingLoaded) {
            final words = state.words;

            if (words.isEmpty) {
              return EmptyStateWidget(
                icon: Icons.quiz_outlined,
                title: 'So\'zlar topilmadi',
                subtitle: 'Hozircha bu mavzuda so\'zlar yo\'q',
              );
            }

            return WritingWidget(
              words: words,
            );
          }

          if (state is WritingError) {
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
                      context.read<WritingBloc>().add(
                        const RefreshWritingWordsEvent(),
                      );
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
            icon: Icons.quiz_outlined,
            title: 'So\'zlar topilmadi',
            subtitle: 'Hozircha bu mavzuda so\'zlar yo\'q',
          );
        },
      ),
    ),
  );
}
