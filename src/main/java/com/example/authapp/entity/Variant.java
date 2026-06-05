package com.example.authapp.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "variants")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Variant {
    @Id
    @GeneratedValue
    @Column(columnDefinition = "UUID", updatable = false, nullable = false)
    private java.util.UUID id;

    @Column(name = "variant_option", nullable = false)
    private String variantOption;

    @Column(name = "product_id", nullable = false)
    private java.util.UUID productId;

    @Column(name = "variant_option_id", nullable = false)
    private java.util.UUID variantOptionId;
}
