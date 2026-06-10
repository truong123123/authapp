package LeNhatTruong.authapp.controller;

import LeNhatTruong.authapp.dto.response.OrderDTO;
import LeNhatTruong.authapp.mapper.OrderMapper;
import LeNhatTruong.authapp.security.CustomUserDetails;
import LeNhatTruong.authapp.service.OrderService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/orders")
@RequiredArgsConstructor
public class OrderController {

    private final OrderService orderService;
    private final OrderMapper orderMapper;

    @GetMapping("/me")
    public ResponseEntity<List<OrderDTO>> getMyOrders(@AuthenticationPrincipal CustomUserDetails userDetails) {
        Long userId = userDetails.getUser().getId();
        List<OrderDTO> orders = orderService.getUserOrders(userId).stream()
                .map(orderMapper::toDTO)
                .collect(Collectors.toList());
        return ResponseEntity.ok(orders);
    }
}
