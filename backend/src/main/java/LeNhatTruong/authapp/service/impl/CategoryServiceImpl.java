package LeNhatTruong.authapp.service.impl;

import LeNhatTruong.authapp.entity.Category;
import LeNhatTruong.authapp.repository.CategoryRepository;
import LeNhatTruong.authapp.service.CategoryService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
@RequiredArgsConstructor
public class CategoryServiceImpl implements CategoryService {
    private final CategoryRepository categoryRepository;

    @Override
    public List<Category> getAllCategories() {
        return categoryRepository.findAll();
    }
}
