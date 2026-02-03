// lib/features/books/data/services/book_api_service.dart

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/book_dto.dart';

class BookApiService {
  String get baseUrl {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      return "http://localhost:8080/api/books";
    }
    return "http://10.0.2.2:8080/api/books";
  }

  Future<List<BookDto>> getAllBooks() async {
    final res = await http.get(Uri.parse(baseUrl));
    return _decodeList(res);
  }

  Future<BookDto> getBookById(int id) async {
    final res = await http.get(Uri.parse("$baseUrl/$id"));
    return BookDto.fromJson(jsonDecode(res.body));
  }

  Future<List<BookDto>> getBooksByTheme(String theme) async {
    final res = await http.get(Uri.parse("$baseUrl/theme/$theme"));
    return _decodeList(res);
  }

  Future<List<BookDto>> getBooksByAuthor(String author) async {
    final res = await http.get(Uri.parse("$baseUrl/author/$author"));
    return _decodeList(res);
  }

  Future<BookDto> addBook(BookDto book) async {
    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(book.toJson()),
    );
    return BookDto.fromJson(jsonDecode(res.body));
  }

  Future<BookDto> updateBook(int id, BookDto book) async {
    final res = await http.put(
      Uri.parse("$baseUrl/$id"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(book.toJson()),
    );
    return BookDto.fromJson(jsonDecode(res.body));
  }

  Future<void> deleteBook(int id) async {
    final res = await http.delete(Uri.parse("$baseUrl/$id"));
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Delete failed: ${res.statusCode}');
    }
  }

  Future<List<BookDto>> getBooksForSale(int excludeOwnerId) async {
    final res = await http.get(
      Uri.parse("$baseUrl/for-sale?excludeOwnerId=$excludeOwnerId"),
    );
    return _decodeList(res);
  }

  Future<BookDto> sellBook(int id, int ownerId) async {
    final res = await http.put(
      Uri.parse("$baseUrl/$id/sell"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'ownerId': ownerId, 'forSale': true}),
    );
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Sell failed: ${res.statusCode}');
    }
    return BookDto.fromJson(jsonDecode(res.body));
  }

  Future<BookDto> buyBook(int id, int buyerId) async {
    final res = await http.post(
      Uri.parse("$baseUrl/$id/buy"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'buyerId': buyerId}),
    );
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Buy failed: ${res.statusCode}');
    }
    return BookDto.fromJson(jsonDecode(res.body));
  }

  List<BookDto> _decodeList(http.Response res) {
    final List data = jsonDecode(res.body);
    return data.map((e) => BookDto.fromJson(e)).toList();
  }
}
