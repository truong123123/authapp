package LeNhatTruong.authapp.service;

import LeNhatTruong.authapp.entity.Notification;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface NotificationService {
    List<Notification> getAllNotifications();
    Optional<Notification> getNotificationById(UUID id);
    Notification saveNotification(Notification notification);
    Notification updateNotification(Notification notification);
    void deleteNotification(UUID id);
}
