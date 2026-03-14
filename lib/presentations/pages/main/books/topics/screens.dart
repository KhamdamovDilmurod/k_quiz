
import '../../../../../data/network/database_helper.dart';
import '../../../../../data/repositories/word_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../config/app_theme_colors.dart';
import '../../../../../config/theme_cubit.dart';

import '../../../../../services/google_sheets_service.dart';

// ============================================
// 14. lib/screens/settings_screen.dart
// ============================================
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isLoading = false;
  Map<String, int> _counts = {};
  DateTime? _lastSyncedAt;

  @override
  void initState() {
    super.initState();
    _loadCounts();
  }

  Future<void> _loadCounts() async {
    final db = await DatabaseHelper.instance.database;
    final repository = WordRepository(db);
    _counts = await repository.getDataCount();
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _syncWithGoogleSheets() async {
    setState(() => _isLoading = true);

    try {
      final db = await DatabaseHelper.instance.database;
      final sheetsService = GoogleSheetsService(db);

      final counts = await sheetsService.importAllFromGoogleSheets();

      if (!mounted) return;
      setState(() {
        _counts = counts;
        _lastSyncedAt = DateTime.now();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Yangilandi: ${counts['books']} kitob, ${counts['topics']} topic, ${counts['words']} soz',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Xatolik: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme;
    final extra = context.appColors;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              extra.mutedSurface,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: extra.textPrimary,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Sozlamalar',
                        style: titleStyle.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: extra.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                  children: [
                    _buildThemeModeCard(context),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.secondary,
                            Theme.of(context).colorScheme.secondary.withValues(alpha: 0.82),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.25),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Ma\'lumotlar holati',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _lastSyncedAt == null
                                ? 'So\'nggi sync: hali bajarilmagan'
                                : 'So\'nggi sync: ${_lastSyncedAt!.hour.toString().padLeft(2, '0')}:${_lastSyncedAt!.minute.toString().padLeft(2, '0')}',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildCountCard(
                            icon: Icons.menu_book_rounded,
                            label: 'Kitoblar',
                            value: _counts['books'] ?? 0,
                            color: const Color(0xFF16A34A),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildCountCard(
                            icon: Icons.topic_rounded,
                            label: 'Topiclar',
                            value: _counts['topics'] ?? 0,
                            color: const Color(0xFFF59E0B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildCountCard(
                      icon: Icons.text_fields_rounded,
                      label: 'Sozlar',
                      value: _counts['words'] ?? 0,
                      color: const Color(0xFF7C3AED),
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: _isLoading ? null : _syncWithGoogleSheets,
                      borderRadius: BorderRadius.circular(18),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: extra.cardBackground,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: extra.cardBorder),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.14),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: _isLoading
                                  ? const Padding(
                                      padding: EdgeInsets.all(10),
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : const Icon(
                                      Icons.cloud_download_rounded,
                                      color: Color(0xFF1D4ED8),
                                    ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Google Sheets dan yangilash',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                      color: extra.textPrimary,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Baza ichidagi kitob/topic/sozlarni qayta yuklaydi',
                                    style: TextStyle(
                                      color: extra.textSecondary,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 16,
                              color: extra.textSecondary.withValues(alpha: 0.7),
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
    );
  }

  Widget _buildCountCard({
    required IconData icon,
    required String label,
    required int value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.appColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    color: context.appColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$value',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: context.appColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeModeCard(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final extra = context.appColors;

    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final isSystem = state.themeMode == ThemeMode.system;
        final isDark = state.themeMode == ThemeMode.dark;

        return Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: extra.cardBorder),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ko\'rinish rejimi',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              _buildSwitchRow(
                icon: Icons.brightness_auto_rounded,
                title: 'System mode',
                subtitle: 'Telefon sozlamasiga moslashadi',
                value: isSystem,
                onChanged: (value) {
                  context.read<ThemeCubit>().changeTheme(
                    value ? ThemeMode.system : ThemeMode.light,
                  );
                },
              ),
              const SizedBox(height: 10),
              _buildSwitchRow(
                icon: Icons.dark_mode_rounded,
                title: 'Dark mode',
                subtitle: 'Qorong\'i rejimni yoqish/o\'chirish',
                value: isDark,
                onChanged: (value) {
                  context.read<ThemeCubit>().changeTheme(
                    value ? ThemeMode.dark : ThemeMode.light,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSwitchRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final extra = context.appColors;
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Theme.of(context).colorScheme.secondary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  color: extra.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        CupertinoSwitch(
          value: value,
          onChanged: onChanged,
          activeTrackColor: extra.success,
        ),
      ],
    );
  }
}
