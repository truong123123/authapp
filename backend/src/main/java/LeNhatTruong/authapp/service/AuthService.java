package LeNhatTruong.authapp.service;

import LeNhatTruong.authapp.dto.request.LoginRequest;
import LeNhatTruong.authapp.dto.request.RegisterRequest;
import LeNhatTruong.authapp.dto.response.AuthResponse;

public interface AuthService {
    void register(RegisterRequest registerRequest);
    AuthResponse login(LoginRequest loginRequest);
    AuthResponse refreshToken(String requestRefreshToken);
    void logout(String email);
}
