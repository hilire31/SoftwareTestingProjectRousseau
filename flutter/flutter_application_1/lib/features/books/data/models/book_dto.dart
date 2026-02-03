// lib/features/books/data/models/book_dto.dart

class BookDto {
  final int? id;
  final String title;
  final String author;
  final String theme;
  final double price;

  BookDto({
    this.id,
    required this.title,
    required this.author,
    required this.theme,
    required this.price,
  });

  factory BookDto.fromJson(Map<String, dynamic> json) {
    return BookDto(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      theme: json['theme'],
      price: json['price'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'theme': theme,
      'price': price,
    };
  }
}
