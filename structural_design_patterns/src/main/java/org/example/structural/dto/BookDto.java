package org.example.structural.dto;

import lombok.Data;

@Data
public class BookDto {
    private String title;
    private String author;
    private double price;
    private String theme;

    // Explicit getters and setters to avoid relying on Lombok at build time
    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getTheme() {
        return theme;
    }

    public void setTheme(String theme) {
        this.theme = theme;
    }
}
