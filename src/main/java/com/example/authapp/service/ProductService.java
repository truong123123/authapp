package com.example.authapp.service;

import com.example.authapp.dto.request.ProductUpdateRequest;
import com.example.authapp.entity.Product;
import com.example.authapp.entity.Tag;
import com.example.authapp.repository.ProductRepository;
import com.example.authapp.repository.TagRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class ProductService {

    private final ProductRepository productRepository;
    private final TagRepository tagRepository;

    public List<Product> getSaleProducts() {
        return productRepository.findSaleProducts();
    }

    public List<Product> getNewProducts() {
        List<Product> newProducts = productRepository.findByTagsTagNameIgnoreCase("NEW");
        if (newProducts.isEmpty()) {
            return productRepository.findAll(Sort.by(Sort.Direction.DESC, "createdAt"));
        }
        return newProducts;
    }

    public List<Product> getAllProducts() {
        return productRepository.findAll();
    }

    public List<Product> getProductsByTag(String tagName) {
        return productRepository.findByTagsTagNameIgnoreCase(tagName);
    }

    @Transactional
    public Product updateProduct(UUID id, ProductUpdateRequest request) {
        Product product = productRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Product not found with id " + id));

        if (request.getProductName() != null) {
            product.setProductName(request.getProductName());
            product.setSlug(request.getProductName().toLowerCase()
                    .replaceAll("[^a-z0-9\\s]", "")
                    .replaceAll("\\s+", "-"));
        }
        if (request.getBrandName() != null) {
            product.setBrandName(request.getBrandName());
        }
        if (request.getImageUrl() != null) {
            product.setImageUrl(request.getImageUrl());
        }
        if (request.getSalePrice() != null) {
            product.setSalePrice(request.getSalePrice());
        }
        if (request.getComparePrice() != null) {
            product.setComparePrice(request.getComparePrice());
        }
        if (request.getShortDescription() != null) {
            product.setShortDescription(request.getShortDescription());
        }
        if (request.getProductDescription() != null) {
            product.setProductDescription(request.getProductDescription());
        }

        if (request.getTags() != null) {
            Set<Tag> updatedTags = new HashSet<>();
            for (String tagName : request.getTags()) {
                Tag tag = tagRepository.findByTagName(tagName.toUpperCase())
                        .orElseGet(() -> {
                            Tag newTag = Tag.builder().tagName(tagName.toUpperCase()).build();
                            return tagRepository.save(newTag);
                        });
                updatedTags.add(tag);
            }
            product.setTags(updatedTags);
        }

        return productRepository.save(product);
    }

    public List<Product> getProductsByCategory(UUID categoryId) {
        return productRepository.findByCategoryId(categoryId);
    }
}
