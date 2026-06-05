package com.example.authapp.controller;

import com.example.authapp.dto.response.UserResponse;
import com.example.authapp.dto.response.UserProfileStatsResponse;
import com.example.authapp.entity.*;
import com.example.authapp.repository.*;
import com.example.authapp.security.CustomUserDetails;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
public class UserController {

    private final OrderRepository orderRepository;
    private final CustomerAddressRepository addressRepository;
    private final CardRepository cardRepository;
    private final CouponRepository couponRepository;
    private final ReviewRepository reviewRepository;
    private final OrderStatusRepository orderStatusRepository;

    @GetMapping("/me")
    public ResponseEntity<UserResponse> getCurrentUser(@AuthenticationPrincipal CustomUserDetails userDetails) {
        User user = userDetails.getUser();
        UserResponse response = UserResponse.builder()
                .id(user.getId())
                .name(user.getName())
                .email(user.getEmail())
                .provider(user.getProvider())
                .avatarUrl(user.getAvatarUrl())
                .roles(user.getRoles().stream().map(Role::getName).collect(Collectors.toSet()))
                .build();
        return ResponseEntity.ok(response);
    }

    @GetMapping("/profile-stats")
    public ResponseEntity<UserProfileStatsResponse> getProfileStats(@AuthenticationPrincipal CustomUserDetails userDetails) {
        Long userId = userDetails.getUser().getId();
        long orders = orderRepository.countByUserId(userId);
        long addresses = addressRepository.countByUserId(userId);
        long coupons = couponRepository.countByUserId(userId);
        long reviews = reviewRepository.countByUserId(userId);

        java.util.List<Card> cards = cardRepository.findByUserId(userId);
        String cardSummary = "No payment methods";
        if (!cards.isEmpty()) {
            Card primary = cards.get(0);
            String type = primary.getCardType() != null ? primary.getCardType() : "Visa";
            String lastFour = primary.getLastFour() != null ? primary.getLastFour() : "34";
            cardSummary = type + " **" + lastFour;
        }

        UserProfileStatsResponse stats = UserProfileStatsResponse.builder()
                .orderCount(orders)
                .addressCount(addresses)
                .paymentMethodSummary(cardSummary)
                .couponCount(coupons)
                .reviewCount(reviews)
                .build();
        return ResponseEntity.ok(stats);
    }

    @PostMapping("/orders")
    public ResponseEntity<Order> createOrder(@AuthenticationPrincipal CustomUserDetails userDetails) {
        Long userId = userDetails.getUser().getId();
        OrderStatus defaultStatus = orderStatusRepository.findAll().stream().findFirst()
                .orElseGet(() -> orderStatusRepository.save(OrderStatus.builder()
                        .statusName("Processing")
                        .color("#FFC107")
                        .createdAt(java.time.OffsetDateTime.now())
                        .updatedAt(java.time.OffsetDateTime.now())
                        .build()));
        java.util.UUID statusId = defaultStatus.getId();

        Order order = Order.builder()
                .userId(userId)
                .createdAt(java.time.OffsetDateTime.now())
                .orderStatusId(statusId)
                .build();
        Order saved = orderRepository.save(order);
        return ResponseEntity.ok(saved);
    }

    @PostMapping("/simulate/order")
    public ResponseEntity<Void> simulateOrder(@AuthenticationPrincipal CustomUserDetails userDetails) {
        Long userId = userDetails.getUser().getId();
        OrderStatus defaultStatus = orderStatusRepository.findAll().stream().findFirst()
                .orElseGet(() -> orderStatusRepository.save(OrderStatus.builder()
                        .statusName("Delivered")
                        .color("#4CAF50")
                        .createdAt(java.time.OffsetDateTime.now())
                        .updatedAt(java.time.OffsetDateTime.now())
                        .build()));
        java.util.UUID statusId = defaultStatus.getId();

        orderRepository.save(Order.builder()
                .userId(userId)
                .createdAt(java.time.OffsetDateTime.now())
                .orderStatusId(statusId)
                .build());
        return ResponseEntity.ok().build();
    }

    @PostMapping("/simulate/address")
    public ResponseEntity<Void> simulateAddress(@AuthenticationPrincipal CustomUserDetails userDetails) {
        Long userId = userDetails.getUser().getId();
        addressRepository.save(CustomerAddress.builder()
                .userId(userId)
                .addressLine1("Simulation Address " + (addressRepository.countByUserId(userId) + 1))
                .city("Hanoi")
                .country("Vietnam")
                .postalCode("10000")
                .phoneNumber("111222333")
                .dialCode("+84")
                .build());
        return ResponseEntity.ok().build();
    }

    @PostMapping("/simulate/card")
    public ResponseEntity<Void> simulateCard(@AuthenticationPrincipal CustomUserDetails userDetails) {
        Long userId = userDetails.getUser().getId();
        cardRepository.save(Card.builder()
                .userId(userId)
                .cardType("Mastercard")
                .lastFour("99")
                .build());
        return ResponseEntity.ok().build();
    }

    @PostMapping("/simulate/review")
    public ResponseEntity<Void> simulateReview(@AuthenticationPrincipal CustomUserDetails userDetails) {
        Long userId = userDetails.getUser().getId();
        reviewRepository.save(Review.builder()
                .userId(userId)
                .productId(java.util.UUID.randomUUID())
                .content("Giao hang cuc ky nhanh, rat hai long!")
                .rating(5)
                .createdAt(java.time.OffsetDateTime.now())
                .build());
        return ResponseEntity.ok().build();
    }

    @PostMapping("/simulate/coupon")
    public ResponseEntity<Void> simulateCoupon(@AuthenticationPrincipal CustomUserDetails userDetails) {
        Long userId = userDetails.getUser().getId();
        couponRepository.save(Coupon.builder()
                .userId(userId)
                .code("SIMULATE" + (couponRepository.countByUserId(userId) + 1))
                .discountType("PERCENTAGE")
                .discountValue(15.0)
                .timesUsed(0.0)
                .maxUsage(1.0)
                .build());
        return ResponseEntity.ok().build();
    }
}
