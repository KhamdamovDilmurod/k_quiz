import 'package:flutter/material.dart';
import 'package:k_quiz/data/models/word.dart';
import 'package:k_quiz/data/repositories/study_progress_repository.dart';
import 'package:k_quiz/presentations/pages/main/books/topics/study/common/study_result_dialog.dart';
import 'package:k_quiz/di/service_locator.dart';

class MatchingWidget extends StatefulWidget {
  final List<Word> words;

  const MatchingWidget({super.key, required this.words});

  @override
  State<MatchingWidget> createState() => _MatchingWidgetState();
}

class _MatchingWidgetState extends State<MatchingWidget> with TickerProviderStateMixin {
  final StudyProgressRepository _studyProgressRepository = getIt<StudyProgressRepository>();
  List<MatchCard> allCards = [];
  int? selectedIndex;
  List<int> matchedIndices = [];
  int score = 0;
  late AnimationController _successController;
  late AnimationController _errorController;
  int? wrongIndex;

  // Timer variables
  DateTime? startTime;
  int elapsedSeconds = 0;
  bool isCompleted = false;

  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    startTime = DateTime.now();
    _startTimer();
    _successController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _errorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _initializeCards();
      _isInitialized = true;
    }
  }

  void _initializeCards() {
    allCards.clear();

    // Ekran balandligiga qarab maksimal qatorlarni hisoblash
    final context = this.context;
    final screenHeight = MediaQuery.of(context).size.height;
    final safeAreaTop = MediaQuery.of(context).padding.top;
    final safeAreaBottom = MediaQuery.of(context).padding.bottom;

    final appBarHeight = 56.0;
    final headerHeight = 80.0;
    final bottomPadding = 24.0;
    final topPadding = 12.0;
    final spacing = 10.0;

    final availableHeight = screenHeight - safeAreaTop - safeAreaBottom -
        appBarHeight - headerHeight - bottomPadding - topPadding;

    final minCardHeight = 85.0;
    int maxPossibleRows = ((availableHeight - (spacing * 5)) / (minCardHeight + spacing)).floor();
    maxPossibleRows = maxPossibleRows.clamp(5, 6);

    // Barcha so'zlarni aralashtirib, keyin faqat maxPossibleRows miqdorida olish
    final shuffledWords = List<Word>.from(widget.words)..shuffle();
    final wordsToUse = shuffledWords.take(maxPossibleRows).toList();

    // Add Korean words
    for (var word in wordsToUse) {
      allCards.add(MatchCard(
        id: word.id ?? 0,
        text: word.koreanWord ?? '',
        isKorean: true,
      ));
    }

    // Add Uzbek translations
    for (var word in wordsToUse) {
      allCards.add(MatchCard(
        id: word.id ?? 0,
        text: word.uzbekWord ?? '',
        isKorean: false,
      ));
    }

    // Shuffle all cards
    allCards.shuffle();
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && !isCompleted) {
        setState(() {
          elapsedSeconds = DateTime.now().difference(startTime!).inSeconds;
        });
        _startTimer();
      }
    });
  }

  void _onCardTap(int index) {
    if (matchedIndices.contains(index)) return;

    if (selectedIndex == null) {
      // First selection
      setState(() {
        selectedIndex = index;
        wrongIndex = null;
      });
    } else if (selectedIndex == index) {
      // Deselect
      setState(() {
        selectedIndex = null;
      });
    } else {
      // Second selection - check match
      final firstCard = allCards[selectedIndex!];
      final secondCard = allCards[index];

      if (firstCard.id == secondCard.id && firstCard.isKorean != secondCard.isKorean) {
        // Correct match
        setState(() {
          matchedIndices.add(selectedIndex!);
          matchedIndices.add(index);
          score += 10;
          selectedIndex = null;
          wrongIndex = null;
        });

        _successController.forward().then((_) => _successController.reset());

        // Check if all matched
        if (matchedIndices.length == allCards.length) {
          isCompleted = true;
          final completionTime = DateTime.now().difference(startTime!).inSeconds;
          Future.delayed(const Duration(milliseconds: 500), () => _showResults(completionTime));
        }
      } else {
        // Wrong match
        setState(() {
          wrongIndex = index;
        });

        _errorController.forward().then((_) {
          _errorController.reset();
          setState(() {
            selectedIndex = null;
            wrongIndex = null;
          });
        });
      }
    }
  }

  String _getPerformanceText(int seconds) {
    final wordsCount = allCards.length ~/ 2;
    final avgTimePerWord = seconds / wordsCount;
    if (avgTimePerWord <= 3) {
      return 'Ajoyib! Juda tez!';
    } else if (avgTimePerWord <= 5) {
      return 'A\'lo! Yaxshi natija!';
    } else if (avgTimePerWord <= 7) {
      return 'Yaxshi! Davom eting!';
    } else {
      return 'Tugatdingiz!';
    }
  }

  Future<void> _showResults(int completionTime) async {
    await _saveStudyResult(completionTime);
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StudyResultDialog(accentColor: const Color(0xFF10B981),
        lottieAssetPath: 'assets/lotties/celeberate.json',
        title: _getPerformanceText(completionTime),
        subtitle: '${allCards.length ~/ 2} ta so\'zni to\'g\'ri moslashtirdingiz',
        metrics: [
          StudyResultMetric(
            value: '${completionTime}s',
            label: 'Vaqt',
          ),
          StudyResultMetric(
            value: '$score',
            label: 'Ball',
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
        secondaryAction: StudyResultAction(
          label: 'Qayta',
          gradientColors: const [
            Color(0xFF6B7280),
            Color(0xFF4B5563),
          ],
          onTap: _restartGame,
        ),
      ),
    );
  }

  Future<void> _saveStudyResult(int completionTime) async {
    if (widget.words.isEmpty) return;
    final firstWord = widget.words.first;
    final totalWords = allCards.length ~/ 2;
    await _studyProgressRepository.saveStudyResult(
      bookId: firstWord.bookId,
      topicId: firstWord.topicId,
      mode: 'matching',
      score: totalWords,
      total: totalWords,
      percentage: 100,
      durationSec: completionTime,
    );
  }

  void _restartGame() {
    Navigator.pop(context);
    setState(() {
      matchedIndices.clear();
      score = 0;
      selectedIndex = null;
      wrongIndex = null;
      isCompleted = false;
      startTime = DateTime.now();
      elapsedSeconds = 0;
      _isInitialized = false;
    });
    _startTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(_initializeCards);
      }
    });
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    if (minutes > 0) {
      return '${minutes}m ${remainingSeconds}s';
    }
    return '${seconds}s';
  }

  @override
  void dispose() {
    isCompleted = true;
    _successController.dispose();
    _errorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final safeAreaTop = MediaQuery.of(context).padding.top;
    final safeAreaBottom = MediaQuery.of(context).padding.bottom;

    final appBarHeight = 56.0;
    final headerHeight = 80.0;
    final bottomPadding = 24.0;
    final topPadding = 12.0;
    final spacing = 10.0;
    final horizontalPadding = 32.0;

    final availableHeight = screenHeight - safeAreaTop - safeAreaBottom -
        appBarHeight - headerHeight - bottomPadding - topPadding;

    // Haqiqiy qator soni (kartochkalar soniga qarab)
    final totalCards = allCards.length;
    final actualRows = (totalCards / 2).ceil(); // 2 ta ustun bo'lgani uchun

    // Maksimal qator soni ekran balandligiga qarab (5 yoki 6)
    final minCardHeight = 85.0;
    int maxPossibleRows = ((availableHeight - (spacing * 5)) / (minCardHeight + spacing)).floor();
    maxPossibleRows = maxPossibleRows.clamp(5, 6);

    // Haqiqiy qatorlar va maksimal qatorlar orasidan kichigini olish
    final rows = actualRows < maxPossibleRows ? actualRows : maxPossibleRows;

    final cardHeight = (availableHeight - (spacing * (rows - 1))) / rows;
    final cardWidth = (screenWidth - horizontalPadding - spacing) / 2;
    final aspectRatio = cardWidth / cardHeight;

    // Scroll kerakmi tekshirish
    final needsScroll = actualRows > maxPossibleRows;

    return Column(
      children: [
        // Header with timer and score
        Container(
          padding: EdgeInsets.only(
            left: screenWidth * 0.05,
            right: screenWidth * 0.05,
            top: 8
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${matchedIndices.length ~/ 2}/${allCards.length ~/ 2} moslandi',
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF6B7280),
                ),
              ),
              Row(
                children: [
                  // Timer
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.03,
                      vertical: screenHeight * 0.01,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6B46C1), Color(0xFF9333EA)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          color: Colors.white,
                          size: screenWidth * 0.04,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatTime(elapsedSeconds),
                          style: TextStyle(
                            fontSize: screenWidth * 0.035,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Score
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.03,
                      vertical: screenHeight * 0.01,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF10B981), Color(0xFF059669)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.white,
                          size: screenWidth * 0.04,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$score',
                          style: TextStyle(
                            fontSize: screenWidth * 0.035,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Grid of cards
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.fromLTRB(
              16,
              topPadding,
              16,
              bottomPadding,
            ),
            physics: needsScroll ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: spacing,
              crossAxisSpacing: spacing,
              childAspectRatio: aspectRatio,
            ),
            itemCount: allCards.length,
            itemBuilder: (context, index) {
              final card = allCards[index];
              final isMatched = matchedIndices.contains(index);
              final isSelected = selectedIndex == index;
              final isWrong = wrongIndex == index || (wrongIndex != null && selectedIndex == index);

              return AnimatedOpacity(
                opacity: isMatched ? 0.3 : 1.0,
                duration: const Duration(milliseconds: 300),
                child: AnimatedBuilder(
                  animation: _errorController,
                  builder: (context, child) {
                    final shakeOffset = isWrong ? _getShakeOffset(_errorController.value) : 0.0;

                    return Transform.translate(
                      offset: Offset(shakeOffset, 0),
                      child: child,
                    );
                  },
                  child: GestureDetector(
                    onTap: () => _onCardTap(index),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: cardWidth * 0.08,
                        vertical: cardHeight * 0.12,
                      ),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? LinearGradient(
                          colors: isWrong
                              ? [const Color(0xFFEF4444), const Color(0xFFDC2626)]
                              : [const Color(0xFF6B46C1), const Color(0xFF9333EA)],
                        )
                            : null,
                        color: isSelected ? null : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? Colors.transparent
                              : isMatched
                              ? const Color(0xFF10B981)
                              : const Color(0xFFE5E7EB),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                          if (isSelected)
                            BoxShadow(
                              color: isWrong
                                  ? const Color(0xFFEF4444).withOpacity(0.3)
                                  : const Color(0xFF9333EA).withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          card.text,
                          style: TextStyle(
                            fontSize: (cardHeight * 0.16).clamp(12.0, 18.0),
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF1F2937),
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  double _getShakeOffset(double value) {
    const shakeCount = 0.7;
    const shakeAmount = 8.0;

    return shakeAmount * (value < 0.5
        ? (value * shakeCount * 4) % 2 - 1
        : 1 - ((value - 0.5) * shakeCount * 4) % 2);
  }
}

class MatchCard {
  final int id;
  final String text;
  final bool isKorean;

  MatchCard({
    required this.id,
    required this.text,
    required this.isKorean,
  });
}
