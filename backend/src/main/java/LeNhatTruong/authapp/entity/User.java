package LeNhatTruong.authapp.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "users")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false, unique = true)
    private String email;

    @com.fasterxml.jackson.annotation.JsonProperty(access = com.fasterxml.jackson.annotation.JsonProperty.Access.WRITE_ONLY)
    private String password; // Will be null for Google/Facebook OAuth2 users

    @Column(nullable = false)
    private String provider; // "local", "google", "facebook"

    private String providerId; // Client-side provider identifier

    @Transient
    private String accessToken;

    @Transient
    private String refreshToken;

    @Transient
    @Builder.Default
    private String tokenType = "Bearer";

    @Transient
    private String dateOfBirth;

    @Transient
    private Boolean salesNotification;

    @Transient
    private Boolean newArrivalsNotification;

    @Transient
    private Boolean deliveryStatusNotification;

    @Column(length = 512)
    private String avatarUrl;

    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(
        name = "app_user_roles",
        joinColumns = @JoinColumn(name = "user_id"),
        inverseJoinColumns = @JoinColumn(name = "role_id")
    )
    @Builder.Default
    @com.fasterxml.jackson.annotation.JsonIgnore
    private Set<Role> roles = new HashSet<>();

    @com.fasterxml.jackson.annotation.JsonProperty("roles")
    public Set<String> getRoleNames() {
        if (roles == null) return new HashSet<>();
        Set<String> roleNames = new HashSet<>();
        for (Role r : roles) {
            roleNames.add(r.getName());
        }
        return roleNames;
    }
}
