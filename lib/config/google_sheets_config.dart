class GoogleSheetsConfig {
  // Sheet1 = books
  static const String booksUrl =
      'https://docs.google.com/spreadsheets/d/e/2PACX-1vSHvtHOLmlvbzqYIHHWtlYmWflrZO652kH5Kkme65sFO2WTp5pQ2aZ8REJVwmumqNNTF2Fm27xZgFqZ/pub?gid=0&single=true&output=csv';

  // Sheet2 = topics
  static const String topicsUrl =
      'https://docs.google.com/spreadsheets/d/e/2PACX-1vSHvtHOLmlvbzqYIHHWtlYmWflrZO652kH5Kkme65sFO2WTp5pQ2aZ8REJVwmumqNNTF2Fm27xZgFqZ/pub?gid=1226174516&single=true&output=csv';

  // Sheet3 = words
  static const String wordsUrl =
      'https://docs.google.com/spreadsheets/d/e/2PACX-1vSHvtHOLmlvbzqYIHHWtlYmWflrZO652kH5Kkme65sFO2WTp5pQ2aZ8REJVwmumqNNTF2Fm27xZgFqZ/pub?gid=2053415014&single=true&output=csv';

  static String getBooksUrl() => booksUrl;

  static String getTopicsUrl() => topicsUrl;

  static String getWordsUrl() => wordsUrl;
}
