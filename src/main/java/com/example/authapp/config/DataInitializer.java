package com.example.authapp.config;

import com.example.authapp.entity.Product;
import com.example.authapp.entity.Tag;
import com.example.authapp.repository.ProductRepository;
import com.example.authapp.repository.TagRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Component
@RequiredArgsConstructor
@Slf4j
public class DataInitializer implements CommandLineRunner {

        private final ProductRepository productRepository;
        private final TagRepository tagRepository;

        @Override
        public void run(String... args) throws Exception {
                // Ensure tags exist
                Tag tagNew = tagRepository.findByTagName("NEW")
                                .orElseGet(() -> tagRepository.save(Tag.builder().tagName("NEW").build()));

                Tag tagSale = tagRepository.findByTagName("SALE")
                                .orElseGet(() -> tagRepository.save(Tag.builder().tagName("SALE").build()));

                Tag tagTops = tagRepository.findByTagName("TOPS")
                                .orElseGet(() -> tagRepository.save(Tag.builder().tagName("TOPS").build()));

                // Initialize basic products if empty
                if (productRepository.count() == 0) {
                        log.info("Initializing basic product and tag data...");
                        Product p1 = Product.builder()
                                        .productName("Evening Dress")
                                        .brandName("Dorothy Perkins")
                                        .slug("evening-dress")
                                        .imageUrl("/images/product1.jpg")
                                        .salePrice(12.0)
                                        .comparePrice(15.0)
                                        .quantity(50)
                                        .shortDescription("Đầm dạ hội thanh lịch dáng hồng")
                                        .productDescription(
                                                        "Đầm dạ hội phong cách thanh lịch, chất liệu mát mẻ phù hợp cho mùa hè.")
                                        .productType("simple")
                                        .published(true)
                                        .ratingAverage(5.0)
                                        .reviewCount(10)
                                        .tags(new HashSet<>(Set.of(tagSale)))
                                        .build();

                        Product p2 = Product.builder()
                                        .productName("Sport Dress")
                                        .brandName("Sitlly")
                                        .slug("sport-dress")
                                        .imageUrl("/images/product2.jpg")
                                        .salePrice(19.0)
                                        .comparePrice(22.0)
                                        .quantity(30)
                                        .shortDescription("Đầm thể thao năng động co giãn")
                                        .productDescription(
                                                        "Đầm thể thao dáng suông dài năng động, chất liệu cotton co giãn cao cấp.")
                                        .productType("simple")
                                        .published(true)
                                        .ratingAverage(5.0)
                                        .reviewCount(10)
                                        .tags(new HashSet<>(Set.of(tagSale)))
                                        .build();

                        Product p3 = Product.builder()
                                        .productName("Oversize T-Shirt")
                                        .brandName("GUCCI")
                                        .slug("oversize-tshirt-gucci")
                                        .imageUrl("/images/product3.jpg")
                                        .salePrice(650.0)
                                        .comparePrice(0.0)
                                        .quantity(15)
                                        .shortDescription("Áo thun form rộng Gucci họa tiết cao cấp")
                                        .productDescription(
                                                        "Áo thun form rộng cao cấp từ thương hiệu Gucci thời trang phong cách.")
                                        .productType("simple")
                                        .published(true)
                                        .ratingAverage(4.5)
                                        .reviewCount(8)
                                        .tags(new HashSet<>(Set.of(tagNew)))
                                        .build();

                        productRepository.save(p1);
                        productRepository.save(p2);
                        productRepository.save(p3);
                }

                // Check and initialize TOPS products if they don't exist
                if (productRepository.findByTagsTagNameIgnoreCase("TOPS").isEmpty() ||
                    productRepository.findByTagsTagNameIgnoreCase("TOPS").stream().noneMatch(p -> p.getProductName().equals("T-Shirt SPANISH"))) {
                        log.info("Initializing/Reloading TOPS product data to match latest mockup screenshots...");
                        
                        // Delete old ones first
                        List<Product> oldTops = productRepository.findByTagsTagNameIgnoreCase("TOPS");
                        if (!oldTops.isEmpty()) {
                                productRepository.deleteAll(oldTops);
                        }

                        Product p4 = Product.builder()
                                        .productName("T-Shirt SPANISH")
                                        .brandName("Mango")
                                        .slug("t-shirt-spanish-mango")
                                        .imageUrl("/images/top1.jpg")
                                        .salePrice(9.0)
                                        .comparePrice(0.0)
                                        .quantity(20)
                                        .shortDescription("Áo thun T-Shirt SPANISH Mango")
                                        .productDescription("Áo thun T-Shirt SPANISH Mango chất liệu cotton mềm mại thoải mái.")
                                        .productType("simple")
                                        .published(true)
                                        .ratingAverage(4.0)
                                        .reviewCount(3)
                                        .tags(new HashSet<>(Set.of(tagTops, tagNew)))
                                        .build();

                        Product p5 = Product.builder()
                                        .productName("Blouse")
                                        .brandName("Dorothy Perkins")
                                        .slug("blouse-dorothy-perkins")
                                        .imageUrl("/images/top2.jpg")
                                        .salePrice(14.0)
                                        .comparePrice(21.0) // 14$ vs 21$ (approx -20% or 33% off)
                                        .quantity(15)
                                        .shortDescription("Áo blouse Dororthy nữ tính thanh lịch")
                                        .productDescription("Áo blouse Dorothy Perkins chất liệu voan nhẹ mềm mại nữ tính.")
                                        .productType("simple")
                                        .published(true)
                                        .ratingAverage(5.0)
                                        .reviewCount(10)
                                        .tags(new HashSet<>(Set.of(tagTops, tagSale)))
                                        .build();

                        Product p6 = Product.builder()
                                        .productName("Shirt")
                                        .brandName("Mango")
                                        .slug("shirt-mango")
                                        .imageUrl("/images/top3.jpg")
                                        .salePrice(9.0)
                                        .comparePrice(0.0)
                                        .quantity(50)
                                        .shortDescription("Áo sơ mi Mango cơ bản")
                                        .productDescription("Áo sơ mi nữ Mango kiểu dáng basic dễ phối đồ.")
                                        .productType("simple")
                                        .published(true)
                                        .ratingAverage(0.0)
                                        .reviewCount(0)
                                        .tags(new HashSet<>(Set.of(tagTops, tagNew)))
                                        .build();

                        Product p7 = Product.builder()
                                        .productName("Light blouse")
                                        .brandName("Dorothy Perkins")
                                        .slug("light-blouse-dorothy-perkins")
                                        .imageUrl("/images/top4.jpg")
                                        .salePrice(14.0)
                                        .comparePrice(21.0)
                                        .quantity(25)
                                        .shortDescription("Áo blouse nhẹ Dorothy Perkins")
                                        .productDescription("Áo blouse mỏng nhẹ Dorothy Perkins phong cách nhẹ nhàng.")
                                        .productType("simple")
                                        .published(true)
                                        .ratingAverage(5.0)
                                        .reviewCount(10)
                                        .tags(new HashSet<>(Set.of(tagTops, tagSale)))
                                        .build();

                        productRepository.save(p4);
                        productRepository.save(p5);
                        productRepository.save(p6);
                        productRepository.save(p7);
                        log.info("TOPS product data initialized successfully.");
                }
        }
}
