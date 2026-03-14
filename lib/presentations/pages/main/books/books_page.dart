import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k_quiz/config/theme/app_theme_colors.dart';
import 'package:k_quiz/presentations/pages/auth/login_screen.dart';
import 'package:k_quiz/presentations/pages/main/books/topics/topics_page.dart';
import 'package:k_quiz/utils/pref_utils.dart';

import '../../../../data/bloc/base/base_state.dart';
import '../../../../di/service_locator.dart';
import '../../../ui/common/animated_drawer.dart';
import '../../../ui/common/custom_appbar.dart';
import '../../../ui/common/empty_state.dart';
import '../../../ui/widget/books_item_view.dart';
import '../../auth/auth_bloc.dart';
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
  final user = getIt<PrefUtils>().getUserData();
  final colorScheme = Theme.of(context).colorScheme;
  final appBarTitle = (user?.displayName?.trim().isNotEmpty ?? false)
      ? "Kitoblar - ${user!.displayName!.trim()}"
      : "Kitoblar ro'yxati";

  return Scaffold(
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    drawer: AnimatedDrawer(onLogout: () => _showLogoutDialog(context),),
    appBar: CustomAppBar(
      title: appBarTitle,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      showMenuButton: true,
    ),
    body: SafeArea(
      child: BlocBuilder<BooksBloc, BaseState>(
        builder: (context, state) {
          if (state is ShowLoadingState && state.show) {
            return Center(child: CircularProgressIndicator());
          }

          if (state is BooksLoadedState) {
            return RefreshIndicator(
              color: colorScheme.primary,
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

void _showLogoutDialog(BuildContext context) {
  final extra = context.appColors;
  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text('Chiqish'),
      content: Text('Haqiqatan ham chiqmoqchimisiz?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: Text('Yo\'q'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(dialogContext);
            // AuthBloc-ga signout event yuborish
            context.read<AuthBloc>().add(AuthSignOutRequested());
            // Barcha sahifalarni tozalash va login sahifasiga o'tish
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => LoginScreen()),
                  (route) => false,
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: extra.danger,
          ),
          child: Text('Ha, chiqish'),
        ),
      ],
    ),
  );
}
