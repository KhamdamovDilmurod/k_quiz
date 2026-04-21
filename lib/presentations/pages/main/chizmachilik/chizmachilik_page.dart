import 'package:flutter/material.dart';
import 'package:k_quiz/config/theme/app_theme_colors.dart';
import 'package:k_quiz/data/models/chizmachilik_question.dart';
import 'package:k_quiz/data/network/chizmachilik_db.dart';
import 'package:k_quiz/presentations/pages/main/books/topics/study/common/study_result_dialog.dart';
import 'package:k_quiz/presentations/pages/main/chizmachilik/chiz.dart';
import 'package:k_quiz/presentations/ui/common/custom_appbar.dart';

class ChizmachilikPage extends StatelessWidget {
  const ChizmachilikPage({super.key});

  static final List<_ChizmachilikQuestionSet> _sets = [
    _ChizmachilikQuestionSet(
      title: 'Chizmachilik',
      subtitle: 'Asosiy chizmachilik savollari',
      icon: Icons.architecture_rounded,
      gradientColors: const [Color(0xFF2563EB), Color(0xFF14B8A6)],
      questions: chizmachilikQuestions,
    ),
    _ChizmachilikQuestionSet(
      title: 'Qalamtasvir',
      subtitle: 'Qalam, shakl va tasvir asoslari',
      icon: Icons.draw_rounded,
      gradientColors: const [Color(0xFF7C3AED), Color(0xFFEC4899)],
      questions: qalamTasvirQuestions,
    ),
    _ChizmachilikQuestionSet(
      title: 'Grafik tasvir',
      subtitle: 'Geometriya va grafik tasvir savollari',
      icon: Icons.polyline_rounded,
      gradientColors: const [Color(0xFF059669), Color(0xFFF59E0B)],
      questions: grafikTasvirQuestions,
    ),
    _ChizmachilikQuestionSet(
      title: 'Rangtasvir',
      subtitle: 'Rang va tasvir bo‘yicha mashqlar',
      icon: Icons.palette_rounded,
      gradientColors: const [Color(0xFFEA580C), Color(0xFFDC2626)],
      questions: rangTasvirQuestions,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final extra = context.appColors;
    final availableSets = _sets.where((set) => set.questions.isNotEmpty).toList();
    final totalQuestions = availableSets.fold<int>(
      0,
      (sum, set) => sum + set.questions.length,
    );

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'Chizmachilik',
        titleFontSize: 26,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: extra.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
          children: [
            _ChizmachilikHero(totalQuestions: totalQuestions),
            const SizedBox(height: 18),
            Text(
              'Test bo‘limlari',
              style: TextStyle(
                color: extra.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            for (final set in availableSets) ...[
              _QuestionSetCard(
                set: set,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => _ChizmachilikQuizPage(questionSet: set),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}

class _ChizmachilikHero extends StatelessWidget {
  final int totalQuestions;

  const _ChizmachilikHero({required this.totalQuestions});

  @override
  Widget build(BuildContext context) {
    final extra = context.appColors;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [extra.gradientStart, extra.gradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: extra.gradientEnd.withValues(alpha: 0.22),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.school_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Imtihon savollarini test orqali yodlang',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '$totalQuestions ta savol aralashtirib beriladi. Javobdan keyin to‘g‘ri variant ko‘rinadi.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.86),
              fontSize: 15,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestionSetCard extends StatelessWidget {
  final _ChizmachilikQuestionSet set;
  final VoidCallback onTap;

  const _QuestionSetCard({
    required this.set,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final extra = context.appColors;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Ink(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: extra.cardBackground,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: extra.cardBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: set.gradientColors),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(set.icon, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    set.title,
                    style: TextStyle(
                      color: extra.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    set.subtitle,
                    style: TextStyle(
                      color: extra.textSecondary,
                      fontSize: 13,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _InfoChip(
                    icon: Icons.quiz_rounded,
                    label: '${set.questions.length} ta savol',
                    color: set.gradientColors.first,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: extra.textSecondary,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

class _ChizmachilikQuizPage extends StatefulWidget {
  final _ChizmachilikQuestionSet questionSet;

  const _ChizmachilikQuizPage({required this.questionSet});

  @override
  State<_ChizmachilikQuizPage> createState() => _ChizmachilikQuizPageState();
}

class _ChizmachilikQuizPageState extends State<_ChizmachilikQuizPage> {
  late List<ChizmachilikQuestion> _questions;
  late List<String> _options;
  int _selectedCount = 10;
  int _currentIndex = 0;
  int _score = 0;
  int? _selectedAnswerIndex;
  bool _isStarted = false;

  @override
  void initState() {
    super.initState();
    _selectedCount = widget.questionSet.questions.length >= 10
        ? 10
        : widget.questionSet.questions.length;
    _questions = const [];
    _options = const [];
  }

  void _startQuiz() {
    final shuffledQuestions = List<ChizmachilikQuestion>.from(
      widget.questionSet.questions,
    )..shuffle();
    setState(() {
      _questions = shuffledQuestions.take(_selectedCount).toList();
      _currentIndex = 0;
      _score = 0;
      _selectedAnswerIndex = null;
      _isStarted = true;
    });
    _generateOptions();
  }

  void _generateOptions() {
    final question = _questions[_currentIndex];
    final answers = [
      question.answer1,
      question.answer2,
      question.answer3,
      question.answer4,
    ]..shuffle();
    setState(() => _options = answers);
  }

  void _selectAnswer(int index) {
    if (_selectedAnswerIndex != null) return;

    setState(() {
      _selectedAnswerIndex = index;
      if (_options[index] == _questions[_currentIndex].answer1) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedAnswerIndex = null;
      });
      _generateOptions();
      return;
    }
    _showResult();
  }

  void _restartQuiz() {
    Navigator.pop(context);
    setState(() => _isStarted = false);
  }

  void _showResult() {
    final percentage = _score / _questions.length * 100;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => StudyResultDialog(
        accentColor: percentage >= 70
            ? context.appColors.success
            : context.appColors.warning,
        lottieAssetPath: percentage >= 70
            ? 'assets/lotties/satisification.json'
            : 'assets/lotties/unstatification.json',
        title: 'Test yakunlandi!',
        subtitle: widget.questionSet.title,
        metrics: [
          StudyResultMetric(
            value: '$_score / ${_questions.length}',
            label: 'Natija',
          ),
          StudyResultMetric(
            value: '${percentage.toStringAsFixed(1)}%',
            label: 'Foiz',
          ),
        ],
        primaryAction: StudyResultAction(
          label: 'Qayta ishlash',
          gradientColors: widget.questionSet.gradientColors,
          onTap: _restartQuiz,
        ),
        secondaryAction: StudyResultAction(
          label: 'Bo‘limlarga qaytish',
          gradientColors: [
            context.appColors.textSecondary,
            context.appColors.textPrimary,
          ],
          onTap: () {
            Navigator.pop(dialogContext);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final extra = context.appColors;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: widget.questionSet.title,
        titleFontSize: 24,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: extra.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: _isStarted ? _buildQuiz(context) : _buildStart(context),
      ),
    );
  }

  Widget _buildStart(BuildContext context) {
    final extra = context.appColors;
    final countOptions = <int>{
      if (widget.questionSet.questions.length >= 10) 10,
      if (widget.questionSet.questions.length >= 20) 20,
      widget.questionSet.questions.length,
    }.toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: extra.cardBackground,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: extra.cardBorder),
          ),
          child: Column(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: widget.questionSet.gradientColors),
                  shape: BoxShape.circle,
                ),
                child: Icon(widget.questionSet.icon, color: Colors.white, size: 34),
              ),
              const SizedBox(height: 16),
              Text(
                widget.questionSet.title,
                style: TextStyle(
                  color: extra.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                widget.questionSet.subtitle,
                style: TextStyle(
                  color: extra.textSecondary,
                  fontSize: 15,
                  height: 1.35,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 22),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Savollar soni',
                  style: TextStyle(
                    color: extra.textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (final count in countOptions)
                    _QuestionCountButton(
                      label: count == widget.questionSet.questions.length
                          ? 'Barchasi'
                          : '$count ta',
                      count: count,
                      isSelected: _selectedCount == count,
                      accentColor: widget.questionSet.gradientColors.first,
                      onTap: () => setState(() => _selectedCount = count),
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        SizedBox(
          height: 56,
          child: ElevatedButton.icon(
            onPressed: _startQuiz,
            icon: const Icon(Icons.play_arrow_rounded, size: 28),
            label: const Text(
              'Testni boshlash',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
            ),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: widget.questionSet.gradientColors.first,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuiz(BuildContext context) {
    final extra = context.appColors;
    final question = _questions[_currentIndex];
    final correctAnswerIndex = _options.indexOf(question.answer1);
    final progress = (_currentIndex + 1) / _questions.length;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Savol ${_currentIndex + 1}/${_questions.length}',
                      style: TextStyle(
                        color: extra.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        minHeight: 8,
                        value: progress,
                        backgroundColor: extra.cardBorder,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          widget.questionSet.gradientColors.first,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              _ScorePill(score: _score, total: _questions.length),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: widget.questionSet.gradientColors),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: widget.questionSet.gradientColors.last.withValues(alpha: 0.22),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.help_outline_rounded,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Text(
                      question.question,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        height: 1.25,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'To‘g‘ri javobni tanlang:',
                style: TextStyle(
                  color: extra.textSecondary,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              for (var index = 0; index < _options.length; index++)
                QuizOptionCard(
                  option: _options[index],
                  optionLetter: String.fromCharCode(65 + index),
                  state: _optionState(index, correctAnswerIndex),
                  onTap: () => _selectAnswer(index),
                ),
              if (_selectedAnswerIndex != null) ...[
                const SizedBox(height: 4),
                _CorrectAnswerPanel(answer: question.answer1),
                const SizedBox(height: 14),
                SizedBox(
                  height: 54,
                  child: ElevatedButton.icon(
                    onPressed: _nextQuestion,
                    icon: Icon(
                      _currentIndex == _questions.length - 1
                          ? Icons.flag_rounded
                          : Icons.arrow_forward_rounded,
                    ),
                    label: Text(
                      _currentIndex == _questions.length - 1
                          ? 'Natijani ko‘rish'
                          : 'Keyingi savol',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: widget.questionSet.gradientColors.first,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  OptionState _optionState(int index, int correctAnswerIndex) {
    if (_selectedAnswerIndex == null) return OptionState.normal;
    if (index == _selectedAnswerIndex && index == correctAnswerIndex) {
      return OptionState.correct;
    }
    if (index == _selectedAnswerIndex && index != correctAnswerIndex) {
      return OptionState.incorrect;
    }
    if (index == correctAnswerIndex) return OptionState.correctShown;
    return OptionState.normal;
  }
}

class _CorrectAnswerPanel extends StatelessWidget {
  final String answer;

  const _CorrectAnswerPanel({required this.answer});

  @override
  Widget build(BuildContext context) {
    final extra = context.appColors;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: extra.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: extra.success.withValues(alpha: 0.45)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_rounded, color: extra.success),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'To‘g‘ri javob: $answer',
              style: TextStyle(
                color: extra.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w700,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestionCountButton extends StatelessWidget {
  final String label;
  final int count;
  final bool isSelected;
  final Color accentColor;
  final VoidCallback onTap;

  const _QuestionCountButton({
    required this.label,
    required this.count,
    required this.isSelected,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final extra = context.appColors;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        decoration: BoxDecoration(
          color: isSelected
              ? accentColor.withValues(alpha: 0.12)
              : extra.mutedSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? accentColor : extra.cardBorder,
            width: 1.6,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              color: isSelected ? accentColor : extra.textSecondary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? accentColor : extra.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScorePill extends StatelessWidget {
  final int score;
  final int total;

  const _ScorePill({required this.score, required this.total});

  @override
  Widget build(BuildContext context) {
    final extra = context.appColors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [extra.success, extra.success.withValues(alpha: 0.82)]),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        '$score/$total',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChizmachilikQuestionSet {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradientColors;
  final List<ChizmachilikQuestion> questions;

  const _ChizmachilikQuestionSet({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradientColors,
    required this.questions,
  });
}
