package LeNhatTruong.authapp.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CategoryDTO {
    private UUID id;
    private String categoryName;
    private String categoryDescription;
    private String icon;
    private String image;
    private String placeholder;
    private boolean active;
}
