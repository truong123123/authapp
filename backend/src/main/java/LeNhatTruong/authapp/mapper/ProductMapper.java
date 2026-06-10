package LeNhatTruong.authapp.mapper;

import LeNhatTruong.authapp.entity.Product;
import LeNhatTruong.authapp.dto.response.ProductDTO;
import LeNhatTruong.authapp.dto.request.ProductRequest;
import org.springframework.stereotype.Component;

@Component
public class ProductMapper {

    public ProductDTO toDTO(Product product) {
        if (product == null) {
            return null;
        }
        return ProductDTO.builder()
                .id(product.getId())
                .productName(product.getProductName())
                .brandName(product.getBrandName())
                .imageUrl(product.getImageUrl())
                .salePrice(product.getSalePrice())
                .comparePrice(product.getComparePrice())
                .quantity(product.getQuantity())
                .shortDescription(product.getShortDescription())
                .productDescription(product.getProductDescription())
                .productType(product.getProductType())
                .ratingAverage(product.getRatingAverage())
                .reviewCount(product.getReviewCount())
                .sizes(product.getSizes())
                .colors(product.getColors())
                .build();
    }

    public Product toEntity(ProductRequest request) {
        if (request == null) {
            return null;
        }
        Product product = Product.builder()
                .productName(request.getProductName())
                .brandName(request.getBrandName())
                .imageUrl(request.getImageUrl())
                .salePrice(request.getSalePrice())
                .comparePrice(request.getComparePrice())
                .quantity(request.getQuantity())
                .shortDescription(request.getShortDescription())
                .productDescription(request.getProductDescription())
                .productType(request.getProductType())
                .sizes(request.getSizes() != null ? request.getSizes() : new java.util.HashSet<>())
                .colors(request.getColors() != null ? request.getColors() : new java.util.HashSet<>())
                .build();
        product.setCategoryIds(request.getCategoryIds());
        return product;
    }

    public void updateEntity(ProductRequest request, Product product) {
        if (request == null || product == null) {
            return;
        }
        product.setProductName(request.getProductName());
        product.setBrandName(request.getBrandName());
        product.setImageUrl(request.getImageUrl());
        product.setSalePrice(request.getSalePrice());
        product.setComparePrice(request.getComparePrice());
        product.setQuantity(request.getQuantity());
        product.setShortDescription(request.getShortDescription());
        product.setProductDescription(request.getProductDescription());
        product.setProductType(request.getProductType());
        if (request.getSizes() != null) {
            product.setSizes(request.getSizes());
        }
        if (request.getColors() != null) {
            product.setColors(request.getColors());
        }
        if (request.getCategoryIds() != null) {
            product.setCategoryIds(request.getCategoryIds());
        }
    }
}
