package com.example.authapp.controller;

import com.example.authapp.entity.*;
import com.example.authapp.repository.*;
import com.example.authapp.security.CustomUserDetails;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import java.util.UUID;
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
    private final CustomerRepository customerRepository;
    private final ProductRepository productRepository;
    private final UserRepository userRepository;

    private Customer getOrCreateCustomer(User user) {
        return customerRepository.findByUserId(user.getId())
                .orElseGet(() -> {
                    String[] names = user.getName().split(" ", 2);
                    String firstName = names[0];
                    String lastName = names.length > 1 ? names[1] : "";
                    if (lastName.isEmpty()) {
                        lastName = firstName;
                    }
                    Customer customer = Customer.builder()
                            .user(user)
                            .firstName(firstName)
                            .lastName(lastName)
                            .email(user.getEmail())
                            .passwordHash(user.getPassword() != null ? user.getPassword() : "")
                            .active(true)
                            .registeredAt(java.time.OffsetDateTime.now())
                            .updatedAt(java.time.OffsetDateTime.now())
                            .build();
                    return customerRepository.save(customer);
                });
    }

    @GetMapping("/me")
    public ResponseEntity<User> getCurrentUser(@AuthenticationPrincipal CustomUserDetails userDetails) {
        User user = userDetails.getUser();
        Customer customer = customerRepository.findByUserId(user.getId()).orElse(null);

        if (customer != null) {
            user.setDateOfBirth(customer.getDateOfBirth() != null ? customer.getDateOfBirth().toString() : null);
            user.setSalesNotification(customer.getSalesNotification());
            user.setNewArrivalsNotification(customer.getNewArrivalsNotification());
            user.setDeliveryStatusNotification(customer.getDeliveryStatusNotification());
        } else {
            user.setSalesNotification(true);
            user.setNewArrivalsNotification(true);
            user.setDeliveryStatusNotification(true);
        }

        return ResponseEntity.ok(user);
    }

    @PutMapping("/profile")
    public ResponseEntity<Void> updateProfile(
            @AuthenticationPrincipal CustomUserDetails userDetails,
            @RequestBody Map<String, Object> request
    ) {
        User user = userDetails.getUser();
        Customer customer = getOrCreateCustomer(user);

        if (request.containsKey("name")) {
            String name = (String) request.get("name");
            if (name != null && !name.trim().isEmpty()) {
                user.setName(name.trim());
                userRepository.save(user);
                
                String[] names = user.getName().split(" ", 2);
                customer.setFirstName(names[0]);
                customer.setLastName(names.length > 1 ? names[1] : names[0]);
            }
        }

        if (request.containsKey("dateOfBirth")) {
            String dob = (String) request.get("dateOfBirth");
            if (dob != null && !dob.trim().isEmpty()) {
                try {
                    customer.setDateOfBirth(LocalDate.parse(dob.trim()));
                } catch (Exception e) {
                    // Ignore parsing errors
                }
            }
        }

        if (request.containsKey("salesNotification")) {
            customer.setSalesNotification((Boolean) request.get("salesNotification"));
        }
        if (request.containsKey("newArrivalsNotification")) {
            customer.setNewArrivalsNotification((Boolean) request.get("newArrivalsNotification"));
        }
        if (request.containsKey("deliveryStatusNotification")) {
            customer.setDeliveryStatusNotification((Boolean) request.get("deliveryStatusNotification"));
        }

        customer.setUpdatedAt(java.time.OffsetDateTime.now());
        customerRepository.save(customer);

        return ResponseEntity.ok().build();
    }

    @GetMapping("/profile-stats")
    public ResponseEntity<Map<String, Object>> getProfileStats(@AuthenticationPrincipal CustomUserDetails userDetails) {
        Long userId = userDetails.getUser().getId();
        long orders = orderRepository.countByCustomerUserId(userId);
        long addresses = addressRepository.countByCustomerUserId(userId);
        long coupons = couponRepository.count();
        long reviews = reviewRepository.countByUserId(userId);

        java.util.List<Card> cards = cardRepository.findByCustomerUserId(userId);
        String cardSummary = "No payment methods";
        if (!cards.isEmpty()) {
            Card primary = cards.get(0);
            String type = primary.getCardType() != null ? primary.getCardType() : "Visa";
            String lastFour = primary.getLastFour() != null ? primary.getLastFour() : "34";
            cardSummary = type + " **" + lastFour;
        }

        Map<String, Object> stats = new java.util.HashMap<>();
        stats.put("orderCount", orders);
        stats.put("addressCount", addresses);
        stats.put("paymentMethodSummary", cardSummary);
        stats.put("couponCount", coupons);
        stats.put("reviewCount", reviews);

        return ResponseEntity.ok(stats);
    }

    @SuppressWarnings("unchecked")
    @PostMapping("/orders")
    public ResponseEntity<Order> createOrder(
            @AuthenticationPrincipal CustomUserDetails userDetails,
            @RequestBody Map<String, Object> request
    ) {
        User user = userDetails.getUser();
        Customer customer = getOrCreateCustomer(user);
        
        OrderStatus defaultStatus = orderStatusRepository.findAll().stream()
                .filter(s -> s.getStatusName().equalsIgnoreCase("Processing"))
                .findFirst()
                .orElseGet(() -> orderStatusRepository.save(OrderStatus.builder()
                        .statusName("Processing")
                        .color("#FFC107")
                        .createdAt(java.time.OffsetDateTime.now())
                        .updatedAt(java.time.OffsetDateTime.now())
                        .build()));

        double totalAmount = request.get("totalAmount") != null ? ((Number) request.get("totalAmount")).doubleValue() : 0.0;
        String shippingAddress = (String) request.get("shippingAddress");
        String deliveryMethod = (String) request.get("deliveryMethod");
        String paymentMethod = (String) request.get("paymentMethod");
        double discount = request.get("discount") != null ? ((Number) request.get("discount")).doubleValue() : 0.0;

        Order order = Order.builder()
                .customer(customer)
                .createdAt(java.time.OffsetDateTime.now())
                .orderStatus(defaultStatus)
                .totalAmount(totalAmount)
                .shippingAddress(shippingAddress)
                .deliveryMethod(deliveryMethod)
                .paymentMethod(paymentMethod)
                .discount(discount)
                .build();

        List<OrderItem> items = new java.util.ArrayList<>();
        if (request.get("items") != null) {
            List<Map<String, Object>> itemsList = (List<Map<String, Object>>) request.get("items");
            for (Map<String, Object> itemReq : itemsList) {
                String productIdStr = (String) itemReq.get("productId");
                UUID productId = UUID.fromString(productIdStr);
                Product product = productRepository.findById(productId)
                        .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy sản phẩm"));
                
                int quantity = itemReq.get("quantity") != null ? ((Number) itemReq.get("quantity")).intValue() : 1;
                double price = itemReq.get("price") != null ? ((Number) itemReq.get("price")).doubleValue() : 0.0;
                String selectedSize = (String) itemReq.get("selectedSize");
                String selectedColor = (String) itemReq.get("selectedColor");

                items.add(OrderItem.builder()
                        .order(order)
                        .product(product)
                        .quantity(quantity)
                        .price(price)
                        .selectedSize(selectedSize)
                        .selectedColor(selectedColor)
                        .build());
            }
        }
        order.setItems(items);

        Order saved = orderRepository.save(order);
        return ResponseEntity.ok(saved);
    }

    @GetMapping("/cards")
    public ResponseEntity<List<Card>> getMyCards(@AuthenticationPrincipal CustomUserDetails userDetails) {
        User user = userDetails.getUser();
        Customer customer = getOrCreateCustomer(user);
        List<Card> cards = cardRepository.findByCustomerUserId(user.getId());
        return ResponseEntity.ok(cards);
    }

    @PostMapping("/cards")
    public ResponseEntity<Card> addCard(
            @AuthenticationPrincipal CustomUserDetails userDetails,
            @RequestBody Map<String, String> request
    ) {
        User user = userDetails.getUser();
        Customer customer = getOrCreateCustomer(user);

        Card card = Card.builder()
                .customer(customer)
                .cardType(request.get("cardType"))
                .lastFour(request.get("lastFour"))
                .build();

        Card saved = cardRepository.save(card);
        return ResponseEntity.ok(saved);
    }

    @PostMapping("/simulate/order")
    public ResponseEntity<Void> simulateOrder(@AuthenticationPrincipal CustomUserDetails userDetails) {
        User user = userDetails.getUser();
        Customer customer = getOrCreateCustomer(user);
        OrderStatus defaultStatus = orderStatusRepository.findAll().stream().findFirst()
                .orElseGet(() -> orderStatusRepository.save(OrderStatus.builder()
                        .statusName("Delivered")
                        .color("#4CAF50")
                        .createdAt(java.time.OffsetDateTime.now())
                        .updatedAt(java.time.OffsetDateTime.now())
                        .build()));

        orderRepository.save(Order.builder()
                .customer(customer)
                .createdAt(java.time.OffsetDateTime.now())
                .orderStatus(defaultStatus)
                .build());
        return ResponseEntity.ok().build();
    }

    @PostMapping("/simulate/address")
    public ResponseEntity<Void> simulateAddress(@AuthenticationPrincipal CustomUserDetails userDetails) {
        User user = userDetails.getUser();
        Customer customer = getOrCreateCustomer(user);
        addressRepository.save(CustomerAddress.builder()
                .customer(customer)
                .addressLine1("Simulation Address " + (addressRepository.countByCustomerUserId(user.getId()) + 1))
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
        User user = userDetails.getUser();
        Customer customer = getOrCreateCustomer(user);
        cardRepository.save(Card.builder()
                .customer(customer)
                .cardType("Mastercard")
                .lastFour("99")
                .build());
        return ResponseEntity.ok().build();
    }

    @PostMapping("/simulate/review")
    public ResponseEntity<Void> simulateReview(@AuthenticationPrincipal CustomUserDetails userDetails) {
        User user = userDetails.getUser();
        java.util.List<Product> products = productRepository.findAll();
        Product product = products.isEmpty() ? null : products.get(0);
        if (product != null) {
            reviewRepository.save(Review.builder()
                    .user(user)
                    .product(product)
                    .content("Giao hang cuc ky nhanh, rat hai long!")
                    .rating(5)
                    .createdAt(java.time.OffsetDateTime.now())
                    .build());
        }
        return ResponseEntity.ok().build();
    }

    @PostMapping("/simulate/coupon")
    public ResponseEntity<Void> simulateCoupon() {
        couponRepository.save(Coupon.builder()
                .code("SIMULATE" + (couponRepository.count() + 1))
                .discountType("PERCENTAGE")
                .discountValue(15.0)
                .timesUsed(0.0)
                .maxUsage(1.0)
                .build());
        return ResponseEntity.ok().build();
    }
}
