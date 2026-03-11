import 'package:flutter/material.dart';
import 'package:k_quiz/data/models/user_model.dart';
import 'package:k_quiz/di/service_locator.dart';
import 'package:k_quiz/presentations/pages/main/saved/saved_words_page.dart';
import 'package:k_quiz/presentations/pages/main/statistics/statistics_page.dart';
import 'package:k_quiz/utils/colors.dart';
import 'package:k_quiz/utils/pref_utils.dart';

import '../../pages/main/books/topics/screens.dart';

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

  @override
  void initState() {
    super.initState();
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.backgroundColor,
              AppColors.backgroundColor,
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
                      title: 'Bosh sahifa',
                      gradientColors: [
                        const Color(0xFF3B82F6),
                        const Color(0xFF2563EB),
                      ],
                      isSelected: selectedItem == 'Bosh sahifa',
                      onTap: () {
                        setState(() => selectedItem = 'Bosh sahifa');
                        // Navigator.pushNamed(context, '/home');
                        Future.delayed(const Duration(milliseconds: 300), () {
                          Navigator.pop(context);
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildMenuItem(
                      icon: Icons.menu_book_rounded,
                      title: 'Kitoblar',
                      gradientColors: [
                        const Color(0xFF6B46C1),
                        const Color(0xFF9333EA),
                      ],
                      isSelected: selectedItem == 'Kitoblar',
                      onTap: () {
                        setState(() => selectedItem = 'Kitoblar');
                        Future.delayed(const Duration(milliseconds: 300), () {
                          Navigator.pop(context);
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildMenuItem(
                      icon: Icons.favorite_rounded,
                      title: 'Sevimlilar',
                      gradientColors: [
                        const Color(0xFFEC4899),
                        const Color(0xFFDB2777),
                      ],
                      isSelected: selectedItem == 'Sevimlilar',
                      onTap: () {
                        setState(() => selectedItem = 'Sevimlilar');
                        Navigator.pop(context);
                        Future.delayed(const Duration(milliseconds: 250), () {
                          if (!mounted) return;
                          Navigator.of(context).push(
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
                      title: 'Statistika',
                      gradientColors: [
                        const Color(0xFF10B981),
                        const Color(0xFF059669),
                      ],
                      isSelected: selectedItem == 'Statistika',
                      onTap: () {
                        setState(() => selectedItem = 'Statistika');
                        Navigator.pop(context);
                        Future.delayed(const Duration(milliseconds: 250), () {
                          if (!mounted) return;
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const StatisticsPage(),
                            ),
                          );
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildMenuItem(
                      icon: Icons.settings_rounded,
                      title: 'Sozlamalar',
                      gradientColors: [
                        const Color(0xFF6B7280),
                        const Color(0xFF4B5563),
                      ],
                      isSelected: selectedItem == 'Sozlamalar',
                      onTap: () {
                        setState(() => selectedItem = 'Sozlamalar');
                        Future.delayed(const Duration(milliseconds: 300), () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SettingsScreen(),
                            ),
                          );
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildMenuItem(
                      icon: Icons.login_outlined,
                      title: 'Chiqish',
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
                    const Divider(color: Colors.black26, thickness: 1),
                    const SizedBox(height: 12),
                    _buildMenuItem(
                      icon: Icons.info_rounded,
                      title: 'Dastur haqida',
                      gradientColors: [
                        const Color(0xFFF59E0B),
                        const Color(0xFFEF4444),
                      ],
                      isSelected: selectedItem == 'Dastur haqida',
                      onTap: () {
                        setState(() => selectedItem = 'Dastur haqida');
                        Future.delayed(const Duration(milliseconds: 300), () {
                          Navigator.pop(context);
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
    final user = _user;
    final userName = (user?.displayName?.trim().isNotEmpty ?? false)
        ? user!.displayName!.trim()
        : 'Foydalanuvchi';
    final userEmail = (user?.email?.trim().isNotEmpty ?? false)
        ? user!.email!.trim()
        : 'Email topilmadi';
    final userPhotoUrl = user?.photoURL;

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF6B46C1),
                  Color(0xFF9333EA),
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF9333EA).withOpacity(0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipOval(
              child: userPhotoUrl != null && userPhotoUrl.isNotEmpty
                  ? Image.network(
                userPhotoUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(
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
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            userEmail,
            style: TextStyle(
              color: Colors.black.withOpacity(0.7),
              fontSize: 14,
            ),
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: gradientColors[0].withOpacity(0.3),
        highlightColor: gradientColors[0].withOpacity(0.1),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
              colors: [
                gradientColors[0].withOpacity(0.3),
                gradientColors[1].withOpacity(0.3),
              ],
            )
                : null,
            color: isSelected ? null : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? gradientColors[0].withOpacity(0.5)
                  : Colors.white.withOpacity(0.1),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
              BoxShadow(
                color: gradientColors[0].withOpacity(0.3),
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
                  boxShadow: isSelected
                      ? [
                    BoxShadow(
                      color: gradientColors[1].withOpacity(0.4),
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
                    color: isSelected ? Colors.white: Colors.black,
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
                  color: Colors.white.withOpacity(isSelected ? 0.8 : 0.5),
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
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'K-Quiz v1.0.0',
            style: TextStyle(
              color: Colors.black.withOpacity(0.7),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '© 2024 Barcha huquqlar himoyalangan',
            style: TextStyle(
              color: Colors.black.withOpacity(0.5),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

}
