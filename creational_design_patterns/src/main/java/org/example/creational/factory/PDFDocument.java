package org.example.creational.factory;

public class PDFDocument implements Document {
    @Override
    public void open() {
        System.out.println("Opening PDF document");
    }

    @Override
    public void display() {
        System.out.println("Rendering PDF content using PDF renderer");
    }

    @Override
    public void save(String content) {
        // Simulate PDF-specific save (e.g., embed fonts, compress)
        System.out.println("Saving PDF content: " + content);
    }
}
