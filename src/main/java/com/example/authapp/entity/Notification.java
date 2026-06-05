package com.example.authapp.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "notifications")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Notification {
    @Id
    @GeneratedValue
    @Column(columnDefinition = "UUID", updatable = false, nullable = false)
    private java.util.UUID id;

    @Column(name = "account_id")
    private java.util.UUID accountId;

    private String title;

    private String content;

    private Boolean seen;

    @Column(name = "created_at", nullable = false)
    private java.time.OffsetDateTime createdAt;

    @Column(name = "receive_time")
    private java.time.OffsetDateTime receiveTime;

    @Column(name = "notification_expiry_date")
    private java.time.LocalDate notificationExpiryDate;
}
