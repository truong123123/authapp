package LeNhatTruong.authapp.repository;

import LeNhatTruong.authapp.entity.ShippingRate;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ShippingRateRepository extends JpaRepository<ShippingRate, java.util.UUID> {
}
