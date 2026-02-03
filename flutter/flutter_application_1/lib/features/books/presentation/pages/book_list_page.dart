// lib/features/books/presentation/pages/book_list_page.dart

import 'package:flutter/material.dart';
import '../../data/services/book_api_service.dart';
import '../../data/models/book_dto.dart';

class BookListPage extends StatelessWidget {
  final service = BookApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Library")),
      body: FutureBuilder<List<BookDto>>(
        future: service.getAllBooks(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final book = snapshot.data![index];
              return ListTile(
                title: Text(book.title),
                subtitle: Text("${book.author} • ${book.theme}"),
                trailing: Text("${book.price} €"),
                onTap: () {
                  // navigation vers détails
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // navigation vers ajout
        },
      ),
    );
  }
}
