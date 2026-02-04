// lib/features/books/presentation/pages/buy_books_page.dart

import 'package:flutter/material.dart';
import '../../data/models/book_dto.dart';
import '../../data/services/book_api_service.dart';
import '../../../../core/session/app_session.dart';
import '../../../auth/presentation/pages/auth_page.dart';

class BuyBooksPage extends StatefulWidget {
  const BuyBooksPage({super.key});

  @override
  State<BuyBooksPage> createState() => _BuyBooksPageState();
}

class _BuyBooksPageState extends State<BuyBooksPage> {
  final BookApiService _service = BookApiService();
  late Future<List<BookDto>> _future;
  late final TextEditingController _searchController;
  String _query = '';
  String _selectedTheme = 'All';

  @override
  void initState() {
    super.initState();
    _future = _load();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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

  List<BookDto> _applySearch(List<BookDto> books) {
    if (_query.trim().isEmpty) return books;
    final q = _query.toLowerCase();
    return books
        .where((b) =>
            b.title.toLowerCase().contains(q) ||
            b.author.toLowerCase().contains(q))
        .toList(growable: false);
  }

  List<BookDto> _applyFilters(List<BookDto> books) {
    var filtered = books;
    if (_selectedTheme != 'All') {
      filtered =
          filtered.where((b) => b.theme == _selectedTheme).toList(growable: false);
    }
    filtered = _applySearch(filtered);
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final userId = AppSession.currentUserId;
    if (userId == null) {
      return const Center(child: Text('Please login to buy books.'));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buy Books'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              AppSession.currentUserId = null;
              AppSession.currentEmail = null;
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const AuthPage()),
                (route) => false,
              );
            },
            tooltip: 'Logout',
          ),
        ],
      ),
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
          final themes = <String>{
            'All',
            ...books.map((b) => b.theme),
          }.toList(growable: false);
          final filtered = _applyFilters(books);
          if (books.isEmpty) {
            return _EmptyState(onRetry: _refresh);
          }
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _query = value),
                  decoration: InputDecoration(
                    hintText: 'Search by title or author',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _ThemeChips(
                  themes: themes,
                  selected: _selectedTheme,
                  onSelected: (value) =>
                      setState(() => _selectedTheme = value),
                ),
                const SizedBox(height: 12),
                if (filtered.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: Text('No matching books.')),
                  )
                else
                  ...filtered.map(
                    (book) => Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text(book.title),
                        subtitle: Text('${book.author} - ${book.theme}'),
                        trailing: ElevatedButton(
                          onPressed: () => _buy(book),
                          child: const Text('Buy'),
                        ),
                        leading: CircleAvatar(
                          backgroundColor:
                              Theme.of(context).colorScheme.primaryContainer,
                          child: Text(
                            book.price.toStringAsFixed(2),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ThemeChips extends StatelessWidget {
  const _ThemeChips({
    required this.themes,
    required this.selected,
    required this.onSelected,
  });

  final List<String> themes;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: themes.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final theme = themes[index];
          final isSelected = theme == selected;
          return ChoiceChip(
            label: Text(theme),
            selected: isSelected,
            onSelected: (_) => onSelected(theme),
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
