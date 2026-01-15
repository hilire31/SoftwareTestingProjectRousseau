package org.example.structural.repository;


import org.example.structural.entity.Book;
import org.springframework.data.jpa.repository.JpaRepository;

public interface BookRepository extends JpaRepository<Book, Long> {
    // Additional query methods can be defined here if needed
    java.util.List<Book> findByTheme(String theme);
    java.util.List<Book> findByAuthor(String author);
}
