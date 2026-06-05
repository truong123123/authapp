package com.example.authapp.repository;

import com.example.authapp.entity.Coupon;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CouponRepository extends JpaRepository<Coupon, java.util.UUID> {
    long countByUserId(Long userId);
    java.util.List<Coupon> findByUserId(Long userId);
}
