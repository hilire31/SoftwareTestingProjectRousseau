package org.example.creational.factory;

public interface Document {
    // Open or load the document (format-specific)
    void open();

    // Display the document to the user (format-specific rendering)
    void display();

    // Save the document content to storage (format-specific)
    void save(String content);
}
