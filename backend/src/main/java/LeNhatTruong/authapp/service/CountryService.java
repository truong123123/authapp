package LeNhatTruong.authapp.service;

import LeNhatTruong.authapp.entity.Country;
import java.util.List;
import java.util.Optional;

public interface CountryService {
    List<Country> getAllCountries();
    Optional<Country> getCountryById(Integer id);
    Country saveCountry(Country country);
    Country updateCountry(Country country);
    void deleteCountry(Integer id);
}
