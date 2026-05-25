package com.example.authapp.service;

import com.example.authapp.entity.Role;
import com.example.authapp.entity.User;
import com.example.authapp.repository.RoleRepository;
import com.example.authapp.repository.UserRepository;
import com.example.authapp.security.CustomUserDetails;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.InternalAuthenticationServiceException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import java.util.Collections;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class OAuth2UserServiceImpl extends DefaultOAuth2UserService {

    private final UserRepository userRepository;
    private final RoleRepository roleRepository;

    @Override
    public OAuth2User loadUser(OAuth2UserRequest oAuth2UserRequest) throws OAuth2AuthenticationException {
        OAuth2User oAuth2User = super.loadUser(oAuth2UserRequest);

        try {
            return processOAuth2User(oAuth2UserRequest, oAuth2User);
        } catch (AuthenticationException ex) {
            throw ex;
        } catch (Exception ex) {
            throw new InternalAuthenticationServiceException(ex.getMessage(), ex.getCause());
        }
    }

    private OAuth2User processOAuth2User(OAuth2UserRequest oAuth2UserRequest, OAuth2User oAuth2User) {
        String provider = oAuth2UserRequest.getClientRegistration().getRegistrationId();
        
        String providerId = oAuth2User.getAttribute("sub"); // Google
        if (providerId == null) {
            providerId = oAuth2User.getAttribute("id"); // Facebook
        }
        
        if (!StringUtils.hasText(providerId)) {
            throw new OAuth2AuthenticationException("Provider ID not found from OAuth2 provider");
        }

        String email = oAuth2User.getAttribute("email");
        if (!StringUtils.hasText(email)) {
            throw new OAuth2AuthenticationException("Email not found from OAuth2 provider");
        }

        String name = oAuth2User.getAttribute("name");
        if (!StringUtils.hasText(name)) {
            name = email.split("@")[0];
        }

        Optional<User> userOptional = userRepository.findByEmail(email);
        User user;
        if (userOptional.isPresent()) {
            user = userOptional.get();
            if (!user.getProvider().equalsIgnoreCase(provider)) {
                throw new OAuth2AuthenticationException("Looks like you're signed up with " +
                        user.getProvider() + " account. Please use your " + user.getProvider() +
                        " login.");
            }
            user = updateExistingUser(user, name);
        } else {
            user = registerNewUser(provider, providerId, name, email);
        }

        return new CustomUserDetails(user, oAuth2User.getAttributes());
    }

    private User registerNewUser(String provider, String providerId, String name, String email) {
        Role userRole = roleRepository.findByName("ROLE_USER")
                .orElseGet(() -> roleRepository.save(Role.builder().name("ROLE_USER").build()));

        User user = User.builder()
                .name(name)
                .email(email)
                .provider(provider)
                .providerId(providerId)
                .roles(Collections.singleton(userRole))
                .build();

        return userRepository.save(user);
    }

    private User updateExistingUser(User existingUser, String name) {
        existingUser.setName(name);
        return userRepository.save(existingUser);
    }
}
