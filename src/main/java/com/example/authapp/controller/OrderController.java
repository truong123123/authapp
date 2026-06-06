package com.example.authapp.controller;

import com.example.authapp.dto.response.OrderItemDataResponse;
import com.example.authapp.security.CustomUserDetails;
import com.example.authapp.service.OrderService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/orders")
@RequiredArgsConstructor
public class OrderController {

    private final OrderService orderService;

    @GetMapping("/me")
    public ResponseEntity<List<OrderItemDataResponse>> getMyOrders(@AuthenticationPrincipal CustomUserDetails userDetails) {
        Long userId = userDetails.getUser().getId();
        List<OrderItemDataResponse> orders = orderService.getUserOrders(userId);
        return ResponseEntity.ok(orders);
    }
}
