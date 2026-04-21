import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math';
import 'package:k_quiz/config/theme/app_theme_colors.dart';
import 'package:k_quiz/data/models/word.dart';

class WritingWidget extends StatefulWidget {
  final List<Word> words;

  const WritingWidget({super.key, required this.words});

  @override
  State<WritingWidget> createState() => _WritingWidgetState();
}

class _WritingWidgetState extends State<WritingWidget> with SingleTickerProviderStateMixin {
  String currentDifficulty = 'hard'; // Faqat qiyin daraja
  List<Word> filteredWords = [];
  int currentWordIndex = 0;
  List<HiddenJamo> hiddenJamos = [];
  int score = 0;
  int correctCount = 0;
  int incorrectCount = 0;
  int timer = 0;
  Timer? timerInterval;
  Map<String, JamoStat> jamoStats = {};
  int? fastestTime;
  String message = '';
  bool isSuccess = false;
  late AnimationController _messageController;
  late Animation<double> _messageAnimation;
  late ScrollController _scrollController;
  TextEditingController? _activeController;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _messageController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _messageAnimation = CurvedAnimation(
      parent: _messageController,
      curve: Curves.easeInOut,
    );
    initFilteredWords();
    loadWord();
  }

  @override
  void dispose() {
    timerInterval?.cancel();
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void initFilteredWords() {
    // Barcha so'zlarni ishlatamiz
    filteredWords = widget.words;
  }

  void startTimer() {
    timer = 0;
    timerInterval?.cancel();
    timerInterval = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        this.timer++;
      });
    });
  }

  int stopTimer() {
    timerInterval?.cancel();
    timerInterval = null;
    return timer;
  }

  JamoDecomposition? decomposeHangul(String syllable) {
    if (syllable.isEmpty) return null;
    int code = syllable.codeUnitAt(0) - 0xAC00;
    if (code < 0 || code > 11171) return null;

    const initialConsonants = [
      'ㄱ', 'ㄲ', 'ㄴ', 'ㄷ', 'ㄸ', 'ㄹ', 'ㅁ', 'ㅂ', 'ㅃ',
      'ㅅ', 'ㅆ', 'ㅇ', 'ㅈ', 'ㅉ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ'
    ];
    const medialVowels = [
      'ㅏ', 'ㅐ', 'ㅑ', 'ㅒ', 'ㅓ', 'ㅔ', 'ㅕ', 'ㅖ', 'ㅗ',
      'ㅘ', 'ㅙ', 'ㅚ', 'ㅛ', 'ㅜ', 'ㅝ', 'ㅞ', 'ㅟ', 'ㅠ',
      'ㅡ', 'ㅢ', 'ㅣ'
    ];
    const finalConsonants = [
      '', 'ㄱ', 'ㄲ', 'ㄳ', 'ㄴ', 'ㄵ', 'ㄶ', 'ㄷ', 'ㄹ',
      'ㄺ', 'ㄻ', 'ㄼ', 'ㄽ', 'ㄾ', 'ㄿ', 'ㅀ', 'ㅁ', 'ㅂ',
      'ㅄ', 'ㅅ', 'ㅆ', 'ㅇ', 'ㅈ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ'
    ];

    int initial = code ~/ 588;
    int medial = (code % 588) ~/ 28;
    int last = code % 28;

    return JamoDecomposition(
      initial: initialConsonants[initial],
      vowel: medialVowels[medial],
      finalConsonant: last > 0 ? finalConsonants[last] : null,
    );
  }

  bool isVerticalVowel(String vowel) {
    return ['ㅏ', 'ㅐ', 'ㅑ', 'ㅒ', 'ㅓ', 'ㅔ', 'ㅕ', 'ㅖ', 'ㅣ']
        .contains(vowel);
  }

  void checkJamoInput(HiddenJamo hiddenJamo, String userChar) {
    if (!jamoStats.containsKey(hiddenJamo.correctChar)) {
      jamoStats[hiddenJamo.correctChar] = JamoStat();
    }

    if (userChar == hiddenJamo.correctChar) {
      HapticFeedback.lightImpact();
      hiddenJamo.isCorrect = true;
      hiddenJamo.isIncorrect = false;
      jamoStats[hiddenJamo.correctChar]!.correct++;
    } else {
      HapticFeedback.mediumImpact();
      hiddenJamo.isCorrect = false;
      hiddenJamo.isIncorrect = true;
      jamoStats[hiddenJamo.correctChar]!.incorrect++;
    }

    setState(() {
      updateSyllableResult();
    });
  }

  void updateSyllableResult() {
    bool allCorrect = true;
    bool allFilled = true;

    for (var jamo in hiddenJamos) {
      if (jamo.controller.text.isEmpty) allFilled = false;
      if (jamo.controller.text != jamo.correctChar) allCorrect = false;
    }

    if (allFilled && allCorrect && hiddenJamos.isNotEmpty) {
      int elapsed = stopTimer();
      int diffMulti = 3; // Qiyin daraja
      int timeBonus = elapsed < 30 ? 20 : elapsed < 60 ? 10 : 0;
      int points = 10 * diffMulti + timeBonus;

      score += points;
      correctCount++;

      if (fastestTime == null || elapsed < fastestTime!) {
        fastestTime = elapsed;
      }

      _messageController.forward();
      Future.delayed(const Duration(milliseconds: 300), () {
        setState(() {
          message = "To'g'ri! +$points ochko";
          isSuccess = true;
        });
      });
    } else if (allFilled && !allCorrect) {
      incorrectCount++;
      _messageController.forward();
      Future.delayed(const Duration(milliseconds: 100), () {
        setState(() {
          message = "Noto'g'ri. Qaytadan urinib ko'ring!";
          isSuccess = false;
        });
      });
    }
  }

  void loadWord() {
    if (filteredWords.isEmpty) return;

    final word = filteredWords[currentWordIndex];
    final syllables = word.koreanWord.split('');

    message = '';
    _messageController.reset();
    hiddenJamos.clear();

    const hidePercentage = 0.7; // Qiyin daraja

    for (int syllableIndex = 0; syllableIndex < syllables.length; syllableIndex++) {
      final jamos = decomposeHangul(syllables[syllableIndex]);
      if (jamos == null) continue;

      final hideInitial = Random().nextDouble() < hidePercentage;
      final hideVowel = Random().nextDouble() < hidePercentage;
      final hideFinal = jamos.finalConsonant != null && Random().nextDouble() < hidePercentage;

      if (hideInitial) {
        hiddenJamos.add(HiddenJamo(
          correctChar: jamos.initial,
          type: 'initial',
          syllableIndex: syllableIndex,
          controller: TextEditingController(),
        ));
      }

      if (hideVowel) {
        hiddenJamos.add(HiddenJamo(
          correctChar: jamos.vowel,
          type: 'vowel',
          syllableIndex: syllableIndex,
          controller: TextEditingController(),
        ));
      }

      if (hideFinal && jamos.finalConsonant != null) {
        hiddenJamos.add(HiddenJamo(
          correctChar: jamos.finalConsonant!,
          type: 'final',
          syllableIndex: syllableIndex,
          controller: TextEditingController(),
        ));
      }
    }

    startTimer();
    setState(() {});
  }

  void showHint() {
    if (hiddenJamos.isEmpty) {
      setState(() {
        message = "Barcha harflar ochilgan!";
        isSuccess = false;
        _messageController.forward();
      });
      return;
    }

    final randomIndex = Random().nextInt(hiddenJamos.length);
    final hint = hiddenJamos[randomIndex];

    hint.controller.text = hint.correctChar;
    hint.isHint = true;
    hint.isCorrect = true;

    hiddenJamos.removeAt(randomIndex);
    score = max(0, score - 5);
    HapticFeedback.selectionClick();
    setState(() {});
  }

  void checkAnswer() {
    HapticFeedback.selectionClick();
    updateSyllableResult();
  }

  void nextWord() {
    HapticFeedback.selectionClick();
    setState(() {
      currentWordIndex = (currentWordIndex + 1) % filteredWords.length;
      loadWord();
    });
  }

  String getTimerText() {
    int mins = timer ~/ 60;
    int secs = timer % 60;
    return '$mins:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final extra = context.appColors;
    if (filteredWords.isEmpty) {
      return Center(
        child: CircularProgressIndicator(
          color: extra.gradientStart,
        ),
      );
    }

    final word = filteredWords[currentWordIndex];
    final syllables = word.koreanWord.split('');

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Progress Section
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${currentWordIndex + 1} / ${filteredWords.length}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: extra.textSecondary,
                        ),
                      ),
                      Text(
                        '${((currentWordIndex + 1) / filteredWords.length * 100).toInt()}%',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: extra.gradientStart,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: (currentWordIndex + 1) / filteredWords.length,
                      backgroundColor: extra.cardBorder,
                      valueColor: AlwaysStoppedAnimation<Color>(extra.gradientStart),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),

            // Stats Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Ochko',
                      score.toString(),
                      Icons.emoji_events_rounded,
                      extra.gradientStart,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _buildStatCard(
                      'To\'g\'ri',
                      correctCount.toString(),
                      Icons.check_circle_rounded,
                      extra.success,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _buildStatCard(
                      'Vaqt',
                      getTimerText(),
                      Icons.timer_rounded,
                      extra.warning,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 6),

            // Main Card
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
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
                            color: Colors.white.withValues(alpha: 0.1),
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
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                      ),

                      // Content
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            // Question
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.translate_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      word.uzbekWord,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 32),

                            // Syllables
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              alignment: WrapAlignment.center,
                              children: syllables.asMap().entries.map<Widget>((entry) {
                                return _buildSyllableBox(entry.value, entry.key);
                              }).toList(),
                            ),

                            const SizedBox(height: 24),

                            // Message
                            if (message.isNotEmpty)
                              FadeTransition(
                                opacity: _messageAnimation,
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSuccess
                                        ? extra.success.withValues(alpha: 0.2)
                                        : extra.danger.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSuccess
                                          ? extra.success
                                          : extra.danger,
                                      width: 2,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Icon(
                                        isSuccess
                                            ? Icons.check_circle_rounded
                                            : Icons.cancel_rounded,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          message,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
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

            const SizedBox(height: 4),

            // Action Buttons (Icons only)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildIconButton(
                    Icons.lightbulb_outline_rounded,
                    extra.warning,
                    showHint,
                  ),
                  const SizedBox(width: 16),
                  _buildIconButton(
                    Icons.check_circle_outline_rounded,
                    extra.success,
                    checkAnswer,
                  ),
                  const SizedBox(width: 16),
                  _buildIconButton(
                    Icons.arrow_forward_rounded,
                    extra.gradientStart,
                    nextWord,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Custom Keyboard
            _buildCustomKeyboard(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    final extra = context.appColors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: extra.cardBackground,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: extra.textPrimary.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 1.5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            label,
            style: TextStyle(
              fontSize: 8,
              color: extra.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, Color color, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withValues(alpha: 0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildSyllableBox(String syllable, int syllableIndex) {
    final extra = context.appColors;
    final jamos = decomposeHangul(syllable);
    if (jamos == null) return const SizedBox();

    final isVertical = isVerticalVowel(jamos.vowel);
    final hasFinal = jamos.finalConsonant != null;

    return Container(
      width: 74,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: extra.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: extra.cardBorder.withValues(alpha: 0.6),
          width: 1.4,
        ),
      ),
      child: SizedBox(
        height: 70,
        child: hasFinal
            ? (isVertical
            ? _buildVerticalWithFinal(jamos, syllableIndex)
            : _buildHorizontalWithFinal(jamos, syllableIndex))
            : (isVertical
            ? _buildVerticalNoFinal(jamos, syllableIndex)
            : _buildHorizontalNoFinal(jamos, syllableIndex)),
      ),
    );
  }

  Widget _buildVerticalWithFinal(JamoDecomposition jamos, int syllableIndex) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(child: _buildJamoCell(jamos.initial, 'initial', syllableIndex)),
              const SizedBox(width: 2),
              Expanded(child: _buildJamoCell(jamos.vowel, 'vowel', syllableIndex)),
            ],
          ),
        ),
        const SizedBox(height: 2),
        Expanded(child: _buildJamoCell(jamos.finalConsonant!, 'final', syllableIndex)),
      ],
    );
  }

  Widget _buildHorizontalWithFinal(JamoDecomposition jamos, int syllableIndex) {
    return Column(
      children: [
        Expanded(child: _buildJamoCell(jamos.initial, 'initial', syllableIndex)),
        const SizedBox(height: 2),
        Expanded(
          child: Row(
            children: [
              Expanded(child: _buildJamoCell(jamos.vowel, 'vowel', syllableIndex)),
              const SizedBox(width: 2),
              Expanded(child: _buildJamoCell(jamos.finalConsonant!, 'final', syllableIndex)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalNoFinal(JamoDecomposition jamos, int syllableIndex) {
    return Row(
      children: [
        Expanded(child: _buildJamoCell(jamos.initial, 'initial', syllableIndex)),
        const SizedBox(width: 2),
        Expanded(child: _buildJamoCell(jamos.vowel, 'vowel', syllableIndex)),
      ],
    );
  }

  Widget _buildHorizontalNoFinal(JamoDecomposition jamos, int syllableIndex) {
    return Column(
      children: [
        Expanded(child: _buildJamoCell(jamos.initial, 'initial', syllableIndex)),
        const SizedBox(height: 2),
        Expanded(child: _buildJamoCell(jamos.vowel, 'vowel', syllableIndex)),
      ],
    );
  }

  Widget _buildJamoCell(String char, String type, int syllableIndex) {
    final extra = context.appColors;
    final hiddenJamo = hiddenJamos.firstWhere(
          (h) => h.syllableIndex == syllableIndex && h.type == type,
      orElse: () => HiddenJamo(
        correctChar: char,
        type: type,
        syllableIndex: syllableIndex,
        controller: TextEditingController(text: char),
        isHidden: false,
      ),
    );

    Color bgColor = extra.mutedSurface;
    Color borderColor = extra.cardBorder;
    Color textColor = extra.textPrimary;

    if (hiddenJamo.isHint) {
      bgColor = extra.warning.withValues(alpha: 0.12);
      borderColor = extra.warning;
      textColor = extra.warning;
    } else if (hiddenJamo.isCorrect) {
      bgColor = extra.success.withValues(alpha: 0.12);
      borderColor = extra.success;
      textColor = extra.success;
    } else if (hiddenJamo.isIncorrect) {
      bgColor = extra.danger.withValues(alpha: 0.12);
      borderColor = extra.danger;
      textColor = extra.danger;
    } else if (hiddenJamo.isHidden) {
      bgColor = extra.cardBackground;
      borderColor = extra.gradientStart;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor, width: 1.6),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Center(
        child: hiddenJamo.isHidden
            ? GestureDetector(
          onTap: () {
            setState(() {
              _activeController = hiddenJamo.controller;
            });
            // Scroll to top when tapped
            if (_scrollController.hasClients) {
              _scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          },
          child: Container(
            color: Colors.transparent,
            alignment: Alignment.center,
            child: Text(
              hiddenJamo.controller.text.isEmpty ? '' : hiddenJamo.controller.text,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        )
            : Text(
          char,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }

  Widget _buildCustomKeyboard() {
    final extra = context.appColors;
    // Koreys jamo harflari
    const initialConsonants = [
      'ㄱ', 'ㄲ', 'ㄴ', 'ㄷ', 'ㄸ', 'ㄹ', 'ㅁ', 'ㅂ', 'ㅃ',
      'ㅅ', 'ㅆ', 'ㅇ', 'ㅈ', 'ㅉ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ'
    ];
    const vowels = [
      'ㅏ', 'ㅐ', 'ㅑ', 'ㅒ', 'ㅓ', 'ㅔ', 'ㅕ', 'ㅖ', 'ㅗ',
      'ㅘ', 'ㅙ', 'ㅚ', 'ㅛ', 'ㅜ', 'ㅝ', 'ㅞ', 'ㅟ', 'ㅠ',
      'ㅡ', 'ㅢ', 'ㅣ'
    ];
    const finalConsonants = [
      'ㄱ', 'ㄲ', 'ㄳ', 'ㄴ', 'ㄵ', 'ㄶ', 'ㄷ', 'ㄹ',
      'ㄺ', 'ㄻ', 'ㄼ', 'ㄽ', 'ㄾ', 'ㄿ', 'ㅀ', 'ㅁ', 'ㅂ',
      'ㅄ', 'ㅅ', 'ㅆ', 'ㅇ', 'ㅈ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ'
    ];

    // Barcha harflarni birlashtirish
    final allJamos = <String>{
      ...initialConsonants,
      ...vowels,
      ...finalConsonants,
    }.toList();

    return Container(
      decoration: BoxDecoration(
        color: extra.cardBackground,
        boxShadow: [
          BoxShadow(
            color: extra.textPrimary.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Keyboard header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: extra.cardBorder, width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Koreys harflari',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: extra.textSecondary,
                    ),
                  ),
                  if (_activeController != null)
                    IconButton(
                      icon: const Icon(Icons.backspace_outlined, size: 20),
                      color: extra.danger,
                      onPressed: () {
                        if (_activeController != null) {
                          _activeController!.clear();
                          setState(() {});
                        }
                      },
                    ),
                ],
              ),
            ),
            // Keyboard grid
            Container(
              constraints: const BoxConstraints(maxHeight: 200),
              padding: const EdgeInsets.all(8),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 10,
                  childAspectRatio: 1.2,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemCount: allJamos.length,
                itemBuilder: (context, index) {
                  final jamo = allJamos[index];
                  return GestureDetector(
                    onTap: () {
                      if (_activeController != null) {
                        _activeController!.text = jamo;
                        // Find the hidden jamo and check it
                        final hiddenJamo = hiddenJamos.firstWhere(
                              (h) => h.controller == _activeController,
                          orElse: () => hiddenJamos.first,
                        );
                        checkJamoInput(hiddenJamo, jamo);
                        setState(() {
                          _activeController = null;
                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: extra.mutedSurface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: extra.cardBorder,
                          width: 1,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        jamo,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: extra.textPrimary,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper Classes
class JamoDecomposition {
  final String initial;
  final String vowel;
  final String? finalConsonant;

  JamoDecomposition({
    required this.initial,
    required this.vowel,
    this.finalConsonant,
  });
}

class HiddenJamo {
  final String correctChar;
  final String type;
  final int syllableIndex;
  final TextEditingController controller;
  bool isHidden;
  bool isCorrect;
  bool isIncorrect;
  bool isHint;

  HiddenJamo({
    required this.correctChar,
    required this.type,
    required this.syllableIndex,
    required this.controller,
    this.isHidden = true,
    this.isCorrect = false,
    this.isIncorrect = false,
    this.isHint = false,
  });
}

class JamoStat {
  int correct = 0;
  int incorrect = 0;
}
