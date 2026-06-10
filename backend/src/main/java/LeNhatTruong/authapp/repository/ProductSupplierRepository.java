package LeNhatTruong.authapp.repository;

import LeNhatTruong.authapp.entity.ProductSupplier;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import LeNhatTruong.authapp.entity.ProductSupplierId;

@Repository
public interface ProductSupplierRepository extends JpaRepository<ProductSupplier, ProductSupplierId> {
}
