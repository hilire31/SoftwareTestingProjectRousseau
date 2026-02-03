package org.example.structural.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;

@Entity
public class Book {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String title;
    private String author;
    private double price;
    private String theme;
    private Long ownerId;
    private boolean forSale;

    // Constructeur sans argument (obligatoire pour JPA)
    public Book() {
    }

    // Constructeur complet
    public Book(Long id, String title, String author, double price) {
        this.id = id;
        this.title = title;
        this.author = author;
        this.price = price;
    }

    public Book(Long id, String title, String author, double price, String theme) {
        this.id = id;
        this.title = title;
        this.author = author;
        this.price = price;
        this.theme = theme;
    }

    public Book(Long id, String title, String author, double price, String theme, Long ownerId, boolean forSale) {
        this.id = id;
        this.title = title;
        this.author = author;
        this.price = price;
        this.theme = theme;
        this.ownerId = ownerId;
        this.forSale = forSale;
    }

    // Méthode métier
    public String getDescription() {
        return title + " by " + author;
    }

    // Getters & setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

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

    public Long getOwnerId() {
        return ownerId;
    }

    public void setOwnerId(Long ownerId) {
        this.ownerId = ownerId;
    }

    public boolean isForSale() {
        return forSale;
    }

    public void setForSale(boolean forSale) {
        this.forSale = forSale;
    }
}
