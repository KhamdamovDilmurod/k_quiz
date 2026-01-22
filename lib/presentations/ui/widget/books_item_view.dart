import 'package:flutter/material.dart';
import 'package:k_quiz/data/models/book.dart';
import 'package:k_quiz/utils/colors.dart';
import '../common/gradient_card.dart';
import '../common/learning_method_card.dart';

class BooksItemView extends StatelessWidget {
  final Book book;
  final VoidCallback onClicked;

  const BooksItemView({super.key, required this.book, required this.onClicked});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: LearningMethodCard(
        icon: Icons.menu_book_rounded,
        title: book.name,
        subtitle: book.name,
        gradientColors: [
          AppColors.randomColors[book.id % AppColors.randomColors.length],
          AppColors.randomColors[book.id % AppColors.randomColors.length],
        ],
        onTap: onClicked,
      ),
    );
  }
}
