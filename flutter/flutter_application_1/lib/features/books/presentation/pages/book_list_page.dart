// lib/features/books/presentation/pages/book_list_page.dart

import 'package:flutter/material.dart';
import '../../data/models/book_dto.dart';
import '../../data/services/book_api_service.dart';
import 'book_form_page.dart';

class BookListPage extends StatefulWidget {
  const BookListPage({super.key});

  @override
  State<BookListPage> createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  final BookApiService _service = BookApiService();
  late Future<List<BookDto>> _future;
  late final TextEditingController _searchController;
  String _query = '';
  String _selectedTheme = 'All';

  @override
  void initState() {
    super.initState();
    _future = _service.getAllBooks();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    setState(() {
      _future = _service.getAllBooks();
    });
    await _future;
  }

  Future<void> _confirmDelete(BuildContext context, BookDto book) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete book'),
          content: Text('Delete "${book.title}" by ${book.author}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      await _deleteBook(book);
    }
  }

  Future<void> _deleteBook(BookDto book) async {
    if (book.id == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot delete: missing book id.')),
      );
      return;
    }
    try {
      await _service.deleteBook(book.id!);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Book deleted.')),
      );
      _refresh();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete book.')),
      );
    }
  }

  List<BookDto> _applyFilters(List<BookDto> books) {
    var filtered = books;
    if (_selectedTheme != 'All') {
      filtered =
          filtered.where((b) => b.theme == _selectedTheme).toList(growable: false);
    }
    if (_query.trim().isNotEmpty) {
      final q = _query.toLowerCase();
      filtered = filtered
          .where((b) =>
              b.title.toLowerCase().contains(q) ||
              b.author.toLowerCase().contains(q))
          .toList(growable: false);
    }
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refresh,
            tooltip: 'Refresh',
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
            return _ErrorState(
              message: 'Failed to load books.',
              onRetry: _refresh,
            );
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
                _SearchBar(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _query = value),
                ),
                const SizedBox(height: 12),
                _ThemeChips(
                  themes: themes,
                  selected: _selectedTheme,
                  onSelected: (value) =>
                      setState(() => _selectedTheme = value),
                ),
                const SizedBox(height: 12),
                _SummaryRow(
                  count: filtered.length,
                  total: books.length,
                  accent: theme.colorScheme.primary,
                ),
                const SizedBox(height: 8),
                ...filtered.map(
                  (book) => _BookCard(
                    book: book,
                    onDelete: () => _confirmDelete(context, book),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Add Book'),
        onPressed: () async {
          final added = await Navigator.of(context).push<bool>(
            MaterialPageRoute(builder: (_) => const BookFormPage()),
          );
          if (added == true) {
            _refresh();
          }
        },
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'Search by title or author',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
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

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.count,
    required this.total,
    required this.accent,
  });

  final int count;
  final int total;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Showing $count of $total',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: accent,
          ),
        ),
        const Spacer(),
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.filter_list),
          label: const Text('Filters'),
        ),
      ],
    );
  }
}

class _BookCard extends StatelessWidget {
  const _BookCard({required this.book, required this.onDelete});

  final BookDto book;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          child: const Icon(Icons.menu_book),
        ),
        title: Text(book.title),
        subtitle: Text('${book.author} - ${book.theme}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${book.price.toStringAsFixed(2)} EUR',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: onDelete,
              tooltip: 'Delete',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.tightFor(width: 32, height: 32),
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
        onTap: () {
          // navigation vers details
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
            const Icon(Icons.library_books, size: 64),
            const SizedBox(height: 12),
            const Text(
              'No books yet',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text('Add a book or refresh to try again.'),
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
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
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
            Text(
              message,
              style: const TextStyle(fontSize: 16),
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
