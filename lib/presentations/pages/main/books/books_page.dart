import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
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
  final appBarTitle =
      (user?.displayName?.trim().isNotEmpty ?? false)
          ? 'books.title_with_name'.tr(
            namedArgs: {'name': user!.displayName!.trim()},
          )
          : 'books.list_title'.tr();

  return Scaffold(
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    drawer: AnimatedDrawer(onLogout: () => _showLogoutDialog(context)),
    appBar: CustomAppBar(
      title: appBarTitle,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      showMenuButton: true,
      actions: [_buildLanguageAction(context), const SizedBox(width: 8)],
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
            title: 'books.not_found'.tr(),
            subtitle: 'books.empty'.tr(),
          );
        },
      ),
    ),
  );
}

Widget _buildLanguageAction(BuildContext context) {
  final extra = context.appColors;
  final currentCode = context.locale.languageCode;
  final currentLabel = currentCode == 'ko' ? 'KO' : 'UZ';

  return PopupMenuButton<Locale>(
    tooltip: 'settings.language'.tr(),
    onSelected: (locale) => _changeLanguage(context, locale),
    offset: const Offset(0, 50),
    color: extra.cardBackground,
    elevation: 12,
    shadowColor: Colors.black.withValues(alpha: 0.16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
      side: BorderSide(color: extra.cardBorder),
    ),
    itemBuilder:
        (context) => [
          PopupMenuItem(
            value: const Locale('uz'),
            child: _buildLanguageMenuItem(
              context: context,
              title: 'languages.uz'.tr(),
              subtitle: 'languages.uz_native'.tr(),
              selected: currentCode == 'uz',
            ),
          ),
          PopupMenuItem(
            value: const Locale('ko'),
            child: _buildLanguageMenuItem(
              context: context,
              title: 'languages.ko'.tr(),
              subtitle: 'languages.ko_native'.tr(),
              selected: currentCode == 'ko',
            ),
          ),
        ],
    child: Container(
      constraints: const BoxConstraints(minWidth: 76),
      height: 40,
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            extra.gradientStart.withValues(alpha: 0.95),
            extra.gradientEnd.withValues(alpha: 0.95),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: extra.gradientEnd.withValues(alpha: 0.18),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.language_rounded, color: Colors.white, size: 20),
          const SizedBox(width: 7),
          Text(
            currentLabel,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 13,
            ),
          ),
          const SizedBox(width: 2),
          const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.white,
            size: 18,
          ),
        ],
      ),
    ),
  );
}

Widget _buildLanguageMenuItem({
  required BuildContext context,
  required String title,
  required String subtitle,
  required bool selected,
}) {
  final extra = context.appColors;

  return Container(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color:
                selected
                    ? Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.14)
                    : extra.mutedSurface.withValues(alpha: 0.74),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            selected ? Icons.check_circle_rounded : Icons.translate_rounded,
            color:
                selected
                    ? Theme.of(context).colorScheme.primary
                    : extra.textSecondary,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: extra.textPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(color: extra.textSecondary, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Future<void> _changeLanguage(BuildContext context, Locale locale) async {
  await context.setLocale(locale);
  await getIt<PrefUtils>().setLang(locale.languageCode);
}

void _showLogoutDialog(BuildContext context) {
  final extra = context.appColors;
  final theme = Theme.of(context);
  showDialog(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.35),
    builder:
        (dialogContext) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: extra.cardBackground,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: extra.cardBorder.withValues(alpha: 0.75),
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.shadow.withValues(alpha: 0.18),
                  blurRadius: 28,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        extra.danger,
                        extra.danger.withValues(alpha: 0.78),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'drawer.logout'.tr(),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: extra.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'logout.confirm_message'.tr(),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: extra.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          side: BorderSide(color: extra.cardBorder),
                          backgroundColor: extra.mutedSurface.withValues(
                            alpha: 0.55,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          'common.cancel'.tr(),
                          style: TextStyle(
                            color: extra.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              extra.danger,
                              extra.danger.withValues(alpha: 0.82),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(dialogContext);
                            context.read<AuthBloc>().add(
                              AuthSignOutRequested(),
                            );
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (_) => const LoginScreen(),
                              ),
                              (route) => false,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            'logout.confirm'.tr(),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
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
