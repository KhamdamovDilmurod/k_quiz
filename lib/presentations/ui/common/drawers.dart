import 'package:flutter/material.dart';

import '../widget/drawer_menu_item.dart';

// ============ VARIANT 1: Oddiy Drawer ============
class SimpleDrawer extends StatelessWidget {
  const SimpleDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6B46C1), Color(0xFF9333EA)],
              ),
            ),
            child: Text(
              'Menu',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Bosh sahifa'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text('Kitoblar'),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}

// ============ VARIANT 2: Minimal Drawer ============
class MinimalDrawer extends StatelessWidget {
  const MinimalDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6B46C1), Color(0xFF9333EA)],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 30),
            ),
            const SizedBox(height: 16),
            const Text(
              'Username',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            _buildSimpleItem(Icons.home, 'Bosh sahifa', context),
            _buildSimpleItem(Icons.book, 'Kitoblar', context),
            _buildSimpleItem(Icons.favorite, 'Sevimlilar', context),
            _buildSimpleItem(Icons.settings, 'Sozlamalar', context),
            const Spacer(),
            _buildSimpleItem(Icons.logout, 'Chiqish', context),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleItem(IconData icon, String title, BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF6B46C1)),
      title: Text(title),
      onTap: () => Navigator.pop(context),
    );
  }
}

// ============ VARIANT 3: Compact Drawer ============
class CompactDrawer extends StatelessWidget {
  const CompactDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 280, // Kengroq drawer
      backgroundColor: const Color(0xFFF5F5F7),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6B46C1), Color(0xFF9333EA)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.apps, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'K-Quiz',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              _buildCompactItem(Icons.home_rounded, 'Bosh sahifa', context),
              _buildCompactItem(Icons.book_rounded, 'Kitoblar', context),
              _buildCompactItem(Icons.favorite_rounded, 'Sevimlilar', context),
              _buildCompactItem(Icons.bar_chart_rounded, 'Statistika', context),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              _buildCompactItem(Icons.settings_rounded, 'Sozlamalar', context),
              _buildCompactItem(Icons.help_rounded, 'Yordam', context),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundColor: Color(0xFF6B46C1),
                      child: Icon(Icons.person, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'User Name',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'user@email.com',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactItem(IconData icon, String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => Navigator.pop(context),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, size: 22, color: const Color(0xFF6B46C1)),
              const SizedBox(width: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============ VARIANT 4: Dark Mode Drawer ============
class DarkDrawer extends StatelessWidget {
  const DarkDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF1A1A2E),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00D4FF), Color(0xFF0047FF)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00D4FF).withOpacity(0.5),
                    blurRadius: 20,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 35),
            ),
            const SizedBox(height: 16),
            const Text(
              'Dark Mode User',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            _buildDarkItem(Icons.home, 'Home', context),
            _buildDarkItem(Icons.explore, 'Explore', context),
            _buildDarkItem(Icons.favorite, 'Favorites', context),
            _buildDarkItem(Icons.settings, 'Settings', context),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Version 1.0.0',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDarkItem(IconData icon, String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: InkWell(
        onTap: () => Navigator.pop(context),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 22),
              const SizedBox(width: 16),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============ MISOL 1: Badge bilan drawer ============
class DrawerWithBadges extends StatefulWidget {
  @override
  State<DrawerWithBadges> createState() => _DrawerWithBadgesState();
}

