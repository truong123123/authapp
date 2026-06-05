package com.example.authapp.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "coupons")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Coupon {
    @Id
    @GeneratedValue
    @Column(columnDefinition = "UUID", updatable = false, nullable = false)
    private java.util.UUID id;

    @Column(name = "user_id")
    private Long userId;

    @Column(nullable = false)
    private String code;

    @Column(name = "discount_value")
    private Double discountValue;

    @Column(name = "discount_type", nullable = false)
    private String discountType;

    @Column(name = "times_used", nullable = false)
    private Double timesUsed;

    @Column(name = "max_usage")
    private Double maxUsage;

    @Column(name = "order_amount_limit")
    private Double orderAmountLimit;

    @Column(name = "coupon_start_date")
    private java.time.OffsetDateTime couponStartDate;

    @Column(name = "coupon_end_date")
    private java.time.OffsetDateTime couponEndDate;
}
