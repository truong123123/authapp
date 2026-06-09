package com.example.authapp.service.impl;

import com.example.authapp.entity.ShippingRate;
import com.example.authapp.entity.ShippingZone;
import com.example.authapp.repository.ShippingRateRepository;
import com.example.authapp.repository.ShippingZoneRepository;
import com.example.authapp.service.ShippingService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class ShippingServiceImpl implements ShippingService {
    private final ShippingRateRepository shippingRateRepository;
    private final ShippingZoneRepository shippingZoneRepository;

    @Override
    public List<ShippingRate> getAllShippingRates() {
        return shippingRateRepository.findAll();
    }

    @Override
    public Optional<ShippingRate> getShippingRateById(UUID id) {
        return shippingRateRepository.findById(id);
    }

    @Override
    public ShippingRate saveShippingRate(ShippingRate shippingRate) {
        return shippingRateRepository.save(shippingRate);
    }

    @Override
    public ShippingRate updateShippingRate(ShippingRate shippingRate) {
        return shippingRateRepository.save(shippingRate);
    }

    @Override
    public void deleteShippingRate(UUID id) {
        shippingRateRepository.deleteById(id);
    }

    @Override
    public List<ShippingZone> getAllShippingZones() {
        return shippingZoneRepository.findAll();
    }

    @Override
    public Optional<ShippingZone> getShippingZoneById(UUID id) {
        return shippingZoneRepository.findById(id);
    }

    @Override
    public ShippingZone saveShippingZone(ShippingZone shippingZone) {
        return shippingZoneRepository.save(shippingZone);
    }

    @Override
    public ShippingZone updateShippingZone(ShippingZone shippingZone) {
        return shippingZoneRepository.save(shippingZone);
    }

    @Override
    public void deleteShippingZone(UUID id) {
        shippingZoneRepository.deleteById(id);
    }
}
