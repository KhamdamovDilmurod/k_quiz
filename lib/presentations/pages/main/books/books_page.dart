import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k_quiz/presentations/pages/main/books/topics/topics_page.dart';
import 'package:k_quiz/utils/colors.dart';

import '../../../../data/bloc/base/base_state.dart';
import '../../../../di/service_locator.dart';
import '../../../ui/common/animated_drawer.dart';
import '../../../ui/common/custom_appbar.dart';
import '../../../ui/common/empty_state.dart';
import '../../../ui/widget/books_item_view.dart';
import 'books_bloc.dart';

class BooksScreen extends StatelessWidget {
  const BooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BooksBloc(getIt.get())..add(LoadBooksEvent()),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }
}

Widget _buildPage(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.backgroundColor,
    drawer: AnimatedDrawer(), // Drawer qo'shildi
    appBar: CustomAppBar(
      title: "Kitoblar ro'yxati",
      backgroundColor: AppColors.backgroundColor,
      showMenuButton: true, // Menu tugmasini yoqish
    ),
    body: SafeArea(
      child: BlocBuilder<BooksBloc, BaseState>(
        builder: (context, state) {
          if (state is ShowLoadingState && state.show) {
            return Center(child: CircularProgressIndicator());
          }

          if (state is BooksLoadedState) {
            return RefreshIndicator(
              color: const Color(0xFF9333EA),
              onRefresh: () async {
                context.read<BooksBloc>().add(RefreshBooksEvent());
              },
              child: ListView.builder(
                itemCount: state.books.length,
                padding: EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final book = state.books[index];
                  return BooksItemView(
                    book: book,
                    onClicked: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TopicsPage(bookId: book.id),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          }

          return EmptyStateWidget(
            icon: Icons.menu_book_rounded,
            title: 'Kitoblar topilmadi',
            subtitle: 'Hozircha kitoblar yo\'q',
          );
        },
      ),
    ),
  );
}