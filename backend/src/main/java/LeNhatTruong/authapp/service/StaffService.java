package LeNhatTruong.authapp.service;

import LeNhatTruong.authapp.entity.StaffAccount;
import LeNhatTruong.authapp.entity.StaffRole;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface StaffService {
    List<StaffAccount> getAllStaffAccounts();
    Optional<StaffAccount> getStaffAccountById(UUID id);
    StaffAccount saveStaffAccount(StaffAccount staffAccount);
    StaffAccount updateStaffAccount(StaffAccount staffAccount);
    void deleteStaffAccount(UUID id);

    List<StaffRole> getAllStaffRoles();
    Optional<StaffRole> getStaffRoleById(UUID id);
    StaffRole saveStaffRole(StaffRole staffRole);
    StaffRole updateStaffRole(StaffRole staffRole);
    void deleteStaffRole(UUID id);
}
