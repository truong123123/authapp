package com.example.authapp.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "staff_roles")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class StaffRole {
    @Id
    @GeneratedValue
    @Column(columnDefinition = "UUID", updatable = false, nullable = false)
    private java.util.UUID id;

    @Column(name = "role_name", nullable = false)
    private String roleName;

    private String privileges;

    @Column(nullable = false)
    private String name;
}
