package org.example.creational;

import org.example.creational.factory.Document;
import org.example.creational.factory.DocumentFactory;

public class DocumentEditor {
    public void openDocument(String type, String content) {
        Document doc = DocumentFactory.createDocument(type);
        doc.open();
        doc.display();
        doc.save(content);
    }

    public static void main(String[] args) {
        DocumentEditor editor = new DocumentEditor();

        // Test opening, displaying and saving different document types
        editor.openDocument("PDF", "PDF: Invoice1");
        editor.openDocument("Word", "Word: Meeting notes");
        editor.openDocument("HTML", "<h1>Hello World</h1>");
    }
}
