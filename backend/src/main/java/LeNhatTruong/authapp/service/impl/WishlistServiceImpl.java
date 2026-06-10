package LeNhatTruong.authapp.service.impl;

import LeNhatTruong.authapp.entity.Wishlist;
import LeNhatTruong.authapp.entity.WishlistId;
import LeNhatTruong.authapp.repository.WishlistRepository;
import LeNhatTruong.authapp.service.WishlistService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class WishlistServiceImpl implements WishlistService {
    private final WishlistRepository wishlistRepository;

    @Override
    public List<Wishlist> getAllWishlists() {
        return wishlistRepository.findAll();
    }

    @Override
    public Optional<Wishlist> getWishlistById(WishlistId id) {
        return wishlistRepository.findById(id);
    }

    @Override
    public Wishlist saveWishlist(Wishlist wishlist) {
        return wishlistRepository.save(wishlist);
    }

    @Override
    public Wishlist updateWishlist(Wishlist wishlist) {
        return wishlistRepository.save(wishlist);
    }

    @Override
    public void deleteWishlist(WishlistId id) {
        wishlistRepository.deleteById(id);
    }
}
