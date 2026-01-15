package org.example.structural.service;

import org.example.structural.entity.Book;
import org.example.structural.repository.BookRepository;
import org.example.structural.exceptions.ResourceNotFoundException;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

public class BookServiceTest {

    @Test
    public void getBookById_returnsBook() {
        BookRepository repo = Mockito.mock(BookRepository.class);
        Book book = new Book(1L, "T", "A", 10.0);
        when(repo.findById(1L)).thenReturn(Optional.of(book));

        BookService svc = new BookService(repo);

        Book found = svc.getBookById(1L);
        assertEquals("T", found.getTitle());
    }

    @Test
    public void getBookById_notFoundThrows() {
        BookRepository repo = Mockito.mock(BookRepository.class);
        when(repo.findById(99L)).thenReturn(Optional.empty());

        BookService svc = new BookService(repo);

        assertThrows(ResourceNotFoundException.class, () -> svc.getBookById(99L));
    }

    @Test
    public void addBook_callsSave() {
        BookRepository repo = Mockito.mock(BookRepository.class);
        Book book = new Book(null, "T", "A", 10.0);
        when(repo.save(any(Book.class))).thenReturn(book);

        BookService svc = new BookService(repo);

        @SuppressWarnings("unused")
        Book saved = svc.addBook(book);
        verify(repo).save(book);
    }
}