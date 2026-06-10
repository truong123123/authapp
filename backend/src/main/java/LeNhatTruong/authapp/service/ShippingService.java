package LeNhatTruong.authapp.service;

import LeNhatTruong.authapp.entity.ShippingRate;
import LeNhatTruong.authapp.entity.ShippingZone;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface ShippingService {
    List<ShippingRate> getAllShippingRates();
    Optional<ShippingRate> getShippingRateById(UUID id);
    ShippingRate saveShippingRate(ShippingRate shippingRate);
    ShippingRate updateShippingRate(ShippingRate shippingRate);
    void deleteShippingRate(UUID id);

    List<ShippingZone> getAllShippingZones();
    Optional<ShippingZone> getShippingZoneById(UUID id);
    ShippingZone saveShippingZone(ShippingZone shippingZone);
    ShippingZone updateShippingZone(ShippingZone shippingZone);
    void deleteShippingZone(UUID id);
}
