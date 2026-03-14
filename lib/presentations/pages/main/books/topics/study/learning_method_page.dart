import 'package:flutter/material.dart';
import 'package:k_quiz/config/theme/app_theme_colors.dart';
import 'package:k_quiz/presentations/pages/main/books/topics/study/matching/matching_page.dart';
import 'package:k_quiz/presentations/pages/main/books/topics/study/test/test_page.dart';
import 'package:k_quiz/presentations/pages/main/books/topics/study/writing/writing_page.dart';
import '../../../../../ui/common/custom_appbar.dart';
import '../../../../../ui/common/learning_method_card.dart';
import 'flashcards/flashcards_page.dart';


class LearningMethodScreen extends StatelessWidget {
  final int topicId;

  const LearningMethodScreen({
    super.key, required this.topicId,
  });

  @override
  Widget build(BuildContext context) {
    final extra = context.appColors;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: "Interaktiv uslullar",
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: extra.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                "Qaysi usulda o'rganmoqchisiz?",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: extra.textPrimary,
                ),
              ),
              const SizedBox(height: 32),
              LearningMethodCard(
                icon: Icons.style_rounded,
                title: 'Flashcards',
                subtitle: "So'zlarni kartochkalar orqali o'rganing",
                gradientColors: [
                  const Color(0xFF3B82F6),
                  const Color(0xFF2563EB),
                ],
                onTap: () {
                  // Flashcards sahifasiga o'tish
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FlashcardsPage(topicId: topicId,),
                    ),
                  );
                  print('Flashcards tanlandi');
                },
              ),
              const SizedBox(height: 16),
              LearningMethodCard(
                icon: Icons.quiz_rounded,
                title: 'Test',
                subtitle: "Testlar yechib bilimingizni sinab ko'ring",
                gradientColors: [
                  const Color(0xFF10B981),
                  const Color(0xFF059669),
                ],
                onTap: () {
                  // Test sahifasiga o'tish
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TestPage(topicId:topicId),
                    ),
                  );
                  print('Test tanlandi');
                },
              ),
              const SizedBox(height: 16),
              LearningMethodCard(
                icon: Icons.medical_information,
                title: 'Matching',
                subtitle: "Testlar yechib bilimingizni sinab ko'ring",
                gradientColors: [
                  const Color(0xFF10B981),
                  const Color(0xFF059669),
                ],
                onTap: () {
                  // Test sahifasiga o'tish
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MatchingPage(topicId:topicId),
                    ),
                  );
                  print('Matching page tanlandi');
                },
              ),
              const SizedBox(height: 16),
              LearningMethodCard(
                icon: Icons.edit_rounded,
                title: 'Yozish',
                subtitle: "So'zlarni yozib o'rganish",
                gradientColors: [
                  const Color(0xFFF59E0B),
                  const Color(0xFFEF4444),
                ],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WritingPage(topicId:topicId),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              // Yana qo'shimcha usullar qo'shish mumkin
              LearningMethodCard(
                icon: Icons.headphones_rounded,
                title: 'Tinglash',
                subtitle: "So'zlarni tinglab o'rganish",
                gradientColors: [
                  const Color(0xFF8B5CF6),
                  const Color(0xFF7C3AED),
                ],
                onTap: () {
                  print('Tinglash tanlandi');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
