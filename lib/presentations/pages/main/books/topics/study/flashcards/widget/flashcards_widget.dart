import 'dart:math';
import 'package:flutter/material.dart';
import 'package:k_quiz/presentations/pages/main/books/topics/study/common/study_result_dialog.dart';
import 'package:k_quiz/utils/extensions.dart';

import '../../../../../../../../data/models/word.dart';
import '../../../../../../../../di/service_locator.dart';
import '../../../../../../../ui/common/gradient_card.dart';
import '../../../../../../../../services/tts_service.dart';


// ============ FLASHCARDS WIDGET ============
class FlashcardsWidget extends StatefulWidget {
  final List<Word> words;

  const FlashcardsWidget({super.key, required this.words});

  @override
  State<FlashcardsWidget> createState() => _FlashcardsWidgetState();
}

class _FlashcardsWidgetState extends State<FlashcardsWidget> {
  late PageController _pageController;
  late DateTime _startedAt;
  int currentIndex = 0;
  bool isFlipped = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startedAt = DateTime.now();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextCard() {
    if (currentIndex < widget.words.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _handleNextAction() {
    if (currentIndex < widget.words.length - 1) {
      _nextCard();
      return;
    }
    _showResults();
  }

  void _previousCard() {
    if (currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      currentIndex = index;
      isFlipped = false;
    });
  }

  void _showResults() {
    final completionSeconds = DateTime.now().difference(_startedAt).inSeconds;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StudyResultDialog(
        accentColor: const Color(0xFF3B82F6),
        lottieAssetPath: 'assets/lotties/celeberate.json',
        title: 'Flashcard yakunlandi!',
        subtitle: '${widget.words.length} ta kartochkani ko\'rib chiqdingiz',
        metrics: [
          StudyResultMetric(
            value: '${widget.words.length}',
            label: 'Kartochka',
          ),
          StudyResultMetric(
            value: '${completionSeconds}s',
            label: 'Vaqt',
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
          onTap: _restartFlashcards,
        ),
      ),
    );
  }

  void _restartFlashcards() {
    Navigator.pop(context);
    _pageController.jumpToPage(0);
    setState(() {
      currentIndex = 0;
      isFlipped = false;
      _startedAt = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        // Progress indicator
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${currentIndex + 1} / ${widget.words.length}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  Text(
                    '${((currentIndex + 1) / widget.words.length * 100).toInt()}%',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B46C1),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: (currentIndex + 1) / widget.words.length,
                  backgroundColor: const Color(0xFFE5E7EB),
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6B46C1)),
                  minHeight: 8,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: widget.words.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Center(
                  child: FlashcardItem(
                    word: widget.words[index],
                    isCurrentCard: index == currentIndex,
                  ),
                ),
              );
            },
          ),
        ),
        // Hint text
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: const [
                Icon(
                  Icons.swipe_rounded,
                  color: Color(0xFF3B82F6),
                  size: 20,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Kartochkani bosing yoki chap/o\'ngga suring',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF3B82F6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Navigation buttons
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: _buildNavButton(
                  icon: Icons.arrow_back_rounded,
                  label: 'Oldingi',
                  isEnabled: currentIndex > 0,
                  onPressed: _previousCard,
                  gradientColors: [
                    const Color(0xFF6B7280),
                    const Color(0xFF4B5563),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildNavButton(
                  icon: currentIndex < widget.words.length - 1
                      ? Icons.arrow_forward_rounded
                      : Icons.check_circle_rounded,
                  label: currentIndex < widget.words.length - 1
                      ? 'Keyingi'
                      : 'Yakunlash',
                  isEnabled: true,
                  onPressed: _handleNextAction,
                  gradientColors: [
                    const Color(0xFF6B46C1),
                    const Color(0xFF9333EA),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required String label,
    required bool isEnabled,
    required VoidCallback onPressed,
    required List<Color> gradientColors,
  }) {
    return GradientCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      borderRadius: 16,
      gradientColors: isEnabled
          ? gradientColors
          : [
        const Color(0xFFE5E7EB),
        const Color(0xFFD1D5DB),
      ],
      onTap: isEnabled ? onPressed : null,
      enableAnimation: isEnabled,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

// ============ FLASHCARD ITEM ============
class FlashcardItem extends StatefulWidget {
  final Word word;
  final bool isCurrentCard;

  const FlashcardItem({
    super.key,
    required this.word,
    required this.isCurrentCard,
  });

  @override
  State<FlashcardItem> createState() => _FlashcardItemState();
}

class _FlashcardItemState extends State<FlashcardItem> {
  bool isFlipped = false;
  late TtsService _ttsService;
  bool isSpeaking = false;

  @override
  void initState() {
    super.initState();
    _ttsService = getIt<TtsService>();
    _setupTtsHandlers();
  }

  void _setupTtsHandlers() {
    _ttsService.setCompletionHandler(() {
      if (mounted) {
        setState(() {
          isSpeaking = false;
        });
      }
    });

    _ttsService.setErrorHandler((msg) {
      if (mounted) {
        setState(() {
          isSpeaking = false;
        });
      }
      print("TTS xatosi: $msg");
    });

    _ttsService.setStartHandler(() {
      if (mounted) {
        setState(() {
          isSpeaking = true;
        });
      }
    });
  }

  @override
  void didUpdateWidget(FlashcardItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reset flip when card changes
    if (widget.isCurrentCard != oldWidget.isCurrentCard && !widget.isCurrentCard) {
      setState(() {
        isFlipped = false;
        isSpeaking = false;
      });
      _ttsService.stop();
    }
  }

  void _flipCard() {
    setState(() {
      isFlipped = !isFlipped;
    });
  }

  Future<void> _speak() async {
    if (isSpeaking) {
      await _ttsService.stop();
      setState(() {
        isSpeaking = false;
      });
    } else {
      final koreanWord = widget.word.koreanWord ?? '';
      if (koreanWord.isNotEmpty) {
        await _ttsService.speakKorean(koreanWord);
      }
    }
  }

  @override
  void dispose() {
    _ttsService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flipCard,
      child: FlipCard(
        isFlipped: isFlipped,
        frontText: widget.word.koreanWord ?? '',
        backText: widget.word.uzbekWord ?? '',
        onSpeak: _speak,
        isSpeaking: isSpeaking,
      ),
    );
  }
}

// ============ ANIMATSIYALI FLIP CARD ============
class FlipCard extends StatefulWidget {
  final bool isFlipped;
  final String frontText;
  final String backText;
  final VoidCallback onSpeak;
  final bool isSpeaking;

  const FlipCard({
    super.key,
    required this.isFlipped,
    required this.frontText,
    required this.backText,
    required this.onSpeak,
    required this.isSpeaking,
  });

  @override
  State<FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(FlipCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFlipped != oldWidget.isFlipped) {
      if (widget.isFlipped) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final angle = _animation.value * pi;
        final transform = Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateY(angle);

        return Transform(
          transform: transform,
          alignment: Alignment.center,
          child: angle < pi / 2
              ? _buildCardSide(
            widget.frontText,
            [const Color(0xFF3B82F6), const Color(0xFF2563EB)],
            Icons.translate_rounded,
            showVoiceButton: true,
          )
              : Transform(
            transform: Matrix4.identity()..rotateY(pi),
            alignment: Alignment.center,
            child: _buildCardSide(
              widget.backText,
              [const Color(0xFF10B981), const Color(0xFF059669)],
              Icons.check_circle_outline_rounded,
              showVoiceButton: false,
            ),
          ),
        );
      },
    );
  }

  Widget _buildCardSide(
      String text,
      List<Color> gradientColors,
      IconData icon,
      {required bool showVoiceButton}
      ) {
    return Container(
      width: context.getScreenWidth * .9,
      height: context.getScreenHeight * .4,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: gradientColors[1].withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: -30,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          // Voice button (top right)
          if (showVoiceButton)
            Positioned(
              top: 20,
              right: 20,
              child: GestureDetector(
                onTap: widget.onSpeak,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    widget.isSpeaking ? Icons.volume_up_rounded : Icons.volume_up_outlined,
                    size: 28,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          // Content
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      size: 24,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
