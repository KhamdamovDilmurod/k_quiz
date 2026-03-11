import 'package:sqflite/sqflite.dart';

class StudyProgressRepository {
  final Database db;

  StudyProgressRepository(this.db);

  Future<void> saveStudyResult({
    required int bookId,
    required int topicId,
    required String mode,
    required int score,
    required int total,
    required double percentage,
    required int durationSec,
  }) async {
    await db.insert(
      'study_results',
      {
        'book_id': bookId,
        'topic_id': topicId,
        'mode': mode,
        'score': score,
        'total': total,
        'percentage': percentage,
        'duration_sec': durationSec,
        'completed_at': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  Future<Map<String, dynamic>> getSummary() async {
    final result = await db.rawQuery('''
      SELECT
        COUNT(*) as total_sessions,
        COALESCE(AVG(percentage), 0) as avg_percentage,
        COALESCE(MAX(percentage), 0) as best_percentage,
        COALESCE(SUM(duration_sec), 0) as total_duration_sec
      FROM study_results
    ''');

    final row = result.first;
    return {
      'total_sessions': row['total_sessions'] ?? 0,
      'avg_percentage': _toDouble(row['avg_percentage']),
      'best_percentage': _toDouble(row['best_percentage']),
      'total_duration_sec': row['total_duration_sec'] ?? 0,
    };
  }

  Future<List<Map<String, dynamic>>> getModeStatistics() async {
    final result = await db.rawQuery('''
      SELECT
        mode,
        COUNT(*) as sessions_count,
        COALESCE(AVG(percentage), 0) as avg_percentage,
        COALESCE(MAX(percentage), 0) as best_percentage,
        COALESCE(AVG(duration_sec), 0) as avg_duration_sec
      FROM study_results
      GROUP BY mode
      ORDER BY sessions_count DESC, mode ASC
    ''');

    return result
        .map(
          (item) => {
            ...item,
            'avg_percentage': _toDouble(item['avg_percentage']),
            'best_percentage': _toDouble(item['best_percentage']),
            'avg_duration_sec': _toDouble(item['avg_duration_sec']),
          },
        )
        .toList();
  }

  Future<List<Map<String, dynamic>>> getRecentResults({int limit = 20}) async {
    final result = await db.rawQuery('''
      SELECT
        sr.id,
        sr.book_id,
        sr.topic_id,
        sr.mode,
        sr.score,
        sr.total,
        sr.percentage,
        sr.duration_sec,
        sr.completed_at,
        b.name as book_name,
        t.topic as topic_name
      FROM study_results sr
      LEFT JOIN books b ON sr.book_id = b.id
      LEFT JOIN topics t ON sr.topic_id = t.topic_id
      ORDER BY sr.completed_at DESC
      LIMIT ?
    ''', [limit]);

    return result
        .map(
          (item) => {
            ...item,
            'percentage': _toDouble(item['percentage']),
          },
        )
        .toList();
  }

  double _toDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
    }
}
