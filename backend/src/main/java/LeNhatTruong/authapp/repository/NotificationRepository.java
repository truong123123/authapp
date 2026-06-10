package LeNhatTruong.authapp.repository;

import LeNhatTruong.authapp.entity.Notification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface NotificationRepository extends JpaRepository<Notification, java.util.UUID> {
}
