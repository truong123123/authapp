package LeNhatTruong.authapp.service.impl;

import LeNhatTruong.authapp.entity.Order;
import LeNhatTruong.authapp.repository.OrderRepository;
import LeNhatTruong.authapp.service.OrderService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
@RequiredArgsConstructor
public class OrderServiceImpl implements OrderService {

    private final OrderRepository orderRepository;

    @Override
    public List<Order> getUserOrders(Long userId) {
        return orderRepository.findByCustomerUserId(userId);
    }
}
