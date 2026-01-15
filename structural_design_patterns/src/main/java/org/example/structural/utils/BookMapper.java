package org.example.structural.utils;


import org.example.structural.dto.BookDto;
import org.example.structural.entity.Book;

public class BookMapper {

    // Convert Book entity to BookDto
    public static BookDto toDTO(Book book) {
        BookDto dto = new BookDto();
        dto.setTitle(book.getTitle());
        dto.setAuthor(book.getAuthor());
        dto.setPrice(book.getPrice());
        dto.setTheme(book.getTheme());
        return dto;
    }

    // Convert BookDto to Book entity
    public static Book toEntity(BookDto dto) {
        Book book = new Book();
        book.setTitle(dto.getTitle());
        book.setAuthor(dto.getAuthor());
        book.setPrice(dto.getPrice());
        book.setTheme(dto.getTheme());
        return book;
    }
}

