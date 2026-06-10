package LeNhatTruong.authapp.service;

import LeNhatTruong.authapp.entity.Supplier;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface SupplierService {
    List<Supplier> getAllSuppliers();
    Optional<Supplier> getSupplierById(UUID id);
    Supplier saveSupplier(Supplier supplier);
    Supplier updateSupplier(Supplier supplier);
    void deleteSupplier(UUID id);
}
