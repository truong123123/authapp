package LeNhatTruong.authapp.repository;

import LeNhatTruong.authapp.entity.Coupon;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CouponRepository extends JpaRepository<Coupon, java.util.UUID> {
    java.util.Optional<Coupon> findByCode(String code);
}
