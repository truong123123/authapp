package com.example.authapp.service;

import com.example.authapp.entity.User;
import java.util.Optional;

public interface UserService {
    Optional<User> findById(Long id);
    Optional<User> findByEmail(String email);
}
