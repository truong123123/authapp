package LeNhatTruong.authapp.repository;

import LeNhatTruong.authapp.entity.Wishlist;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import LeNhatTruong.authapp.entity.WishlistId;

@Repository
public interface WishlistRepository extends JpaRepository<Wishlist, WishlistId> {
}
