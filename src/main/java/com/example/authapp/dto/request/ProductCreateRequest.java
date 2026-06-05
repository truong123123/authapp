package com.example.authapp.dto.request;

import lombok.Data;
import java.util.Set;

@Data
public class ProductCreateRequest {
    private String productName;
    private String brandName;
    private String imageUrl;
    private Double salePrice;
    private Double comparePrice;
    private int quantity = 50;
    private String shortDescription;
    private String productDescription;
    private String productType = "simple";
    private Set<String> tags;
    private Set<String> sizes;
    private Set<String> colors;
    private Set<String> categoryIds;
}