class _DrawerWithBadgesState extends State<DrawerWithBadges> {
  String selected = 'Kitoblar';

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF1F2937),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 20),
            DrawerMenuItem(
              icon: Icons.home_rounded,
              title: 'Bosh sahifa',
              gradientColors: const [Color(0xFF3B82F6), Color(0xFF2563EB)],
              isSelected: selected == 'Bosh sahifa',
              onTap: () => setState(() => selected = 'Bosh sahifa'),
            ),
            DrawerMenuItem(
              icon: Icons.notifications_rounded,
              title: 'Bildirishnomalar',
              gradientColors: const [Color(0xFFF59E0B), Color(0xFFEF4444)],
              isSelected: selected == 'Bildirishnomalar',
              onTap: () => setState(() => selected = 'Bildirishnomalar'),
              trailing: const DrawerBadge(count: 5), // Badge
            ),
            DrawerMenuItem(
              icon: Icons.message_rounded,
              title: 'Xabarlar',
              gradientColors: const [Color(0xFF10B981), Color(0xFF059669)],
              isSelected: selected == 'Xabarlar',
              onTap: () => setState(() => selected = 'Xabarlar'),
              trailing: const DrawerBadge(count: 12),
            ),
            DrawerMenuItem(
              icon: Icons.favorite_rounded,
              title: 'Sevimlilar',
              gradientColors: const [Color(0xFFEC4899), Color(0xFFDB2777)],
              isSelected: selected == 'Sevimlilar',
              onTap: () => setState(() => selected = 'Sevimlilar'),
              trailing: const DrawerBadge(
                count: 3,
                backgroundColor: Color(0xFF6B46C1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============ MISOL 2: Minimalist drawer ============
class MinimalistDrawer extends StatefulWidget {
  @override
  State<MinimalistDrawer> createState() => _MinimalistDrawerState();
}

class _MinimalistDrawerState extends State<MinimalistDrawer> {
  String selected = 'Home';

  final items = [
    {'icon': Icons.home, 'title': 'Home', 'colors': [0xFF3B82F6, 0xFF2563EB]},
    {'icon': Icons.search, 'title': 'Search', 'colors': [0xFF10B981, 0xFF059669]},
    {'icon': Icons.person, 'title': 'Profile', 'colors': [0xFF6B46C1, 0xFF9333EA]},
    {'icon': Icons.settings, 'title': 'Settings', 'colors': [0xFF6B7280, 0xFF4B5563]},
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text(
              'Menu',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 40),
            ...items.map((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => setState(() => selected = item['title'] as String),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        color: selected == item['title']
                            ? const Color(0xFF6B46C1).withOpacity(0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            item['icon'] as IconData,
                            color: selected == item['title']
                                ? const Color(0xFF6B46C1)
                                : const Color(0xFF6B7280),
                            size: 24,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            item['title'] as String,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: selected == item['title']
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: selected == item['title']
                                  ? const Color(0xFF6B46C1)
                                  : const Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

// ============ MISOL 3: Animated scale drawer ============
class AnimatedScaleDrawer extends StatefulWidget {
  @override
  State<AnimatedScaleDrawer> createState() => _AnimatedScaleDrawerState();
}

class _AnimatedScaleDrawerState extends State<AnimatedScaleDrawer> {
  String selected = 'Dashboard';

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF1A1A2E),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(height: 20),
            _buildScaleItem(Icons.dashboard, 'Dashboard', 'Dashboard'),
            _buildScaleItem(Icons.analytics, 'Analytics', 'Analytics'),
            _buildScaleItem(Icons.people, 'Users', 'Users'),
            _buildScaleItem(Icons.settings, 'Settings', 'Settings'),
          ],
        ),
      ),
    );
  }

  Widget _buildScaleItem(IconData icon, String title, String id) {
    final isSelected = selected == id;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () => setState(() => selected = id),
        child: AnimatedScale(
          scale: isSelected ? 1.05 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? const LinearGradient(
                colors: [Color(0xFF6B46C1), Color(0xFF9333EA)],
              )
                  : null,
              color: isSelected ? null : Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              boxShadow: isSelected
                  ? [
                BoxShadow(
                  color: const Color(0xFF9333EA).withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: isSelected ? 26 : 24,
                ),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isSelected ? 18 : 16,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============ MISOL 4: Slide indicator drawer ============
class SlideIndicatorDrawer extends StatefulWidget {
  @override
  State<SlideIndicatorDrawer> createState() => _SlideIndicatorDrawerState();
}

class _SlideIndicatorDrawerState extends State<SlideIndicatorDrawer> {
  int selectedIndex = 0;

  final items = [
    {'icon': Icons.home, 'title': 'Home'},
    {'icon': Icons.explore, 'title': 'Explore'},
    {'icon': Icons.favorite, 'title': 'Favorites'},
    {'icon': Icons.settings, 'title': 'Settings'},
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            ...List.generate(items.length, (index) {
              return GestureDetector(
                onTap: () => setState(() => selectedIndex = index),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: selectedIndex == index
                        ? const Color(0xFF6B46C1).withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 4,
                        height: selectedIndex == index ? 24 : 0,
                        decoration: BoxDecoration(
                          color: const Color(0xFF6B46C1),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      SizedBox(width: selectedIndex == index ? 12 : 0),
                      Icon(
                        items[index]['icon'] as IconData,
                        color: selectedIndex == index
                            ? const Color(0xFF6B46C1)
                            : const Color(0xFF6B7280),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        items[index]['title'] as String,
                        style: TextStyle(
                          color: selectedIndex == index
                              ? const Color(0xFF6B46C1)
                              : const Color(0xFF6B7280),
                          fontWeight: selectedIndex == index
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}