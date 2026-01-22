import 'package:flutter/material.dart';
import 'package:k_quiz/data/models/topic.dart';

import '../../../generated/assets.dart';
import '../../../utils/colors.dart';
import '../common/gradient_card.dart';
import '../common/learning_method_card.dart';

class TopicsItemView extends StatelessWidget {
  final Topic topic;
  final VoidCallback onClicked;

  const TopicsItemView({super.key, required this.topic, required this.onClicked});

  @override
  Widget build(BuildContext context) {
    return
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: LearningMethodCard(
          icon: Icons.menu_book_rounded,
          title: topic.topic,
          subtitle: topic.topic,
          gradientColors: [
            AppColors.randomColors[topic.topicId % AppColors.randomColors.length],
            AppColors.randomColors[topic.topicId % AppColors.randomColors.length],
          ],
          onTap: onClicked,
        ),
      );
  }
}
