package LeNhatTruong.authapp.dto.request;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Positive;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Set;
import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ProductRequest {

    @NotBlank(message = "Product name is required")
    private String productName;

    private String brandName;

    private String imageUrl;

    @Positive(message = "Sale price must be positive")
    private double salePrice;

    private Double comparePrice;

    @Min(value = 0, message = "Quantity cannot be negative")
    private int quantity;

    @NotBlank(message = "Short description is required")
    private String shortDescription;

    @NotBlank(message = "Product description is required")
    private String productDescription;

    private String productType;

    private Set<String> sizes;

    private Set<String> colors;

    private Set<UUID> categoryIds;
}
