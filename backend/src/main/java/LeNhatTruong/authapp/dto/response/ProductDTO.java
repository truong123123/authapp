package LeNhatTruong.authapp.dto.response;

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
public class ProductDTO {
    private UUID id;
    private String productName;
    private String brandName;
    private String imageUrl;
    private double salePrice;
    private Double comparePrice;
    private int quantity;
    private String shortDescription;
    private String productDescription;
    private String productType;
    private Double ratingAverage;
    private Integer reviewCount;
    private Set<String> sizes;
    private Set<String> colors;
}
