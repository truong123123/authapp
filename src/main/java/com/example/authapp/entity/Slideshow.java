package com.example.authapp.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "slideshows")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Slideshow {
    @Id
    @GeneratedValue
    @Column(columnDefinition = "UUID", updatable = false, nullable = false)
    private java.util.UUID id;

    private String title;

    @Column(name = "destination_url")
    private String destinationUrl;

    @Column(nullable = false)
    private String image;

    @Column(nullable = false)
    private String placeholder;

    private String description;

    @Column(name = "btn_label")
    private String btnLabel;

    @Column(name = "display_order", nullable = false)
    private Integer displayOrder;

    private Boolean published;

    @Column(nullable = false)
    private Integer clicks;

    @Column(columnDefinition = "jsonb")
    private String styles;

    @Column(name = "created_at", nullable = false)
    private java.time.OffsetDateTime createdAt;

    @Column(name = "updated_at", nullable = false)
    private java.time.OffsetDateTime updatedAt;

    @Column(name = "created_by")
    private java.util.UUID createdBy;

    @Column(name = "updated_by")
    private java.util.UUID updatedBy;
}
