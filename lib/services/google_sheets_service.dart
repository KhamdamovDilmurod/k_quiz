import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';
import 'package:sqflite/sqflite.dart';

import '../config/google_sheets_config.dart';

typedef ImportProgressCallback = void Function(double progress, String message);

class GoogleSheetsService {
  final Database db;

  GoogleSheetsService(this.db);

  // Barcha ma'lumotlarni import qilish
  Future<Map<String, int>> importAllFromGoogleSheets({
    ImportProgressCallback? onProgress,
  }) async {
    try {
      print('📚 Import boshlandi...');

      onProgress?.call(0.15, 'Eski ma\'lumotlar tozalanmoqda...');
      await clearAllData();

      onProgress?.call(0.30, 'Kitoblar yuklanmoqda...');
      final booksCount = await importBooks();

      onProgress?.call(0.55, 'Mavzular yuklanmoqda...');
      final topicsCount = await importTopics();

      onProgress?.call(0.75, 'So\'zlar yuklanmoqda...');
      final wordsCount = await importWords(
        onChunkSaved: (count) {
          final progress = (0.75 + (count / 5000) * 0.20).clamp(0.75, 0.95);
          onProgress?.call(progress, '$count ta so\'z saqlandi...');
        },
      );

      print('✅ Import tugadi!');
      onProgress?.call(1.0, 'Ma\'lumotlar tayyor!');

      return {
        'books': booksCount,
        'topics': topicsCount,
        'words': wordsCount,
      };
    } catch (e) {
      print('❌ Import xatosi: $e');
      rethrow;
    }
  }

  // Books import
  Future<int> importBooks() async {
    final url = GoogleSheetsConfig.getBooksUrl();
    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception('Books yuklab bo\'lmadi: ${response.statusCode}');
    }

    final csvData = const Utf8Decoder().convert(response.bodyBytes);
    final rows = const CsvToListConverter().convert(csvData);

    final batch = db.batch();
    int count = 0;

    for (var i = 1; i < rows.length; i++) {
      final row = rows[i];
      if (row.length < 2) continue;

      batch.insert('books', {
        'id': int.parse(row[0].toString()),
        'name': row[1].toString().trim(),
      }, conflictAlgorithm: ConflictAlgorithm.replace);

      count++;
    }

    await batch.commit(noResult: true);
    print('✓ Books: $count ta');
    return count;
  }

  // Topics import
  Future<int> importTopics() async {
    final url = GoogleSheetsConfig.getTopicsUrl();
    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception('Topics yuklab bo\'lmadi: ${response.statusCode}');
    }

    final csvData = const Utf8Decoder().convert(response.bodyBytes);
    final rows = const CsvToListConverter().convert(csvData);

    final batch = db.batch();
    int count = 0;

    for (var i = 1; i < rows.length; i++) {
      final row = rows[i];
      if (row.length < 3) continue;

      batch.insert('topics', {
        'book_id': int.parse(row[0].toString()),
        'topic_id': int.parse(row[1].toString()),
        'topic': row[2].toString().trim(),
      }, conflictAlgorithm: ConflictAlgorithm.replace);

      count++;
    }

    await batch.commit(noResult: true);
    print('✓ Topics: $count ta');
    return count;
  }

  // Words import
  Future<int> importWords({
    void Function(int count)? onChunkSaved,
  }) async {
    final url = GoogleSheetsConfig.getWordsUrl();
    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception('Words yuklab bo\'lmadi: ${response.statusCode}');
    }

    final csvData = const Utf8Decoder().convert(response.bodyBytes);
    final rows = const CsvToListConverter().convert(csvData);

    var batch = db.batch();
    int count = 0;

    for (var i = 1; i < rows.length; i++) {
      final row = rows[i];
      if (row.length < 5) continue;

      batch.insert('words', {
        'book_id': int.parse(row[0].toString()),
        'topic_id': int.parse(row[1].toString()),
        'id': int.parse(row[2].toString()),
        'korean_word': row[3].toString().trim(),
        'uzbek_word': row[4].toString().trim(),
        'desc': row.length > 5 ? row[5].toString().trim() : null,
      }, conflictAlgorithm: ConflictAlgorithm.replace);

      count++;

      if (count % 500 == 0) {
        await batch.commit(noResult: true);
        batch = db.batch();
        print('  → $count ta so\'z...');
        onChunkSaved?.call(count);
      }
    }

    if (count % 500 != 0) {
      await batch.commit(noResult: true);
    }

    onChunkSaved?.call(count);
    print('✓ Words: $count ta');
    return count;
  }

  Future<void> clearAllData() async {
    await db.delete('words');
    await db.delete('topics');
    await db.delete('books');
  }

  Future<bool> isDatabaseEmpty() async {
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM words');
    final count = Sqflite.firstIntValue(result) ?? 0;
    return count == 0;
  }
}
