package org.example.structural.utils;

import org.example.structural.dto.BookDto;
import org.example.structural.entity.Book;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

public class BookMapperTest {

    @Test
    public void dtoToEntityAndBack() {
        BookDto dto = new BookDto();
        dto.setTitle("Test Title");
        dto.setAuthor("Author");
        dto.setPrice(12.5);

        Book book = BookMapper.toEntity(dto);
        assertEquals("Test Title", book.getTitle());

        BookDto dto2 = BookMapper.toDTO(book);
        assertEquals(dto.getTitle(), dto2.getTitle());
        assertEquals(dto.getAuthor(), dto2.getAuthor());
        assertEquals(dto.getPrice(), dto2.getPrice());
    }
}