package com.example.authapp.repository;

import com.example.authapp.entity.ProductCategory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface ProductCategoryRepository extends JpaRepository<ProductCategory, UUID> {
    boolean existsByProductAndCategory(com.example.authapp.entity.Product product, com.example.authapp.entity.Category category);

    @Query("SELECT pc.category.id FROM ProductCategory pc WHERE pc.product.id = :productId")
    List<UUID> findCategoryIdsByProductId(@Param("productId") UUID productId);

    void deleteByProductId(UUID productId);
}
