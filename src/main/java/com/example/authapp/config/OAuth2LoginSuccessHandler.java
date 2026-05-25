package com.example.authapp.config;

import com.example.authapp.entity.RefreshToken;
import com.example.authapp.repository.RefreshTokenRepository;
import com.example.authapp.security.CustomUserDetails;
import com.example.authapp.service.AuthService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Lazy;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler;
import org.springframework.stereotype.Component;
import org.springframework.web.util.UriComponentsBuilder;
import java.io.IOException;
import java.util.List;

@Component
public class OAuth2LoginSuccessHandler extends SimpleUrlAuthenticationSuccessHandler {

    private final JwtService jwtService;
    private final AuthService authService;
    private final RefreshTokenRepository refreshTokenRepository;

    @Value("${app.oauth2.authorizedRedirectUris}")
    private List<String> authorizedRedirectUris;

    public OAuth2LoginSuccessHandler(
            JwtService jwtService,
            @Lazy AuthService authService,
            RefreshTokenRepository refreshTokenRepository
    ) {
        this.jwtService = jwtService;
        this.authService = authService;
        this.refreshTokenRepository = refreshTokenRepository;
    }

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
                                        Authentication authentication) throws IOException, ServletException {
        String targetUrl = determineTargetUrl(request, response, authentication);

        if (response.isCommitted()) {
            logger.debug("Response has already been committed. Unable to redirect to " + targetUrl);
            return;
        }

        clearAuthenticationAttributes(request);
        getRedirectStrategy().sendRedirect(request, response, targetUrl);
    }

    protected String determineTargetUrl(HttpServletRequest request, HttpServletResponse response,
                                        Authentication authentication) {
        String baseUri = authorizedRedirectUris.isEmpty() ? "http://localhost:3000/oauth2/redirect" : authorizedRedirectUris.get(0);

        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        String accessToken = jwtService.generateToken(userDetails);
        
        // Clean and create new refresh token
        refreshTokenRepository.deleteByUser(userDetails.getUser());
        RefreshToken refreshToken = authService.createRefreshToken(userDetails.getUser());

        return UriComponentsBuilder.fromUriString(baseUri)
                .queryParam("token", accessToken)
                .queryParam("refreshToken", refreshToken.getToken())
                .build().toUriString();
    }
}
