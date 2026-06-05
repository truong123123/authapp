package com.example.authapp.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "variant_values")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class VariantValue {
    @Id
    @GeneratedValue
    @Column(columnDefinition = "UUID", updatable = false, nullable = false)
    private java.util.UUID id;

    @Column(name = "variant_id", nullable = false)
    private java.util.UUID variantId;

    @Column(name = "product_attribute_value_id", nullable = false)
    private java.util.UUID productAttributeValueId;
}
