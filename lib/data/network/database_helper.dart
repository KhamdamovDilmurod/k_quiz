import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('korean_quiz.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future _createDB(Database db, int version) async {
    // Books jadvali
    await db.execute('''
      CREATE TABLE books (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL
      )
    ''');

    // Topics jadvali
    await db.execute('''
      CREATE TABLE topics (
        book_id INTEGER NOT NULL,
        topic_id INTEGER PRIMARY KEY,
        topic TEXT NOT NULL,
        FOREIGN KEY (book_id) REFERENCES books (id)
      )
    ''');

    // Words jadvali
    await db.execute('''
      CREATE TABLE words (
        book_id INTEGER NOT NULL,
        topic_id INTEGER NOT NULL,
        id INTEGER PRIMARY KEY,
        korean_word TEXT NOT NULL,
        uzbek_word TEXT NOT NULL,
        desc TEXT,
        FOREIGN KEY (book_id) REFERENCES books (id),
        FOREIGN KEY (topic_id) REFERENCES topics (topic_id)
      )
    ''');

    // Saved Words jadvali
    await db.execute('''
      CREATE TABLE saved_words (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        word_id INTEGER NOT NULL,
        saved_at INTEGER NOT NULL,
        FOREIGN KEY (word_id) REFERENCES words (id),
        UNIQUE(word_id)
      )
    ''');

    // Indekslar
    await db.execute('CREATE INDEX idx_topic_book ON topics(book_id)');
    await db.execute('CREATE INDEX idx_word_topic ON words(topic_id)');
    await db.execute('CREATE INDEX idx_word_book ON words(book_id)');
    await db.execute('CREATE INDEX idx_saved_word ON saved_words(word_id)');
    await db.execute('CREATE INDEX idx_saved_date ON saved_words(saved_at)');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE saved_words (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          word_id INTEGER NOT NULL,
          saved_at INTEGER NOT NULL,
          FOREIGN KEY (word_id) REFERENCES words (id),
          UNIQUE(word_id)
        )
      ''');
      await db.execute('CREATE INDEX idx_saved_word ON saved_words(word_id)');
      await db.execute('CREATE INDEX idx_saved_date ON saved_words(saved_at)');
    }
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}

// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
//
// class DatabaseHelper {
//   static final DatabaseHelper instance = DatabaseHelper._init();
//   static Database? _database;
//
//   DatabaseHelper._init();
//
//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDB('korean_quiz.db');
//     return _database!;
//   }
//
//   Future<Database> _initDB(String filePath) async {
//     final dbPath = await getDatabasesPath();
//     final path = join(dbPath, filePath);
//
//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: _createDB,
//     );
//   }
//
//   Future _createDB(Database db, int version) async {
//     // Books jadvali
//     await db.execute('''
//       CREATE TABLE books (
//         id INTEGER PRIMARY KEY,
//         name TEXT NOT NULL
//       )
//     ''');
//
//     // Topics jadvali
//     await db.execute('''
//       CREATE TABLE topics (
//         book_id INTEGER NOT NULL,
//         topic_id INTEGER PRIMARY KEY,
//         topic TEXT NOT NULL,
//         FOREIGN KEY (book_id) REFERENCES books (id)
//       )
//     ''');
//
//     // Words jadvali
//     await db.execute('''
//       CREATE TABLE words (
//         book_id INTEGER NOT NULL,
//         topic_id INTEGER NOT NULL,
//         id INTEGER PRIMARY KEY,
//         korean_word TEXT NOT NULL,
//         uzbek_word TEXT NOT NULL,
//         desc TEXT,
//         FOREIGN KEY (book_id) REFERENCES books (id),
//         FOREIGN KEY (topic_id) REFERENCES topics (topic_id)
//       )
//     ''');
//
//     // Indekslar
//     await db.execute('CREATE INDEX idx_topic_book ON topics(book_id)');
//     await db.execute('CREATE INDEX idx_word_topic ON words(topic_id)');
//     await db.execute('CREATE INDEX idx_word_book ON words(book_id)');
//   }
//
//   Future<void> close() async {
//     final db = await instance.database;
//     db.close();
//   }
// }