package LeNhatTruong.authapp.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.OffsetDateTime;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OrderDTO {
    private String id;
    private OffsetDateTime createdAt;
    private Double totalAmount;
    private String shippingAddress;
    private String deliveryMethod;
    private String paymentMethod;
    private Double discount;
    private String trackingNumber;
    private OrderStatusDTO orderStatus;
    private List<OrderItemDTO> items;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class OrderStatusDTO {
        private String statusName;
        private String color;
    }
}
