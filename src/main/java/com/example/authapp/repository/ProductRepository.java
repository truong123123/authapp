package com.example.authapp.repository;

import com.example.authapp.entity.Product;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface ProductRepository extends JpaRepository<Product, UUID> {
    
    @Query("SELECT p FROM Product p WHERE p.comparePrice IS NOT NULL AND p.comparePrice > p.salePrice")
    List<Product> findSaleProducts();
    
    List<Product> findByTagsTagNameIgnoreCase(String tagName);
    java.util.Optional<Product> findByProductName(String productName);

    @Query("SELECT pc.product FROM ProductCategory pc WHERE pc.category.id = :categoryId")
    List<Product> findByCategoryId(java.util.UUID categoryId);
}
