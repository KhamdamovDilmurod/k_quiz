import 'package:sqflite/sqflite.dart';

import '../models/book.dart';
import '../models/topic.dart';
import '../models/word.dart';

class WordRepository {
  final Database db;

  WordRepository(this.db);

  Future<List<Book>> getAllBooks() async {
    final result = await db.query('books', orderBy: 'id');
    return result.map((map) => Book.fromMap(map)).toList();
  }

  Future<List<Topic>> getTopicsByBook(int bookId) async {
    final result = await db.query(
      'topics',
      where: 'book_id = ?',
      whereArgs: [bookId],
      orderBy: 'topic_id',
    );
    return result.map((map) => Topic.fromMap(map)).toList();
  }

  Future<List<Word>> getWordsByTopic(int topicId) async {
    final result = await db.query(
      'words',
      where: 'topic_id = ?',
      whereArgs: [topicId],
      orderBy: 'id',
    );
    return result.map((map) => Word.fromMap(map)).toList();
  }

  Future<List<Word>> getRandomWords(int topicId, int count) async {
    final result = await db.query(
      'words',
      where: 'topic_id = ?',
      whereArgs: [topicId],
      orderBy: 'RANDOM()',
      limit: count,
    );
    return result.map((map) => Word.fromMap(map)).toList();
  }

  Future<Map<String, int>> getDataCount() async {
    final booksCount = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM books')
    ) ?? 0;

    final topicsCount = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM topics')
    ) ?? 0;

    final wordsCount = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM words')
    ) ?? 0;

    final savedWordsCount = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM saved_words')
    ) ?? 0;

    return {
      'books': booksCount,
      'topics': topicsCount,
      'words': wordsCount,
      'saved': savedWordsCount,
    };
  }

  // ============ SAVED WORDS FUNKSIYALARI ============

  /// So'zni saqlanganlarga qo'shish
  Future<bool> addToSaved(int wordId) async {
    try {
      await db.insert(
        'saved_words',
        {
          'word_id': wordId,
          'saved_at': DateTime.now().millisecondsSinceEpoch,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return true;
    } catch (e) {
      print('Error adding to saved: $e');
      return false;
    }
  }

  /// Saqlangan so'zlar ro'yxatini olish (to'liq ma'lumot bilan)
  Future<List<Word>> getSavedWords() async {
    try {
      final result = await db.rawQuery('''
        SELECT 
          w.id,
          w.book_id,
          w.topic_id,
          w.korean_word,
          w.uzbek_word,
          w.desc
        FROM saved_words s
        INNER JOIN words w ON s.word_id = w.id
        ORDER BY s.saved_at DESC
      ''');

      return result.map((map) => Word.fromMap(map)).toList();
    } catch (e) {
      print('Error getting saved words: $e');
      return [];
    }
  }

  /// Saqlangan so'zlar ro'yxatini olish (qo'shimcha ma'lumot bilan)
  Future<List<Map<String, dynamic>>> getSavedWordsWithDetails() async {
    try {
      final result = await db.rawQuery('''
        SELECT 
          w.id,
          w.book_id,
          w.topic_id,
          w.korean_word,
          w.uzbek_word,
          w.desc,
          s.saved_at,
          b.name as book_name,
          t.topic as topic_name
        FROM saved_words s
        INNER JOIN words w ON s.word_id = w.id
        LEFT JOIN books b ON w.book_id = b.id
        LEFT JOIN topics t ON w.topic_id = t.topic_id
        ORDER BY s.saved_at DESC
      ''');

      return result;
    } catch (e) {
      print('Error getting saved words with details: $e');
      return [];
    }
  }

  /// Saqlangan so'zlar sonini olish
  Future<int> getSavedWordsCount() async {
    try {
      final result = await db.rawQuery('SELECT COUNT(*) as count FROM saved_words');
      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e) {
      print('Error getting saved count: $e');
      return 0;
    }
  }

  /// So'z saqlangan yoki yo'qligini tekshirish
  Future<bool> isWordSaved(int wordId) async {
    try {
      final result = await db.query(
        'saved_words',
        where: 'word_id = ?',
        whereArgs: [wordId],
      );
      return result.isNotEmpty;
    } catch (e) {
      print('Error checking saved status: $e');
      return false;
    }
  }

  /// Bitta so'zni saqlananlardan o'chirish
  Future<bool> removeFromSaved(int wordId) async {
    try {
      final count = await db.delete(
        'saved_words',
        where: 'word_id = ?',
        whereArgs: [wordId],
      );
      return count > 0;
    } catch (e) {
      print('Error removing from saved: $e');
      return false;
    }
  }

  /// Barcha saqlangan so'zlarni o'chirish
  Future<bool> clearSavedWords() async {
    try {
      await db.delete('saved_words');
      return true;
    } catch (e) {
      print('Error clearing saved words: $e');
      return false;
    }
  }

  /// Toggle - agar saqlangan bo'lsa o'chiradi, aks holda qo'shadi
  Future<bool> toggleSaved(int wordId) async {
    final isSaved = await isWordSaved(wordId);
    if (isSaved) {
      return await removeFromSaved(wordId);
    } else {
      return await addToSaved(wordId);
    }
  }

  /// Saqlangan so'zlardan random so'zlar olish (test uchun)
  Future<List<Word>> getRandomSavedWords(int count) async {
    try {
      final result = await db.rawQuery('''
        SELECT 
          w.id,
          w.book_id,
          w.topic_id,
          w.korean_word,
          w.uzbek_word,
          w.desc
        FROM saved_words s
        INNER JOIN words w ON s.word_id = w.id
        ORDER BY RANDOM()
        LIMIT ?
      ''', [count]);

      return result.map((map) => Word.fromMap(map)).toList();
    } catch (e) {
      print('Error getting random saved words: $e');
      return [];
    }
  }
}