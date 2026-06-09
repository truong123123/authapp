package com.example.authapp.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Entity
@Table(name = "reviews")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Review {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @com.fasterxml.jackson.annotation.JsonIgnore
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "product_id", nullable = false)
    private Product product;

    private String title;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String content;

    @Column(nullable = false)
    private int rating;

    @ElementCollection
    @CollectionTable(name = "review_photos", joinColumns = @JoinColumn(name = "review_id"))
    @Column(name = "photo_url")
    @Builder.Default
    private List<String> photos = new ArrayList<>();

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private OffsetDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at", nullable = false)
    private OffsetDateTime updatedAt;

    @com.fasterxml.jackson.annotation.JsonProperty("name")
    public String getReviewerName() {
        return user != null ? user.getName() : "Anonymous";
    }

    @com.fasterxml.jackson.annotation.JsonProperty("avatar")
    public String getReviewerAvatar() {
        String name = getReviewerName();
        return (name != null && !name.isEmpty()) ? name.substring(0, 1).toUpperCase() : "U";
    }

    @com.fasterxml.jackson.annotation.JsonProperty("avatarUrl")
    public String getReviewerAvatarUrl() {
        return user != null ? user.getAvatarUrl() : "";
    }

    @com.fasterxml.jackson.annotation.JsonProperty("date")
    public String getReviewDate() {
        if (createdAt == null) return "Today";
        java.time.format.DateTimeFormatter formatter = java.time.format.DateTimeFormatter.ofPattern("MMMM dd, yyyy", java.util.Locale.ENGLISH);
        return createdAt.format(formatter);
    }

    @com.fasterxml.jackson.annotation.JsonProperty("helpful")
    public boolean isHelpful() {
        return false;
    }

    @com.fasterxml.jackson.annotation.JsonProperty("hasPhoto")
    public boolean hasPhoto() {
        return photos != null && !photos.isEmpty();
    }
}
