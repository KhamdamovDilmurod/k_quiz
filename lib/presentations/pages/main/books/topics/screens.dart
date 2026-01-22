
import '../../../../../data/models/book.dart';
import '../../../../../data/models/topic.dart';
import '../../../../../data/models/word.dart';
import '../../../../../data/network/database_helper.dart';
import '../../../../../data/repositories/word_repository.dart';
import 'package:flutter/material.dart';

import '../../../../../services/google_sheets_service.dart';

// ============================================
// 14. lib/screens/settings_screen.dart
// ============================================
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isLoading = false;
  Map<String, int> _counts = {};

  @override
  void initState() {
    super.initState();
    _loadCounts();
  }

  Future<void> _loadCounts() async {
    final db = await DatabaseHelper.instance.database;
    final repository = WordRepository(db);
    _counts = await repository.getDataCount();
    setState(() {});
  }

  Future<void> _syncWithGoogleSheets() async {
    setState(() => _isLoading = true);

    try {
      final db = await DatabaseHelper.instance.database;
      final sheetsService = GoogleSheetsService(db);

      final counts = await sheetsService.importAllFromGoogleSheets();

      setState(() => _counts = counts);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '✅ Yangilandi: ${counts['books']} kitob, '
                  '${counts['topics']} topic, ${counts['words']} so\'z'
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Xatolik: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sozlamalar')),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.book),
            title: Text('Kitoblar'),
            trailing: Text('${_counts['books'] ?? 0}'),
          ),
          ListTile(
            leading: Icon(Icons.topic),
            title: Text('Topiclar'),
            trailing: Text('${_counts['topics'] ?? 0}'),
          ),
          ListTile(
            leading: Icon(Icons.text_fields),
            title: Text('So\'zlar'),
            trailing: Text('${_counts['words'] ?? 0}'),
          ),
          Divider(),
          ListTile(
            leading: _isLoading
                ? SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : Icon(Icons.cloud_download),
            title: Text('Google Sheets dan yangilash'),
            subtitle: Text('Yangi so\'zlarni yuklash'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: _isLoading ? null : _syncWithGoogleSheets,
          ),
        ],
      ),
    );
  }
}