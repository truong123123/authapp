package LeNhatTruong.authapp.mapper;

import LeNhatTruong.authapp.entity.User;
import LeNhatTruong.authapp.dto.response.UserDTO;
import org.springframework.stereotype.Component;

@Component
public class UserMapper {

    public UserDTO toDTO(User user) {
        if (user == null) {
            return null;
        }
        return UserDTO.builder()
                .id(user.getId())
                .name(user.getName())
                .email(user.getEmail())
                .dateOfBirth(user.getDateOfBirth())
                .salesNotification(user.getSalesNotification())
                .newArrivalsNotification(user.getNewArrivalsNotification())
                .deliveryStatusNotification(user.getDeliveryStatusNotification())
                .build();
    }
}
