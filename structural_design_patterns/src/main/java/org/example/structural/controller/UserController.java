package org.example.structural.controller;

import org.example.structural.dto.UserDto;
import org.example.structural.entity.User;
import org.example.structural.service.UserService;
import org.example.structural.utils.UserMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/users")
public class UserController {

    private final UserService userService;

    @Autowired
    public UserController(UserService userService) {
        this.userService = userService;
    }

    @PostMapping("/signup")
    public UserDto signup(@RequestBody UserDto request) {
        User user = UserMapper.toEntity(request);
        User saved = userService.signup(user);
        return UserMapper.toDTO(saved);
    }

    @PostMapping("/login")
    public UserDto login(@RequestBody UserDto request) {
        User user = userService.login(request.getEmail(), request.getPassword());
        return UserMapper.toDTO(user);
    }
}
