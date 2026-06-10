package LeNhatTruong.authapp.repository;

import LeNhatTruong.authapp.entity.Sell;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface SellRepository extends JpaRepository<Sell, java.util.UUID> {
}
