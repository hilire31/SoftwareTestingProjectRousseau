package org.example.creational.factory;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

public class DocumentFactoryTest {

    @Test
    public void testCreatePDFDocument() {
        Document doc = DocumentFactory.createDocument("PDF");
        assertNotNull(doc);
        assertEquals(PDFDocument.class, doc.getClass());
        assertDoesNotThrow(() -> {
            doc.open();
            doc.display();
            doc.save("Test PDF content");
        });
    }

    @Test
    public void testCreateWordDocument() {
        Document doc = DocumentFactory.createDocument("Word");
        assertNotNull(doc);
        assertEquals(WordDocument.class, doc.getClass());
        assertDoesNotThrow(() -> {
            doc.open();
            doc.display();
            doc.save("Test Word content");
        });
    }

    @Test
    public void testCreateHTMLDocument() {
        Document doc = DocumentFactory.createDocument("HTML");
        assertNotNull(doc);
        assertEquals(HTMLDocument.class, doc.getClass());
        assertDoesNotThrow(() -> {
            doc.open();
            doc.display();
            doc.save("<p>Test HTML</p>");
        });
    }

    @Test
    public void testUnknownTypeThrows() {
        assertThrows(IllegalArgumentException.class, () -> DocumentFactory.createDocument("TXT"));
    }
}
