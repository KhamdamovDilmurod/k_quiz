import 'package:flutter/material.dart';
import 'package:k_quiz/data/models/word.dart';
import 'package:k_quiz/presentations/pages/main/books/topics/study/common/study_result_dialog.dart';
import 'package:k_quiz/utils/extensions.dart';

import '../../../../../../../ui/common/gradient_card.dart';
import '../../../../../../../ui/common/quiz_option_card.dart';

// ============ TEST SOZLAMALARI WIDGET ============
class TestWidget extends StatefulWidget {
  final List<Word> words;

  const TestWidget({super.key, required this.words});

  @override
  State<TestWidget> createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  int? timeLimit;
  bool showTimerDialog = true;

  void _startTest() {
    setState(() {
      showTimerDialog = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showTimerDialog) {
      return Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF10B981).withOpacity(0.2),
                      const Color(0xFF059669).withOpacity(0.2),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.timer_rounded,
                  size: 48,
                  color: Color(0xFF10B981),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Har bir savol uchun vaqt chegarasi',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              _buildTimeOption('10 soniya', 10),
              _buildTimeOption('20 soniya', 20),
              _buildTimeOption('30 soniya', 30),
              _buildTimeOption('Cheksiz vaqt', null),
              const SizedBox(height: 32),
              GradientCard(
                margin: EdgeInsets.zero,
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                borderRadius: 16,
                gradientColors: const [
                  Color(0xFF10B981),
                  Color(0xFF059669),
                ],
                onTap: _startTest,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.play_arrow_rounded, color: Colors.white, size: 24),
                    SizedBox(width: 8),
                    Text(
                      'Boshlash',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return TestQuizWidget(words: widget.words, timeLimit: timeLimit);
  }

  Widget _buildTimeOption(String label, int? seconds) {
    final isSelected = timeLimit == seconds;
    return GestureDetector(
      onTap: () => setState(() => timeLimit = seconds),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF10B981).withOpacity(0.1)
              : const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF10B981) : const Color(0xFFE5E7EB),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFF10B981) : const Color(0xFFD1D5DB),
                  width: 2,
                ),
                color: isSelected ? const Color(0xFF10B981) : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? const Color(0xFF10B981) : const Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============ TEST SAVOLLARI WIDGET ============
class TestQuizWidget extends StatefulWidget {
  final List<Word> words;
  final int? timeLimit;

  const TestQuizWidget({super.key, required this.words, this.timeLimit});

  @override
  State<TestQuizWidget> createState() => _TestQuizWidgetState();
}

class _TestQuizWidgetState extends State<TestQuizWidget> with TickerProviderStateMixin {
  int currentQuestion = 0;
  int score = 0;
  int? selectedAnswer;
  List<int> correctAnswers = [];
  AnimationController? _timerController;
  List<String> options = [];

  @override
  void initState() {
    super.initState();
    _generateOptions();
    if (widget.timeLimit != null) {
      _timerController = AnimationController(
        vsync: this,
        duration: Duration(seconds: widget.timeLimit!),
      )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _nextQuestion();
        }
      });
      _timerController!.forward();
    }
  }

  void _generateOptions() {
    final currentWord = widget.words[currentQuestion];
    final correct = currentWord.uzbekWord ?? '';
    final allWords = widget.words.map((w) => w.uzbekWord ?? '').toList()..shuffle();
    options = [correct];

    for (var word in allWords) {
      if (word != correct && options.length < 4) {
        options.add(word);
      }
    }
    options.shuffle();
  }

  void _selectAnswer(int index) {
    if (selectedAnswer != null) return;

    final currentWord = widget.words[currentQuestion];
    setState(() {
      selectedAnswer = index;
      if (options[index] == (currentWord.uzbekWord ?? '')) {
        score++;
        correctAnswers.add(currentQuestion);
      }
    });

    Future.delayed(const Duration(milliseconds: 1000), _nextQuestion);
  }

  void _nextQuestion() {
    _timerController?.stop();

    if (currentQuestion < widget.words.length - 1) {
      setState(() {
        currentQuestion++;
        selectedAnswer = null;
        _generateOptions();
      });

      if (widget.timeLimit != null) {
        _timerController?.reset();
        _timerController?.forward();
      }
    } else {
      _showResults();
    }
  }

  void _showResults() {
    final percentage = (score / widget.words.length * 100);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StudyResultDialog(
        accentColor: percentage >= 70
            ? const Color(0xFF10B981)
            : const Color(0xFFF59E0B),
        lottieAssetPath: percentage >= 70
            ? 'assets/lotties/celeberate.json'
            : 'assets/lotties/unstatification.json',
        title: 'Test yakunlandi!',
        metrics: [
          StudyResultMetric(
            value: '$score / ${widget.words.length}',
            label: 'Natija',
          ),
          StudyResultMetric(
            value: '${percentage.toStringAsFixed(1)}%',
            label: 'Foiz',
          ),
        ],
        primaryAction: StudyResultAction(
          label: 'Yopish',
          gradientColors: const [
            Color(0xFF6B46C1),
            Color(0xFF9333EA),
          ],
          onTap: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentWord = widget.words[currentQuestion];
    final correctAnswerIndex = options.indexOf(currentWord.uzbekWord ?? '');

    return Column(
      children: [
        // Custom AppBar replacement
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Savol ${currentQuestion + 1}/${widget.words.length}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF10B981), Color(0xFF059669)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Ball: $score',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (widget.timeLimit != null)
          AnimatedBuilder(
            animation: _timerController!,
            builder: (context, child) {
              return Container(
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: 1 - _timerController!.value,
                    backgroundColor: const Color(0xFFE5E7EB),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _timerController!.value > 0.7
                          ? const Color(0xFFEF4444)
                          : const Color(0xFF10B981),
                    ),
                  ),
                ),
              );
            },
          ),
        const SizedBox(height: 10),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6B46C1), Color(0xFF9333EA)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF9333EA).withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: context.getScreenWidth*.9,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.translate_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                currentWord.koreanWord ?? '',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Tarjimasini tanlang:',
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: options.length,
            itemBuilder: (context, index) {
              final isSelected = selectedAnswer == index;
              final isCorrect = index == correctAnswerIndex;

              OptionState state;
              if (selectedAnswer == null) {
                state = OptionState.normal;
              } else if (isSelected && isCorrect) {
                state = OptionState.correct;
              } else if (isSelected && !isCorrect) {
                state = OptionState.incorrect;
              } else if (isCorrect) {
                state = OptionState.correctShown;
              } else {
                state = OptionState.normal;
              }

              return QuizOptionCard(
                option: options[index],
                optionLetter: String.fromCharCode(65 + index), // A, B, C, D
                state: state,
                onTap: () => _selectAnswer(index),
              );
            },
          ),
        ),
      ],
    );
  }
}
