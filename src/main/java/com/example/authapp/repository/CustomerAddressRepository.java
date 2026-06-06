package com.example.authapp.repository;

import com.example.authapp.entity.CustomerAddress;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CustomerAddressRepository extends JpaRepository<CustomerAddress, java.util.UUID> {
    long countByCustomerUserId(Long userId);
    java.util.List<CustomerAddress> findByCustomerUserId(Long userId);
}
