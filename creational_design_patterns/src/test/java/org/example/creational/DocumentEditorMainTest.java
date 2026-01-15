package org.example.creational;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertDoesNotThrow;

public class DocumentEditorMainTest {

    @Test
    public void mainRunsWithoutException() {
        assertDoesNotThrow(() -> DocumentEditor.main(new String[0]));
    }
}
