import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k_quiz/config/theme/app_theme_colors.dart';
import 'package:k_quiz/data/bloc/base/base_state.dart';
import 'package:k_quiz/di/service_locator.dart';
import 'package:k_quiz/presentations/ui/common/custom_appbar.dart';
import 'package:k_quiz/presentations/ui/common/empty_state.dart';

import 'saved_words_bloc.dart';

class SavedWordsPage extends StatelessWidget {
  const SavedWordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SavedWordsBloc(getIt.get())..add(const LoadSavedWordsEvent()),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }
}

Widget _buildPage(BuildContext context) {
  final extra = context.appColors;
  return Scaffold(
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    appBar: CustomAppBar(
      title: 'Saqlanganlar',
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new, color: extra.textPrimary),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 18.0),
          child: IconButton(
            icon: Icon(Icons.videogame_asset_rounded, color: extra.textPrimary),
            onPressed: () => Navigator.pop(context),
          ),
        )
      ],
    ),
    body: SafeArea(
      child: BlocListener<SavedWordsBloc, BaseState>(
        listener: (context, state) {
          if (state is ShowErrorMessage) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: BlocBuilder<SavedWordsBloc, BaseState>(
          builder: (context, state) {
            if (state is ShowLoadingState && state.show) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is SavedWordsLoadedState) {
              if (state.savedWords.isEmpty) {
                return const EmptyStateWidget(
                  icon: Icons.bookmark_border_rounded,
                  title: 'Saqlangan so\'zlar yo\'q',
                  subtitle: 'Flashcard yoki Test ichidan so\'zlarni saqlang',
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<SavedWordsBloc>().add(const RefreshSavedWordsEvent());
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.savedWords.length,
                  itemBuilder: (context, index) {
                    final item = state.savedWords[index];
                    final wordId = item['id'] as int;
                    final koreanWord = (item['korean_word'] ?? '').toString();
                    final uzbekWord = (item['uzbek_word'] ?? '').toString();
                    final topicName = (item['topic_name'] ?? '').toString();
                    final bookName = (item['book_name'] ?? '').toString();

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: extra.cardBackground,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: extra.cardBorder),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  koreanWord,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: extra.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  uzbekWord,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: extra.textSecondary,
                                  ),
                                ),
                                if (topicName.isNotEmpty || bookName.isNotEmpty) ...[
                                  const SizedBox(height: 10),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      if (bookName.isNotEmpty)
                                        _buildInfoChip(
                                          icon: Icons.menu_book_rounded,
                                          text: bookName,
                                          color: const Color(0xFF6B46C1),
                                        ),
                                      if (topicName.isNotEmpty)
                                        _buildInfoChip(
                                          icon: Icons.topic_rounded,
                                          text: topicName,
                                          color: const Color(0xFF10B981),
                                        ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              context.read<SavedWordsBloc>().add(RemoveSavedWordEvent(wordId));
                            },
                            icon: const Icon(
                              Icons.bookmark_rounded,
                              color: Color(0xFFF59E0B),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    ),
  );
}

Widget _buildInfoChip({
  required IconData icon,
  required String text,
  required Color color,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}
