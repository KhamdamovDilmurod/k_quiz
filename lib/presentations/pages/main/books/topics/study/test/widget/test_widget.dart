import 'package:flutter/material.dart';
import 'package:k_quiz/config/theme/app_theme_colors.dart';
import 'package:k_quiz/data/models/word.dart';
import 'package:k_quiz/data/repositories/word_repository.dart';
import 'package:k_quiz/data/repositories/study_progress_repository.dart';
import 'package:k_quiz/di/service_locator.dart';
import 'package:k_quiz/presentations/pages/main/books/topics/study/common/study_result_dialog.dart';

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
  int? questionLimit;
  bool showTimerDialog = true;
  late List<Word> _testWords;

  @override
  void initState() {
    super.initState();
    _testWords = widget.words;
    questionLimit = widget.words.length >= 10 ? 10 : null;
  }

  void _startTest() {
    final words = List<Word>.from(widget.words)..shuffle();
    final count = _resolvedQuestionCount(questionLimit);
    setState(() {
      _testWords = words.take(count).toList();
      showTimerDialog = false;
    });
  }

  int _resolvedQuestionCount(int? limit) {
    if (limit == null) return widget.words.length;
    if (limit > widget.words.length) return widget.words.length;
    return limit;
  }

  @override
  Widget build(BuildContext context) {
    final extra = context.appColors;
    if (showTimerDialog) {
      return Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.82,
          ),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 32,vertical: 8),
            decoration: BoxDecoration(
              color: extra.cardBackground,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      extra.success.withValues(alpha: 0.2),
                      extra.success.withValues(alpha: 0.12),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.timer_rounded,
                  size: 32,
                  color: extra.success,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Har bir savol uchun vaqt chegarasi',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: extra.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              _buildTimeOption('10 soniya', 10),
              _buildTimeOption('20 soniya', 20),
              _buildTimeOption('30 soniya', 30),
              _buildTimeOption('Cheksiz vaqt', null),
              Text(
                'Savollar soni',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: extra.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildQuestionCountOption(
                      label: '10 ta',
                      count: 10,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildQuestionCountOption(
                      label: '20 ta',
                      count: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildQuestionCountOption(
                      label: 'Barchasi',
                      count: null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
                  GradientCard(
                    margin: EdgeInsets.zero,
                    padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                    borderRadius: 16,
                    gradientColors: [
                      extra.success,
                      extra.success.withValues(alpha: 0.82),
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
          ),
        ),
      );
    }

    return TestQuizWidget(words: _testWords, timeLimit: timeLimit);
  }

  Widget _buildTimeOption(String label, int? seconds) {
    final isSelected = timeLimit == seconds;
    final extra = context.appColors;
    return GestureDetector(
      onTap: () => setState(() => timeLimit = seconds),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? extra.success.withValues(alpha: 0.1)
              : extra.mutedSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? extra.success : extra.cardBorder,
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
                  color: isSelected ? extra.success : extra.cardBorder,
                  width: 2,
                ),
                color: isSelected ? extra.success : Colors.transparent,
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
                color: isSelected ? extra.success : extra.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCountOption({
    required String label,
    required int? count,
  }) {
    final extra = context.appColors;
    final isSelected = questionLimit == count;
    final effectiveCount = count == null
        ? widget.words.length
        : (count > widget.words.length ? widget.words.length : count);

    return GestureDetector(
      onTap: () => setState(() => questionLimit = count),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? extra.gradientStart.withValues(alpha: 0.12)
              : extra.mutedSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? extra.gradientStart : extra.cardBorder,
            width: 1.6,
          ),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isSelected ? extra.gradientStart : extra.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$effectiveCount savol',
              style: TextStyle(
                fontSize: 11,
                color: extra.textSecondary,
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
  final WordRepository _wordRepository = getIt<WordRepository>();
  final StudyProgressRepository _studyProgressRepository = getIt<StudyProgressRepository>();
  final Set<int> _savedWordIds = <int>{};
  final DateTime _startedAt = DateTime.now();
  int currentQuestion = 0;
  int score = 0;
  int? selectedAnswer;
  List<int> correctAnswers = [];
  AnimationController? _timerController;
  List<String> options = [];
  bool _isSavingWord = false;

  @override
  void initState() {
    super.initState();
    _loadSavedWords();
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

  Future<void> _loadSavedWords() async {
    final savedIds = <int>{};
    for (final word in widget.words) {
      final isSaved = await _wordRepository.isWordSaved(word.id);
      if (isSaved) {
        savedIds.add(word.id);
      }
    }
    if (!mounted) return;
    setState(() {
      _savedWordIds
        ..clear()
        ..addAll(savedIds);
    });
  }

  Future<void> _toggleCurrentWordSaved() async {
    if (_isSavingWord || widget.words.isEmpty) return;
    final currentWord = widget.words[currentQuestion];
    final wordId = currentWord.id;

    setState(() => _isSavingWord = true);
    final alreadySaved = _savedWordIds.contains(wordId);
    final success = alreadySaved
        ? await _wordRepository.removeFromSaved(wordId)
        : await _wordRepository.addToSaved(wordId);

    if (!mounted) return;

    if (success) {
      setState(() {
        if (alreadySaved) {
          _savedWordIds.remove(wordId);
        } else {
          _savedWordIds.add(wordId);
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            alreadySaved
                ? 'So\'z saqlanganlardan olib tashlandi'
                : 'So\'z saqlandi',
          ),
          duration: const Duration(milliseconds: 1200),
        ),
      );
    }

    setState(() => _isSavingWord = false);
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

  Future<void> _showResults() async {
    final percentage = (score / widget.words.length * 100);
    final durationSec = DateTime.now().difference(_startedAt).inSeconds;
    await _saveStudyResult(percentage, durationSec);
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StudyResultDialog(
        accentColor: percentage >= 70
            ? context.appColors.success
            : context.appColors.warning,
        lottieAssetPath: percentage >= 70
            ? 'assets/lotties/satisification.json'
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
          gradientColors: [
            context.appColors.gradientStart,
            context.appColors.gradientEnd,
          ],
          onTap: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  Future<void> _saveStudyResult(double percentage, int durationSec) async {
    if (widget.words.isEmpty) return;
    final firstWord = widget.words.first;
    await _studyProgressRepository.saveStudyResult(
      bookId: firstWord.bookId,
      topicId: firstWord.topicId,
      mode: 'test',
      score: score,
      total: widget.words.length,
      percentage: percentage,
      durationSec: durationSec,
    );
  }

  @override
  void dispose() {
    _timerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final extra = context.appColors;
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
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: extra.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      extra.success,
                      extra.success.withValues(alpha: 0.82),
                    ],
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
                    backgroundColor: extra.cardBorder,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _timerController!.value > 0.7
                          ? extra.danger
                          : extra.success,
                    ),
                  ),
                ),
              );
            },
          ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [extra.gradientStart, extra.gradientEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: extra.gradientEnd.withValues(alpha: 0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                right: 0,
                child: _buildSaveButton(currentWord.id),
              ),
              Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
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
            ],
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Tarjimasini tanlang:',
            style: TextStyle(
              fontSize: 18,
              color: extra.textSecondary,
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

  Widget _buildSaveButton(int wordId) {
    final isSaved = _savedWordIds.contains(wordId);
    return GestureDetector(
      onTap: _toggleCurrentWordSaved,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: isSaved
              ? context.appColors.warning.withValues(alpha: 0.16)
              : context.appColors.cardBorder,
          borderRadius: BorderRadius.circular(12),
        ),
        child: _isSavingWord
            ? const Padding(
                padding: EdgeInsets.all(10),
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(
                isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                color: isSaved ? context.appColors.warning : context.appColors.textSecondary,
              ),
      ),
    );
  }
}
