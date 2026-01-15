package org.example.creational.factory;

import java.util.HashMap;
import java.util.Map;
import java.util.function.Supplier;

public class DocumentFactory {

    private static final Map<String, Supplier<Document>> registry = new HashMap<>();

    // Register built-in document types
    static {
        register("PDF", PDFDocument::new);
        register("Word", WordDocument::new);
        register("HTML", HTMLDocument::new);
    }

    // Allow external registration so new formats can be added without changing this code
    public static void register(String type, Supplier<Document> supplier) {
        registry.put(type, supplier);
    }

    public static Document createDocument(String type) {
        Supplier<Document> supplier = registry.get(type);
        if (supplier == null) {
            throw new IllegalArgumentException("Unknown document type: " + type);
        }
        return supplier.get();
    }
}
