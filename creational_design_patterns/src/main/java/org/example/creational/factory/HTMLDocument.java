package org.example.creational.factory;

public class HTMLDocument implements Document {
    @Override
    public void open() {
        System.out.println("Opening HTML document");
    }

    @Override
    public void display() {
        System.out.println("Rendering HTML in web view");
    }

    @Override
    public void save(String content) {
        // Simulate HTML-specific save (e.g., ensure valid markup)
        System.out.println("Saving HTML content: " + content);
    }
}