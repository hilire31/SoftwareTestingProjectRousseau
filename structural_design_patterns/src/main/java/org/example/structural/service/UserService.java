package org.example.structural.service;

import org.example.structural.entity.User;
import org.example.structural.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public UserService() {
    }

    public User signup(User user) {
        return userRepository.save(user);
    }

    public User login(String email, String password) {
        List<User> matches = userRepository.findByEmailAndPassword(email, password);
        if (matches.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Invalid credentials");
        }
        return matches.get(0);
    }
}
