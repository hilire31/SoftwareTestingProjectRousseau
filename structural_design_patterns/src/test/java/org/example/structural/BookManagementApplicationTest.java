package org.example.structural;

import org.example.structural.controller.LibraryController;
import org.example.structural.service.BookService;
import org.example.structural.service.LibraryFacade;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.context.ApplicationContext;

import static org.junit.jupiter.api.Assertions.assertNotNull;

@SpringBootTest
public class BookManagementApplicationTest {

    @Autowired
    private ApplicationContext ctx;

    @Test
    public void contextLoadsAndWiresBeans() {
        assertNotNull(ctx);
        assertNotNull(ctx.getBean(BookService.class));
        assertNotNull(ctx.getBean(LibraryFacade.class));
        assertNotNull(ctx.getBean(LibraryController.class));
    }
}
