// lib/features/books/presentation/pages/buy_books_page.dart

import 'package:flutter/material.dart';
import '../../data/models/book_dto.dart';
import '../../data/services/book_api_service.dart';
import '../../../../core/session/app_session.dart';

class BuyBooksPage extends StatefulWidget {
  const BuyBooksPage({super.key});

  @override
  State<BuyBooksPage> createState() => _BuyBooksPageState();
}

class _BuyBooksPageState extends State<BuyBooksPage> {
  final BookApiService _service = BookApiService();
  late Future<List<BookDto>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<BookDto>> _load() {
    final userId = AppSession.currentUserId;
    if (userId == null) {
      return Future.value(const <BookDto>[]);
    }
    return _service.getBooksForSale(userId);
  }

  Future<void> _refresh() async {
    setState(() {
      _future = _load();
    });
    await _future;
  }

  Future<void> _buy(BookDto book) async {
    final userId = AppSession.currentUserId;
    if (userId == null || book.id == null) return;
    try {
      await _service.buyBook(book.id!, userId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Book purchased.')),
      );
      _refresh();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to buy book.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = AppSession.currentUserId;
    if (userId == null) {
      return const Center(child: Text('Please login to buy books.'));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Buy Books')),
      body: FutureBuilder<List<BookDto>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return _ErrorState(onRetry: _refresh);
          }
          final books = snapshot.data ?? const <BookDto>[];
          if (books.isEmpty) {
            return _EmptyState(onRetry: _refresh);
          }
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(book.title),
                    subtitle: Text('${book.author} - ${book.theme}'),
                    trailing: ElevatedButton(
                      onPressed: () => _buy(book),
                      child: const Text('Buy'),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.shopping_bag, size: 64),
            const SizedBox(height: 12),
            const Text(
              'No books for sale',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text('Check back later.'),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Reload'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 64),
            const SizedBox(height: 12),
            const Text(
              'Failed to load books.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
