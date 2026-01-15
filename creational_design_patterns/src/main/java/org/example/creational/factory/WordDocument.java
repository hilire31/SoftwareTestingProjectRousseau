package org.example.creational.factory;

public class WordDocument implements Document {
    @Override
    public void open() {
        System.out.println("Opening Word document (.docx)");
    }

    @Override
    public void display() {
        System.out.println("Rendering Word content with Word renderer");
    }

    @Override
    public void save(String content) {
        // Simulate Word-specific save (e.g., preserve styles)
        System.out.println("Saving Word content: " + content);
    }
}