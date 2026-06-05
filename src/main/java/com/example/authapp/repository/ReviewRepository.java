package com.example.authapp.repository;

import com.example.authapp.entity.Review;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface ReviewRepository extends JpaRepository<Review, Long> {
    long countByUserId(Long userId);
    List<Review> findByUserId(Long userId);
}
