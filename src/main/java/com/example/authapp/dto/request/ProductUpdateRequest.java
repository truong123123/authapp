package com.example.authapp.dto.request;

import lombok.Data;
import java.util.Set;

@Data
public class ProductUpdateRequest {
    private String productName;
    private String brandName;
    private String imageUrl;
    private Double salePrice;
    private Double comparePrice;
    private String shortDescription;
    private String productDescription;
    private Set<String> tags; // Ví dụ: ["NEW"] hoặc ["SALE"]
}
