import 'package:flutter/material.dart';
import 'package:k_quiz/config/app_theme_colors.dart';
import 'package:k_quiz/presentations/ui/common/custom_appbar.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final extra = context.appColors;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'Dastur Haqida',
        backgroundColor: theme.scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: extra.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HeroCard(),
              const SizedBox(height: 18),
              _SectionTitle(
                title: 'Nima Uchun K-Quiz?',
                subtitle: 'Til o‘rganishni kichik, tez va foydali mashqlarga bo‘ladi.',
              ),
              const SizedBox(height: 12),
              const _FeatureGrid(),
              const SizedBox(height: 18),
              _SectionTitle(
                title: 'O‘rganish Formati',
                subtitle: 'Bir xil kontent turli usullarda takrorlanadi, shu sabab eslab qolish tezlashadi.',
              ),
              const SizedBox(height: 12),
              _LearningFlowCard(),
              const SizedBox(height: 18),
              _SectionTitle(
                title: 'Texnik Tomoni',
                subtitle: 'Soddalik foydalanuvchi tomonda, tartib esa arxitektura ichida.',
              ),
              const SizedBox(height: 12),
              const _StackCard(),
              const SizedBox(height: 18),
              _QuoteCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final extra = context.appColors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            extra.gradientStart,
            extra.gradientEnd,
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: extra.gradientEnd.withValues(alpha: 0.25),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -30,
            right: -24,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -36,
            left: -20,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
                child: const Icon(
                  Icons.auto_stories_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'K-Quiz',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Koreys tilini flashcard, test, matching va yozish mashqlari orqali o‘rganish uchun yaratilgan interaktiv ilova.',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 15,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: const [
                  _HeroBadge(label: 'v1.0.0'),
                  _HeroBadge(label: 'Offline baza'),
                  _HeroBadge(label: 'Study stats'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroBadge extends StatelessWidget {
  final String label;

  const _HeroBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionTitle({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final extra = context.appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: extra.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            color: extra.textSecondary,
            fontSize: 13,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}

class _FeatureGrid extends StatelessWidget {
  const _FeatureGrid();

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        icon: Icons.style_rounded,
        title: 'Flashcards',
        text: 'Tez takrorlash va eslab qolish uchun kartochkalar.',
        color: Theme.of(context).colorScheme.secondary,
      ),
      (
        icon: Icons.quiz_rounded,
        title: 'Test',
        text: 'Natijani foiz va ball bilan darhol ko‘rsatadi.',
        color: context.appColors.success,
      ),
      (
        icon: Icons.grid_view_rounded,
        title: 'Matching',
        text: 'So‘z va tarjimani tez moslash refleksini kuchaytiradi.',
        color: context.appColors.warning,
      ),
      (
        icon: Icons.bar_chart_rounded,
        title: 'Progress',
        text: 'Har bir session natijasi saqlanib, statistika hosil bo‘ladi.',
        color: context.appColors.gradientStart,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.92,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return _FeatureCard(
          icon: item.icon,
          title: item.title,
          text: item.text,
          color: item.color,
        );
      },
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;
  final Color color;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final extra = context.appColors;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: extra.cardBackground,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: extra.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color),
          ),
          const Spacer(),
          Text(
            title,
            style: TextStyle(
              color: extra.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            text,
            style: TextStyle(
              color: extra.textSecondary,
              fontSize: 12,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _LearningFlowCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final extra = context.appColors;
    final steps = [
      ('1', 'Ko‘rish', 'So‘z bilan tanishish'),
      ('2', 'Sinash', 'Test orqali tekshirish'),
      ('3', 'Moslash', 'Matching bilan tezlashtirish'),
      ('4', 'Mustahkamlash', 'Natijani statistikada ko‘rish'),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: extra.cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: extra.cardBorder),
      ),
      child: Column(
        children: steps.map((step) {
          final isLast = step == steps.last;
          return Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [extra.gradientStart, extra.gradientEnd],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    step.$1,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step.$2,
                        style: TextStyle(
                          color: extra.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        step.$3,
                        style: TextStyle(
                          color: extra.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _StackCard extends StatelessWidget {
  const _StackCard();

  @override
  Widget build(BuildContext context) {
    final extra = context.appColors;
    final tags = [
      'Flutter UI',
      'Bloc/Cubit',
      'Local DB',
      'Saved Words',
      'Study Results',
      'Theme System',
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: extra.cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: extra.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ilova modular tuzilma bilan qurilgan. O‘rganish modullari, saqlangan so‘zlar, statistika va theme boshqaruvi alohida qatlamlarga ajratilgan.',
            style: TextStyle(
              color: extra.textSecondary,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tags.map((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: extra.mutedSurface,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    color: extra.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _QuoteCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final extra = context.appColors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            extra.mutedSurface,
            extra.cardBackground,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: extra.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.format_quote_rounded,
            color: extra.gradientStart,
            size: 30,
          ),
          const SizedBox(height: 10),
          Text(
            'Har kuni kichik qadam bilan o‘rganilgan so‘z, katta sakrashdan ko‘ra ko‘proq natija beradi.',
            style: TextStyle(
              color: extra.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'K-Quiz maqsadi: o‘rganishni murakkab emas, davomli qilish.',
            style: TextStyle(
              color: extra.textSecondary,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
