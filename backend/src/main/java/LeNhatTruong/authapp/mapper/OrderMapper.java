package LeNhatTruong.authapp.mapper;

import LeNhatTruong.authapp.entity.Order;
import LeNhatTruong.authapp.entity.OrderItem;
import LeNhatTruong.authapp.dto.response.OrderDTO;
import LeNhatTruong.authapp.dto.response.OrderItemDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

@Component
@RequiredArgsConstructor
public class OrderMapper {

    private final ProductMapper productMapper;

    public OrderDTO toDTO(Order order) {
        if (order == null) {
            return null;
        }

        OrderDTO.OrderStatusDTO statusDTO = null;
        if (order.getOrderStatus() != null) {
            statusDTO = OrderDTO.OrderStatusDTO.builder()
                    .statusName(order.getOrderStatus().getStatusName())
                    .color(order.getOrderStatus().getColor())
                    .build();
        }

        List<OrderItemDTO> itemDTOs = Collections.emptyList();
        if (order.getItems() != null) {
            itemDTOs = order.getItems().stream()
                    .map(this::toItemDTO)
                    .collect(Collectors.toList());
        }

        return OrderDTO.builder()
                .id(order.getId())
                .createdAt(order.getCreatedAt())
                .totalAmount(order.getTotalAmount())
                .shippingAddress(order.getShippingAddress())
                .deliveryMethod(order.getDeliveryMethod())
                .paymentMethod(order.getPaymentMethod())
                .discount(order.getDiscount())
                .trackingNumber(order.getTrackingNumber())
                .orderStatus(statusDTO)
                .items(itemDTOs)
                .build();
    }

    private OrderItemDTO toItemDTO(OrderItem item) {
        if (item == null) {
            return null;
        }
        return OrderItemDTO.builder()
                .id(item.getId())
                .product(productMapper.toDTO(item.getProduct()))
                .price(item.getPrice())
                .quantity(item.getQuantity())
                .selectedSize(item.getSelectedSize())
                .selectedColor(item.getSelectedColor())
                .build();
    }
}
