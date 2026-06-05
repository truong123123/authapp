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
    private Integer quantity;
    private String shortDescription;
    private String productDescription;
    private String productType;
    private Set<String> tags;
    private Set<String> sizes;
    private Set<String> colors;
    private Set<String> categoryIds;
}
