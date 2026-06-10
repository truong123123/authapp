package LeNhatTruong.authapp.mapper;

import LeNhatTruong.authapp.entity.Category;
import LeNhatTruong.authapp.dto.response.CategoryDTO;
import org.springframework.stereotype.Component;

@Component
public class CategoryMapper {

    public CategoryDTO toDTO(Category category) {
        if (category == null) {
            return null;
        }
        return CategoryDTO.builder()
                .id(category.getId())
                .categoryName(category.getCategoryName())
                .categoryDescription(category.getCategoryDescription())
                .icon(category.getIcon())
                .image(category.getImage())
                .placeholder(category.getPlaceholder())
                .active(category.getActive() != null ? category.getActive() : true)
                .parentId(category.getParent() != null ? category.getParent().getId() : null)
                .build();
    }
}
