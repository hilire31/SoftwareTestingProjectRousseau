package org.example.structural.service;


import org.example.structural.entity.Book;
import org.example.structural.repository.BookRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@Service
public class BookService {

    @Autowired
    private BookRepository bookRepository;

    // Constructor for easier testing and explicit wiring
    public BookService(BookRepository bookRepository) {
        this.bookRepository = bookRepository;
    }

    // Default constructor for frameworks
    public BookService() {
    }

    // CRUD operations

    public List<Book> getAllBooks() {
        return bookRepository.findAll();
    }

    public List<Book> getBooksByTheme(String theme) {
        return bookRepository.findByTheme(theme);
    }

    public List<Book> getBooksByAuthor(String author) {
        return bookRepository.findByAuthor(author);
    }

    public Book getBookById(Long id) {
        return bookRepository.findById(id)
                .orElseThrow(() -> new org.example.structural.exceptions.ResourceNotFoundException("Book not found with id: " + id));
    }

    public Book addBook(Book book) {
        return bookRepository.save(book);
    }

    public Book updateBook(Long id, Book updated) {
        Book existing = getBookById(id);
        existing.setTitle(updated.getTitle());
        existing.setAuthor(updated.getAuthor());
        existing.setPrice(updated.getPrice());
        existing.setTheme(updated.getTheme());
        existing.setOwnerId(updated.getOwnerId());
        existing.setForSale(updated.isForSale());
        return bookRepository.save(existing);
    }

    public void deleteBook(Long id) {
        Book existing = getBookById(id);
        bookRepository.delete(existing);
    }

    public List<Book> getBooksForSaleExcludingOwner(Long ownerId) {
        return bookRepository.findByForSaleTrueAndOwnerIdNot(ownerId);
    }

    public Book setForSale(Long bookId, Long ownerId) {
        Book existing = getBookById(bookId);
        if (existing.getOwnerId() == null || !existing.getOwnerId().equals(ownerId)) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Not the owner of this book");
        }
        existing.setForSale(true);
        return bookRepository.save(existing);
    }

    public Book buyBook(Long bookId, Long buyerId) {
        Book existing = getBookById(bookId);
        if (!existing.isForSale()) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Book is not for sale");
        }
        existing.setOwnerId(buyerId);
        existing.setForSale(false);
        return bookRepository.save(existing);
    }
}
