package com.example.authapp.service;

import com.example.authapp.entity.Order;
import java.util.List;

public interface OrderService {
    List<Order> getUserOrders(Long userId);
}
