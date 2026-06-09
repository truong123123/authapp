package com.example.authapp.service;

import com.example.authapp.entity.User;

public interface AuthService {
    void register(User registerRequest);
    User login(User loginRequest);
    User refreshToken(String requestRefreshToken);
    void logout(String email);
}
