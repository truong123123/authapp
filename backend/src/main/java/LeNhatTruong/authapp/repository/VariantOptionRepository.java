package LeNhatTruong.authapp.repository;

import LeNhatTruong.authapp.entity.VariantOption;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface VariantOptionRepository extends JpaRepository<VariantOption, java.util.UUID> {
}
