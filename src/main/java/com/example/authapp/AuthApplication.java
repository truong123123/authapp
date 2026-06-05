package com.example.authapp;

import com.example.authapp.entity.Role;
import com.example.authapp.entity.User;
import com.example.authapp.repository.RoleRepository;
import com.example.authapp.repository.UserRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.security.crypto.password.PasswordEncoder;
import java.util.Collections;

@SpringBootApplication
public class AuthApplication {

    public static void main(String[] args) {
        SpringApplication.run(AuthApplication.class, args);
    }

    @Bean
    public CommandLineRunner initDatabase(
            UserRepository userRepository,
            RoleRepository roleRepository,
            PasswordEncoder passwordEncoder,
            com.example.authapp.repository.OrderRepository orderRepository,
            com.example.authapp.repository.CustomerAddressRepository addressRepository,
            com.example.authapp.repository.CardRepository cardRepository,
            com.example.authapp.repository.CouponRepository couponRepository,
            com.example.authapp.repository.ReviewRepository reviewRepository,
            com.example.authapp.repository.ProductRepository productRepository,
            com.example.authapp.repository.OrderStatusRepository orderStatusRepository
    ) {
        return args -> {
            Role userRole = roleRepository.findByName("ROLE_USER")
                    .orElseGet(() -> roleRepository.save(Role.builder().name("ROLE_USER").build()));

            Role adminRole = roleRepository.findByName("ROLE_ADMIN")
                    .orElseGet(() -> roleRepository.save(Role.builder().name("ROLE_ADMIN").build()));

            if (!userRepository.existsByEmail("truongng1511@gmail.com")) {
                User user = User.builder()
                        .name("truongng1511")
                        .email("truongng1511@gmail.com")
                        .password(passwordEncoder.encode("879779"))
                        .provider("local")
                        .roles(new java.util.HashSet<>(java.util.List.of(userRole, adminRole)))
                        .build();
                userRepository.save(user);
                System.out.println(">>> SEEDED USER WITH ADMIN ROLE: truongng1511@gmail.com / 879779 <<<");
            } else {
                userRepository.findByEmail("truongng1511@gmail.com").ifPresent(user -> {
                    if (user.getRoles().stream().noneMatch(r -> r.getName().equals("ROLE_ADMIN"))) {
                        user.getRoles().add(adminRole);
                        userRepository.save(user);
                        System.out.println(">>> UPGRADED truongng1511@gmail.com TO ROLE_ADMIN <<<");
                    }
                });
            }

            // Seed user profile statistics mock data
            User dbUser = userRepository.findByEmail("truongng1511@gmail.com").orElse(null);
            if (dbUser != null) {
                Long userId = dbUser.getId();

                // Seed Orders (12 orders) if count is 0
                if (orderRepository.countByUserId(userId) == 0) {
                    com.example.authapp.entity.OrderStatus defaultStatus = orderStatusRepository.findAll().stream().findFirst()
                            .orElseGet(() -> orderStatusRepository.save(com.example.authapp.entity.OrderStatus.builder()
                                    .statusName("Delivered")
                                    .color("#4CAF50")
                                    .createdAt(java.time.OffsetDateTime.now())
                                    .updatedAt(java.time.OffsetDateTime.now())
                                    .build()));
                    java.util.UUID statusId = defaultStatus.getId();

                    for (int i = 1; i <= 12; i++) {
                        orderRepository.save(com.example.authapp.entity.Order.builder()
                                .userId(userId)
                                .createdAt(java.time.OffsetDateTime.now().minusDays(i))
                                .orderStatusId(statusId)
                                .build());
                    }
                    System.out.println(">>> Seeded 12 sample orders for user: " + userId + " <<<");
                }

                // Seed Addresses (3 addresses) if count is 0
                if (addressRepository.countByUserId(userId) == 0) {
                    addressRepository.save(com.example.authapp.entity.CustomerAddress.builder()
                            .userId(userId)
                            .addressLine1("3 Newbridge Court")
                            .city("Chino Hills")
                            .country("United States")
                            .postalCode("91709")
                            .phoneNumber("123456789")
                            .dialCode("+1")
                            .build());
                    addressRepository.save(com.example.authapp.entity.CustomerAddress.builder()
                            .userId(userId)
                            .addressLine1("562 Duong 3 Thang 2")
                            .city("Ho Chi Minh City")
                            .country("Vietnam")
                            .postalCode("70000")
                            .phoneNumber("987654321")
                            .dialCode("+84")
                            .build());
                    addressRepository.save(com.example.authapp.entity.CustomerAddress.builder()
                            .userId(userId)
                            .addressLine1("123 Phao Dai Lang")
                            .city("Hanoi")
                            .country("Vietnam")
                            .postalCode("10000")
                            .phoneNumber("555123456")
                            .dialCode("+84")
                            .build());
                    System.out.println(">>> Seeded 3 sample addresses for user: " + userId + " <<<");
                }

                // Seed Card (1 card: Visa **34) if count is 0
                if (cardRepository.countByUserId(userId) == 0) {
                    cardRepository.save(com.example.authapp.entity.Card.builder()
                            .userId(userId)
                            .cardType("Visa")
                            .lastFour("34")
                            .build());
                    System.out.println(">>> Seeded Visa card for user: " + userId + " <<<");
                }

                // Seed Coupons (5 promocodes) if count is 0
                if (couponRepository.countByUserId(userId) == 0) {
                    for (int i = 1; i <= 5; i++) {
                        couponRepository.save(com.example.authapp.entity.Coupon.builder()
                                .userId(userId)
                                .code("PROMO" + i)
                                .discountType("PERCENTAGE")
                                .discountValue(10.0 + i)
                                .timesUsed(0.0)
                                .maxUsage(1.0)
                                .build());
                    }
                    System.out.println(">>> Seeded 5 promocodes for user: " + userId + " <<<");
                }

                // Seed Reviews (4 reviews) if count is 0
                if (reviewRepository.countByUserId(userId) == 0) {
                    java.util.List<com.example.authapp.entity.Product> products = productRepository.findAll();
                    java.util.UUID defaultProductId = products.isEmpty() ? java.util.UUID.randomUUID() : products.get(0).getId();
                    for (int i = 1; i <= 4; i++) {
                        java.util.UUID pId = (products.size() >= i) ? products.get(i - 1).getId() : defaultProductId;
                        reviewRepository.save(com.example.authapp.entity.Review.builder()
                                .userId(userId)
                                .productId(pId)
                                .content("Sản phẩm rất tốt, giao hàng nhanh " + i)
                                .rating(5)
                                .createdAt(java.time.OffsetDateTime.now())
                                .build());
                    }
                    System.out.println(">>> Seeded 4 product reviews for user: " + userId + " <<<");
                }
            }
        };
    }
}
