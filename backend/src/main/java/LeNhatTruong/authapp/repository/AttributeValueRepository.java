package LeNhatTruong.authapp.repository;

import LeNhatTruong.authapp.entity.AttributeValue;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface AttributeValueRepository extends JpaRepository<AttributeValue, java.util.UUID> {
}
