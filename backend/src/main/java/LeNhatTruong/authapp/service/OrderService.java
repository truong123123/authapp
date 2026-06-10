package LeNhatTruong.authapp.service;

import LeNhatTruong.authapp.entity.Order;
import java.util.List;

public interface OrderService {
    List<Order> getUserOrders(Long userId);
}
