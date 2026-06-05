package com.example.authapp.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "orders")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Order {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private String id;

    @Column(name = "coupon_id")
    private java.util.UUID couponId;

    @Column(name = "customer_id")
    private java.util.UUID customerId;

    @Column(name = "order_status_id")
    private java.util.UUID orderStatusId;

    @Column(name = "order_approved_at")
    private java.time.OffsetDateTime orderApprovedAt;

    @Column(name = "order_delivered_carrier_date")
    private java.time.OffsetDateTime orderDeliveredCarrierDate;

    @Column(name = "order_delivered_customer_date")
    private java.time.OffsetDateTime orderDeliveredCustomerDate;

    @Column(name = "created_at", nullable = false)
    private java.time.OffsetDateTime createdAt;

    @Column(name = "updated_by")
    private java.util.UUID updatedBy;
}
