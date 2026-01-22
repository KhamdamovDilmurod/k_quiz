class Book {
  final int id;
  final String name;

  Book({required this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'] ?? map['book_id'],
      name: map['name'] ?? map['book_name'],
    );
  }
}