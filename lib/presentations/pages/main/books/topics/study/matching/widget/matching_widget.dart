import 'package:flutter/material.dart';
import 'package:k_quiz/data/models/word.dart';
import '../../../../../../../ui/common/gradient_card.dart';

class MatchingWidget extends StatefulWidget {
  final List<Word> words;

  const MatchingWidget({super.key, required this.words});

  @override
  State<MatchingWidget> createState() => _MatchingWidgetState();
}

class _MatchingWidgetState extends State<MatchingWidget> with TickerProviderStateMixin {
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

  IconData _getPerformanceIcon(int seconds) {
    final wordsCount = allCards.length ~/ 2;
    final avgTimePerWord = seconds / wordsCount;
    if (avgTimePerWord <= 3) {
      return Icons.emoji_events_rounded;
    } else if (avgTimePerWord <= 5) {
      return Icons.celebration_rounded;
    } else if (avgTimePerWord <= 7) {
      return Icons.sentiment_very_satisfied_rounded;
    } else {
      return Icons.sentiment_satisfied_rounded;
    }
  }

  void _showResults(int completionTime) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF10B981).withOpacity(0.2),
                      const Color(0xFF059669).withOpacity(0.2),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getPerformanceIcon(completionTime),
                  size: 64,
                  color: const Color(0xFF10B981),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                _getPerformanceText(completionTime),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                '${allCards.length ~/ 2} ta so\'zni to\'g\'ri moslashtirdingiz',
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF6B7280),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.timer_outlined,
                            color: Color(0xFF6B46C1),
                            size: 28,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${completionTime}s',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Vaqt',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Color(0xFF10B981),
                            size: 28,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$score',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Ball',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: GradientCard(
                      margin: EdgeInsets.zero,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      borderRadius: 12,
                      gradientColors: const [
                        Color(0xFF6B7280),
                        Color(0xFF4B5563),
                      ],
                      onTap: () {
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
                        // didChangeDependencies will call _initializeCards
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (mounted) {
                            setState(() {
                              _initializeCards();
                            });
                          }
                        });
                      },
                      child: const Text(
                        'Qayta',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GradientCard(
                      margin: EdgeInsets.zero,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      borderRadius: 12,
                      gradientColors: const [
                        Color(0xFF6B46C1),
                        Color(0xFF9333EA),
                      ],
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Yopish',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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