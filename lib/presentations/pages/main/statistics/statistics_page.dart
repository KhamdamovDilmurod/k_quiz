import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k_quiz/config/theme/app_theme_colors.dart';
import 'package:k_quiz/data/bloc/base/base_state.dart';
import 'package:k_quiz/di/service_locator.dart';
import 'package:k_quiz/presentations/ui/common/custom_appbar.dart';
import 'package:k_quiz/presentations/ui/common/empty_state.dart';

import 'statistics_bloc.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StatisticsBloc(getIt.get())..add(const LoadStatisticsEvent()),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }
}

Widget _buildPage(BuildContext context) {
  final extra = context.appColors;
  return Scaffold(
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    appBar: CustomAppBar(
      title: 'Statistika',
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new, color: extra.textPrimary),
        onPressed: () => Navigator.pop(context),
      ),
    ),
    body: SafeArea(
      child: BlocListener<StatisticsBloc, BaseState>(
        listener: (context, state) {
          if (state is ShowErrorMessage) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: BlocBuilder<StatisticsBloc, BaseState>(
          builder: (context, state) {
            if (state is ShowLoadingState && state.show) {
              return const Center(child: CircularProgressIndicator());
            }



            if (state is StatisticsLoadedState) {
              final totalSessions = (state.summary['total_sessions'] ?? 0) as int;
              if (totalSessions == 0) {
                return const EmptyStateWidget(
                  icon: Icons.bar_chart_rounded,
                  title: 'Statistika hali yo\'q',
                  subtitle: 'Flashcard, Test yoki Matching tugagach natijalar shu yerda chiqadi',
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<StatisticsBloc>().add(const RefreshStatisticsEvent());
                },
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildSummarySection(context, state.summary),
                    const SizedBox(height: 18),
                    if (state.modeStats.isNotEmpty) ...[
                      Text(
                        'Rejimlar bo\'yicha',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: extra.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...state.modeStats.map((item) => _buildModeCard(context, item)),
                      const SizedBox(height: 18),
                    ],
                    Text(
                      'Oxirgi natijalar',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: extra.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...state.recentResults.map((item) => _buildRecentResultCard(context, item)),
                  ],
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

Widget _buildSummarySection(BuildContext context, Map<String, dynamic> summary) {
  final extra = context.appColors;
  final totalSessions = (summary['total_sessions'] ?? 0) as int;
  final avgPercentage = (summary['avg_percentage'] ?? 0.0) as double;
  final bestPercentage = (summary['best_percentage'] ?? 0.0) as double;
  final totalDurationSec = (summary['total_duration_sec'] ?? 0) as int;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Umumiy progress',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: extra.textPrimary,
        ),
      ),
      const SizedBox(height: 12),
      Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              label: 'Session',
              value: '$totalSessions',
              colors: const [Color(0xFF6B46C1), Color(0xFF9333EA)],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              label: 'O\'rtacha',
              value: '${avgPercentage.toStringAsFixed(1)}%',
              colors: const [Color(0xFF10B981), Color(0xFF059669)],
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),
      Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              label: 'Eng yaxshi',
              value: '${bestPercentage.toStringAsFixed(1)}%',
              colors: const [Color(0xFFF59E0B), Color(0xFFEF4444)],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              label: 'Jami vaqt',
              value: _formatDuration(totalDurationSec),
              colors: const [Color(0xFF3B82F6), Color(0xFF2563EB)],
            ),
          ),
        ],
      ),
    ],
  );
}

Widget _buildSummaryCard({
  required String label,
  required String value,
  required List<Color> colors,
}) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      gradient: LinearGradient(colors: colors),
      borderRadius: BorderRadius.circular(18),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.85),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    ),
  );
}

Widget _buildModeCard(BuildContext context, Map<String, dynamic> item) {
  final extra = context.appColors;
  final mode = (item['mode'] ?? '').toString();
  final sessionsCount = (item['sessions_count'] ?? 0) as int;
  final avgPercentage = (item['avg_percentage'] ?? 0.0) as double;
  final avgDurationSec = (item['avg_duration_sec'] ?? 0.0) as double;

  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: extra.cardBackground,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: extra.cardBorder),
    ),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: _modeColor(mode).withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            _modeLabel(mode),
            style: TextStyle(
              color: _modeColor(mode),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const Spacer(),
        Text(
          '$sessionsCount ta | ${avgPercentage.toStringAsFixed(1)}% | ${_formatDuration(avgDurationSec.round())}',
          style: TextStyle(
            color: extra.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}

Widget _buildRecentResultCard(BuildContext context, Map<String, dynamic> item) {
  final extra = context.appColors;
  final mode = (item['mode'] ?? '').toString();
  final percentage = (item['percentage'] ?? 0.0) as double;
  final score = (item['score'] ?? 0) as int;
  final total = (item['total'] ?? 0) as int;
  final durationSec = (item['duration_sec'] ?? 0) as int;
  final topicName = (item['topic_name'] ?? '').toString();
  final bookName = (item['book_name'] ?? '').toString();
  final completedAt = DateTime.fromMillisecondsSinceEpoch((item['completed_at'] ?? 0) as int);

  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: extra.cardBackground,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: extra.cardBorder),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              _modeLabel(mode),
              style: TextStyle(
                color: _modeColor(mode),
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            Text(
              '${percentage.toStringAsFixed(1)}%',
              style: TextStyle(
                color: extra.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          '$score / $total  |  ${_formatDuration(durationSec)}',
          style: TextStyle(
            color: extra.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (topicName.isNotEmpty || bookName.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            [bookName, topicName].where((e) => e.isNotEmpty).join(' • '),
            style: TextStyle(
              color: extra.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
        const SizedBox(height: 6),
        Text(
          _formatDateTime(completedAt),
          style: TextStyle(
            color: extra.textSecondary.withValues(alpha: 0.72),
            fontSize: 12,
          ),
        ),
      ],
    ),
  );
}

String _formatDuration(int seconds) {
  if (seconds < 60) return '${seconds}s';
  final minutes = seconds ~/ 60;
  final remainingSeconds = seconds % 60;
  if (minutes < 60) return '${minutes}m ${remainingSeconds}s';
  final hours = minutes ~/ 60;
  final remainingMinutes = minutes % 60;
  return '${hours}h ${remainingMinutes}m';
}

String _formatDateTime(DateTime dateTime) {
  final month = dateTime.month.toString().padLeft(2, '0');
  final day = dateTime.day.toString().padLeft(2, '0');
  final hour = dateTime.hour.toString().padLeft(2, '0');
  final minute = dateTime.minute.toString().padLeft(2, '0');
  return '$day.$month  $hour:$minute';
}

String _modeLabel(String mode) {
  switch (mode) {
    case 'flashcard':
      return 'Flashcard';
    case 'test':
      return 'Test';
    case 'matching':
      return 'Matching';
    default:
      return mode;
  }
}

Color _modeColor(String mode) {
  switch (mode) {
    case 'flashcard':
      return const Color(0xFF3B82F6);
    case 'test':
      return const Color(0xFF10B981);
    case 'matching':
      return const Color(0xFF8B5CF6);
    default:
      return const Color(0xFF6B7280);
  }
}
