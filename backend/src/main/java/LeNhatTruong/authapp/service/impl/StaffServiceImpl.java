package LeNhatTruong.authapp.service.impl;

import LeNhatTruong.authapp.entity.StaffAccount;
import LeNhatTruong.authapp.entity.StaffRole;
import LeNhatTruong.authapp.repository.StaffAccountRepository;
import LeNhatTruong.authapp.repository.StaffRoleRepository;
import LeNhatTruong.authapp.service.StaffService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class StaffServiceImpl implements StaffService {
    private final StaffAccountRepository staffAccountRepository;
    private final StaffRoleRepository staffRoleRepository;

    @Override
    public List<StaffAccount> getAllStaffAccounts() {
        return staffAccountRepository.findAll();
    }

    @Override
    public Optional<StaffAccount> getStaffAccountById(UUID id) {
        return staffAccountRepository.findById(id);
    }

    @Override
    public StaffAccount saveStaffAccount(StaffAccount staffAccount) {
        return staffAccountRepository.save(staffAccount);
    }

    @Override
    public StaffAccount updateStaffAccount(StaffAccount staffAccount) {
        return staffAccountRepository.save(staffAccount);
    }

    @Override
    public void deleteStaffAccount(UUID id) {
        staffAccountRepository.deleteById(id);
    }

    @Override
    public List<StaffRole> getAllStaffRoles() {
        return staffRoleRepository.findAll();
    }

    @Override
    public Optional<StaffRole> getStaffRoleById(UUID id) {
        return staffRoleRepository.findById(id);
    }

    @Override
    public StaffRole saveStaffRole(StaffRole staffRole) {
        return staffRoleRepository.save(staffRole);
    }

    @Override
    public StaffRole updateStaffRole(StaffRole staffRole) {
        return staffRoleRepository.save(staffRole);
    }

    @Override
    public void deleteStaffRole(UUID id) {
        staffRoleRepository.deleteById(id);
    }
}
