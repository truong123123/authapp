package com.example.authapp.repository;

import com.example.authapp.entity.ProductCategory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ProductCategoryRepository extends JpaRepository<ProductCategory, java.util.UUID> {
    boolean existsByProductAndCategory(com.example.authapp.entity.Product product, com.example.authapp.entity.Category category);
}
