// lib/features/home/presentation/pages/home_page.dart

import 'package:flutter/material.dart';
import '../../../books/presentation/pages/book_list_page.dart';
import '../../../books/presentation/pages/buy_books_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const BookListPage(),
      const BuyBooksPage(),
    ];

    return Scaffold(
      body: pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (value) => setState(() => _index = value),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'My Books',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Buy',
          ),
        ],
      ),
    );
  }
}
