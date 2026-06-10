package LeNhatTruong.authapp.repository;

import LeNhatTruong.authapp.entity.ProductAttribute;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ProductAttributeRepository extends JpaRepository<ProductAttribute, java.util.UUID> {
}
