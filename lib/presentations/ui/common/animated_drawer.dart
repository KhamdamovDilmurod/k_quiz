import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:k_quiz/config/theme/app_theme_colors.dart';
import 'package:k_quiz/data/models/user_model.dart';
import 'package:k_quiz/di/service_locator.dart';
import 'package:k_quiz/presentations/pages/main/about/about_page.dart';
import 'package:k_quiz/presentations/pages/main/saved/saved_words_page.dart';
import 'package:k_quiz/presentations/pages/main/statistics/statistics_page.dart';
import 'package:k_quiz/utils/pref_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../pages/main/settings/settings_screen.dart';

class AnimatedDrawer extends StatefulWidget {
  final String? currentRoute;
  final VoidCallback? onLogout; // Joriy sahifa route'i

  const AnimatedDrawer({super.key, this.currentRoute, this.onLogout});

  @override
  State<AnimatedDrawer> createState() => _AnimatedDrawerState();
}

class _AnimatedDrawerState extends State<AnimatedDrawer> {
  String selectedItem = 'Kitoblar'; // Default tanlangan item
  UserModel? get _user => getIt<PrefUtils>().getUserData();
  late final Future<PackageInfo> _packageInfoFuture;

  @override
  void initState() {
    super.initState();
    _packageInfoFuture = PackageInfo.fromPlatform();
    // Route bo'yicha default itemni belgilash
    if (widget.currentRoute != null) {
      _setSelectedFromRoute(widget.currentRoute!);
    }
  }

  void _setSelectedFromRoute(String route) {
    if (route.contains('home')) {
      selectedItem = 'Bosh sahifa';
    } else if (route.contains('books')) {
      selectedItem = 'Kitoblar';
    } else if (route.contains('favorites')) {
      selectedItem = 'Sevimlilar';
    } else if (route.contains('statistics')) {
      selectedItem = 'Statistika';
    } else if (route.contains('about')) {
      selectedItem = 'Dastur haqida';
    }
  }

