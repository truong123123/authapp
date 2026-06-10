package LeNhatTruong.authapp.service;

import LeNhatTruong.authapp.entity.Coupon;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface CouponService {
    List<Coupon> getAllCoupons();
    Optional<Coupon> getCouponById(UUID id);
    Coupon saveCoupon(Coupon coupon);
    Coupon updateCoupon(Coupon coupon);
    void deleteCoupon(UUID id);
}
