package org.example.structural.service;


import org.example.structural.entity.Book;
import org.springframework.stereotype.Component;
import java.util.List;

@Component
public class LibraryFacade {

    private final BookService bookService;

    public LibraryFacade(BookService bookService) {
        this.bookService = bookService;
    }

    // Use BookService to simplify interactions
    public void addBook(Book book) {
        bookService.addBook(book);
    }

    public List<Book> getFeaturedBooks() {
        // Return the top 3 most expensive books as 'featured'
        return bookService.getAllBooks()
                .stream()
                .sorted((b1, b2) -> Double.compare(b2.getPrice(), b1.getPrice()))
                .limit(3)
                .toList();
    }

    // Return decorators for featured books (example usage of Decorator pattern)
    public List<FeaturedBookDecorator> getFeaturedBookDecorators() {
        return getFeaturedBooks().stream()
                .map(FeaturedBookDecorator::new)
                .toList();
    }
}
