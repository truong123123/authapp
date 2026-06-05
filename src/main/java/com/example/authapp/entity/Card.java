package com.example.authapp.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "cards")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Card {
    @Id
    @GeneratedValue
    @Column(columnDefinition = "UUID", updatable = false, nullable = false)
    private java.util.UUID id;

    @Column(name = "user_id")
    private Long userId;

    @Column(name = "card_type")
    private String cardType;

    @Column(name = "last_four")
    private String lastFour;

    @Column(name = "customer_id")
    private java.util.UUID customerId;
}
