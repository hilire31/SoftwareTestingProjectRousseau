package org.example.creational.factory;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

public class DocumentFactoryTest {

    @Test
    public void createPdfDocument() {
        Document d = DocumentFactory.createDocument("PDF");
        assertNotNull(d);
        assertTrue(d instanceof PDFDocument);
    }

    @Test
    public void createWordDocument() {
        Document d = DocumentFactory.createDocument("Word");
        assertNotNull(d);
        assertTrue(d instanceof WordDocument);
    }

    @Test
    public void createHtmlDocument() {
        Document d = DocumentFactory.createDocument("HTML");
        assertNotNull(d);
        assertTrue(d instanceof HTMLDocument);
    }

    @Test
    public void createUnknownThrows() {
        assertThrows(IllegalArgumentException.class, () -> DocumentFactory.createDocument("TXT"));
    }
}