  @override
  Widget build(BuildContext context) {
    final extra = context.appColors;
    return Drawer(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              extra.mutedSurface,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildMenuItem(
                      icon: Icons.home_rounded,
                      title: 'drawer.home'.tr(),
                      gradientColors: [
                        const Color(0xFF3B82F6),
                        const Color(0xFF2563EB),
                      ],
                      isSelected: selectedItem == 'Bosh sahifa',
                      onTap: () {
                        final navigator = Navigator.of(context);
                        setState(() => selectedItem = 'Bosh sahifa');
                        Future.delayed(const Duration(milliseconds: 300), () {
                          if (!mounted) return;
                          navigator.pop();
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildMenuItem(
                      icon: Icons.menu_book_rounded,
                      title: 'drawer.books'.tr(),
                      gradientColors: [
                        const Color(0xFF6B46C1),
                        const Color(0xFF9333EA),
                      ],
                      isSelected: selectedItem == 'Kitoblar',
                      onTap: () {
                        final navigator = Navigator.of(context);
                        setState(() => selectedItem = 'Kitoblar');
                        Future.delayed(const Duration(milliseconds: 300), () {
                          if (!mounted) return;
                          navigator.pop();
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildMenuItem(
                      icon: Icons.favorite_rounded,
                      title: 'drawer.saved'.tr(),
                      gradientColors: [
                        const Color(0xFFEC4899),
                        const Color(0xFFDB2777),
                      ],
                      isSelected: selectedItem == 'Sevimlilar',
                      onTap: () {
                        final navigator = Navigator.of(context);
                        setState(() => selectedItem = 'Sevimlilar');
                        navigator.pop();
                        Future.delayed(const Duration(milliseconds: 250), () {
                          if (!mounted) return;
                          navigator.push(
                            MaterialPageRoute(
                              builder: (_) => const SavedWordsPage(),
                            ),
                          );
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildMenuItem(
                      icon: Icons.bar_chart_rounded,
                      title: 'drawer.statistics'.tr(),
                      gradientColors: [
                        const Color(0xFF10B981),
                        const Color(0xFF059669),
                      ],
                      isSelected: selectedItem == 'Statistika',
                      onTap: () {
                        final navigator = Navigator.of(context);
                        setState(() => selectedItem = 'Statistika');
                        navigator.pop();
                        Future.delayed(const Duration(milliseconds: 250), () {
                          if (!mounted) return;
                          navigator.push(
                            MaterialPageRoute(
                              builder: (_) => const StatisticsPage(),
                            ),
                          );
                        });
                      },
                    ),
                    // const SizedBox(height: 12),
                    // _buildMenuItem(
                    //   icon: Icons.sports_martial_arts,
                    //   title: 'Chizmachilik',
                    //   gradientColors: [
                    //     const Color(0xFF10B981),
                    //     const Color(0xFF059669),
                    //   ],
                    //   isSelected: selectedItem == 'Chizmachilik',
                    //   onTap: () {
                    //     final navigator = Navigator.of(context);
                    //     setState(() => selectedItem = 'Chizmachilik');
                    //     navigator.pop();
                    //     Future.delayed(const Duration(milliseconds: 250), () {
                    //       if (!mounted) return;
                    //       navigator.push(
                    //         MaterialPageRoute(
                    //           builder: (_) => const ChizmachilikPage(),
                    //         ),
                    //       );
                    //     });
                    //   },
                    // ),
                    const SizedBox(height: 12),
                    _buildMenuItem(
                      icon: Icons.settings_rounded,
                      title: 'drawer.settings'.tr(),
                      gradientColors: [
                        const Color(0xFF6B7280),
                        const Color(0xFF4B5563),
                      ],
                      isSelected: selectedItem == 'Sozlamalar',
                      onTap: () {
                        final navigator = Navigator.of(context);
                        setState(() => selectedItem = 'Sozlamalar');
                        Future.delayed(const Duration(milliseconds: 300), () {
                          if (!mounted) return;
                          navigator.push(
                            MaterialPageRoute(builder: (_) => SettingsScreen()),
                          );
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildMenuItem(
                      icon: Icons.login_outlined,
                      title: 'drawer.logout'.tr(),
                      gradientColors: [
                        const Color(0xFFEC4899),
                        const Color(0xFFDB2777),
                      ],
                      isSelected: selectedItem == 'Chiqish',
                      onTap: () {
                        setState(() => selectedItem = 'Chiqish');
                        Navigator.pop(context);
                        if (widget.onLogout != null) {
                          widget.onLogout!();
                        }
                      },
                    ),
                    const SizedBox(height: 32),
                    Divider(
                      color: Theme.of(context).dividerColor,
                      thickness: 1,
                    ),
                    _buildMenuItem(
                      icon: Icons.info_rounded,
                      title: 'drawer.about'.tr(),
                      gradientColors: [
                        const Color(0xFFF59E0B),
                        const Color(0xFFEF4444),
                      ],
                      isSelected: selectedItem == 'Dastur haqida',
                      onTap: () {
                        final navigator = Navigator.of(context);
                        setState(() => selectedItem = 'Dastur haqida');
                        Future.delayed(const Duration(milliseconds: 300), () {
                          if (!mounted) return;
                          navigator.pop();
                          navigator.push(
                            MaterialPageRoute(
                              builder: (_) => const AboutPage(),
                            ),
                          );
                        });
                      },
                    ),
                  ],
                ),
              ),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final extra = context.appColors;
    final user = _user;
    final userName =
        (user?.displayName?.trim().isNotEmpty ?? false)
            ? user!.displayName!.trim()
            : 'common.user'.tr();
    final userEmail =
        (user?.email?.trim().isNotEmpty ?? false)
            ? user!.email!.trim()
            : 'common.email_not_found'.tr();
    final userPhotoUrl = user?.photoURL;

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [extra.gradientStart, extra.gradientEnd],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: extra.gradientEnd.withValues(alpha: 0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipOval(
              child:
                  userPhotoUrl != null && userPhotoUrl.isNotEmpty
                      ? Image.network(
                        userPhotoUrl,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (_, __, ___) => const Icon(
                              Icons.person_rounded,
                              color: Colors.white,
                              size: 40,
                            ),
                      )
                      : const Icon(
                        Icons.person_rounded,
                        color: Colors.white,
                        size: 40,
                      ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            userName,
            style: TextStyle(
              color: extra.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            userEmail,
            style: TextStyle(color: extra.textSecondary, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required List<Color> gradientColors,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final extra = context.appColors;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: gradientColors[0].withValues(alpha: 0.3),
        highlightColor: gradientColors[0].withValues(alpha: 0.1),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            gradient:
                isSelected
                    ? LinearGradient(
                      colors: [
                        gradientColors[0].withValues(alpha: 0.3),
                        gradientColors[1].withValues(alpha: 0.3),
                      ],
                    )
                    : null,
            color:
                isSelected
                    ? null
                    : extra.cardBackground.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  isSelected
                      ? gradientColors[0].withValues(alpha: 0.5)
                      : extra.cardBorder.withValues(alpha: 0.5),
              width: isSelected ? 2 : 1,
            ),
            boxShadow:
                isSelected
                    ? [
                      BoxShadow(
                        color: gradientColors[0].withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                    : null,
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: isSelected ? 44 : 40,
                height: isSelected ? 44 : 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: gradientColors),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow:
                      isSelected
                          ? [
                            BoxShadow(
                              color: gradientColors[1].withValues(alpha: 0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                          : null,
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: isSelected ? 24 : 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 300),
                  style: TextStyle(
                    color: isSelected ? Colors.white : extra.textPrimary,
                    fontSize: isSelected ? 17 : 16,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  ),
                  child: Text(title),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: isSelected ? 24 : 0,
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: (isSelected ? Colors.white : extra.textSecondary)
                      .withValues(alpha: isSelected ? 0.8 : 0.5),
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    final extra = context.appColors;
    return Container(
      padding: const EdgeInsets.all(20),
      child: FutureBuilder<PackageInfo>(
        future: _packageInfoFuture,
        builder: (context, snapshot) {
          final packageInfo = snapshot.data;
          final versionText =
              packageInfo == null ? 'K-Quiz' : 'K-Quiz v${packageInfo.version}';

          return Column(
            children: [
              Text(
                versionText,
                style: TextStyle(color: extra.textSecondary, fontSize: 12),
              ),
              const SizedBox(height: 8),
              Text(
                'footer.rights'.tr(),
                style: TextStyle(
                  color: extra.textSecondary.withValues(alpha: 0.72),
                  fontSize: 10,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
