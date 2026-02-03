// lib/features/books/data/models/book_dto.dart

class BookDto {
  final int? id;
  final String title;
  final String author;
  final String theme;
  final double price;
  final int? ownerId;
  final bool forSale;

  BookDto({
    this.id,
    required this.title,
    required this.author,
    required this.theme,
    required this.price,
    this.ownerId,
    this.forSale = false,
  });

  factory BookDto.fromJson(Map<String, dynamic> json) {
    return BookDto(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      theme: json['theme'],
      price: json['price'].toDouble(),
      ownerId: json['ownerId'],
      forSale: json['forSale'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'theme': theme,
      'price': price,
      'ownerId': ownerId,
      'forSale': forSale,
    };
  }
}
