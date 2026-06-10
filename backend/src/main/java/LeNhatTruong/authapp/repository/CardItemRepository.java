package LeNhatTruong.authapp.repository;

import LeNhatTruong.authapp.entity.CardItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CardItemRepository extends JpaRepository<CardItem, java.util.UUID> {
}
