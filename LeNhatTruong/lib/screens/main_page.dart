import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/auth_provider.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../utils/constants.dart';
import 'login_screen.dart';
import 'product_detail_screen.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  int _selectedGenderIndex = 0;
  String _currentShopView = 'main'; // 'main' or 'sub_clothes'
  final _productService = ProductService();
  List<Product> _saleProducts = [];
  List<Product> _newProducts = [];
  bool _isLoading = true;
  List<Product> _topsProducts = [];
  bool _isTopsLoading = false;
  bool _isGridView = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final sales = await _productService.getSaleProducts();
      final news = await _productService.getNewProducts();
      setState(() {
        _saleProducts = sales;
        _newProducts = news;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('>>> Error loading products in UI: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final scale = (screenWidth / 375).clamp(0.5, 1.5).toDouble();
        final bannerH = (536 * scale).clamp(280, 600.0).toDouble(); // Tỷ lệ dài như thiết kế ảnh 1
        final cardW = (150 * scale).clamp(120, 240.0).toDouble();
        final cardH = (260 * scale).clamp(200, 380.0).toDouble();

        return Scaffold(
          backgroundColor: const Color(0xFFF9F9F9),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: IndexedStack(
                    index: _currentIndex,
                    children: [
                      _buildShopTab(scale: scale, bannerH: bannerH, cardW: cardW, cardH: cardH),
                      _buildCategoriesTab(scale: scale),
                      _buildPlaceholderTab(scale: scale, title: 'Your Bag', icon: Icons.shopping_cart_outlined),
                      _buildPlaceholderTab(scale: scale, title: 'Favorites', icon: Icons.favorite_border),
                      _ProfileTab(scale: scale),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: _BottomBar(
            scale: scale,
            selectedIndex: _currentIndex,
            onTap: (i) => setState(() => _currentIndex = i),
          ),
        );
      },
    );
  }

  Widget _buildShopTab({
    required double scale,
    required double bannerH,
    required double cardW,
    required double cardH,
  }) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFFDB3022),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadProducts,
      color: const Color(0xFFDB3022),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Slide/Banner
            _BigBanner(height: bannerH, scale: scale),

            // Section 1: Sale
            if (_saleProducts.isNotEmpty) ...[
              _SectionHeader(
                scale: scale,
                title: 'Sale',
                subtitle: 'Super summer sale',
                onViewAll: () {},
              ),
              SizedBox(height: 12 * scale),
              SizedBox(
                height: cardH,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(left: 14 * scale),
                  itemCount: _saleProducts.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(right: 16 * scale),
                      child: _ProductCard(
                        width: cardW,
                        height: cardH,
                        scale: scale,
                        product: _saleProducts[index],
                      ),
                    );
                  },
                ),
              ),
            ],

            SizedBox(height: 8 * scale),

            // Section 2: New
            _SectionHeader(
              scale: scale,
              title: 'New',
              subtitle: "You've never seen it before!",
              onViewAll: () {},
            ),
            SizedBox(height: 12 * scale),
            _newProducts.isEmpty
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0 * scale, vertical: 8 * scale),
                    child: Text(
                      'Không có sản phẩm mới nào',
                      style: GoogleFonts.inter(color: Colors.grey, fontSize: 14 * scale),
                    ),
                  )
                : SizedBox(
                    height: cardH,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.only(left: 14 * scale),
                      itemCount: _newProducts.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(right: 4 * scale),
                          child: _ProductCard(
                            width: cardW,
                            height: cardH,
                            scale: scale,
                            product: _newProducts[index],
                          ),
                        );
                      },
                    ),
                  ),
            SizedBox(height: 40 * scale),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderTab({required double scale, required String title, required IconData icon}) {
    return Container(
      color: const Color(0xFFF9F9F9),
      width: double.infinity,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64 * scale, color: const Color(0xFFDB3022).withOpacity(0.5)),
            SizedBox(height: 16 * scale),
            Text(
              title,
              style: GoogleFonts.outfit(
                fontSize: 24 * scale,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF222222),
              ),
            ),
            SizedBox(height: 8 * scale),
            Text(
              'Tính năng đang được cập nhật',
              style: GoogleFonts.inter(
                fontSize: 14 * scale,
                color: const Color(0xFF9B9B9B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesTab({required double scale}) {
    if (_currentShopView == 'sub_clothes') {
      return _buildSubClothesView(scale: scale);
    }
    if (_currentShopView == 'sub_tops') {
      return _buildTopsView(scale: scale);
    }

    final List<Map<String, String>> categories = [
      {
        'title': 'New',
        'image': '${AppConstants.baseUrl}/images/cat_new.jpg',
      },
      {
        'title': 'Clothes',
        'image': '${AppConstants.baseUrl}/images/cat_clothes.jpg',
      },
      {
        'title': 'Shoes',
        'image': '${AppConstants.baseUrl}/images/cat_shoes.jpg',
      },
      {
        'title': 'Accesories',
        'image': '${AppConstants.baseUrl}/images/cat_accessories.jpg',
      },
    ];

    return Container(
      color: const Color(0xFFF9F9F9),
      child: Column(
        children: [
          // AppBar Categories
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 4 * scale, vertical: 8 * scale),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios_new, color: const Color(0xFF222222), size: 18 * scale),
                  onPressed: () {
                    setState(() {
                      _currentIndex = 0; // Go back to Home
                    });
                  },
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Categories',
                      style: GoogleFonts.outfit(
                        color: const Color(0xFF222222),
                        fontWeight: FontWeight.w700,
                        fontSize: 18 * scale,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search, color: const Color(0xFF222222), size: 24 * scale),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          // Gender tabs
          Container(
            color: Colors.white,
            child: Row(
              children: [
                _buildGenderTab('Women', 0, scale),
                _buildGenderTab('Men', 1, scale),
                _buildGenderTab('Kids', 2, scale),
              ],
            ),
          ),
          // Divider below tabs
          Container(
            height: 1,
            color: const Color(0x0D000000),
          ),
          // Scrollable area
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16 * scale, vertical: 16 * scale),
              child: Column(
                children: [
                  // Summer Sales banner
                  _buildSummerSaleBanner(scale),
                  SizedBox(height: 16 * scale),
                  // Categories list
                  ...categories.map((cat) => Padding(
                        padding: EdgeInsets.only(bottom: 16 * scale),
                        child: _buildCategoryCard(cat['title']!, cat['image']!, scale),
                      )),
                  SizedBox(height: 24 * scale),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderTab(String text, int index, double scale) {
    final isSelected = _selectedGenderIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedGenderIndex = index;
          });
        },
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12 * scale),
              child: Text(
                text,
                style: GoogleFonts.inter(
                  fontSize: 16 * scale,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? const Color(0xFF222222) : const Color(0xFF9B9B9B),
                ),
              ),
            ),
            Container(
              height: 3 * scale,
              width: double.infinity,
              color: isSelected ? const Color(0xFFDB3022) : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummerSaleBanner(double scale) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFDB3022),
        borderRadius: BorderRadius.circular(8 * scale),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFDB3022).withOpacity(0.12),
            blurRadius: 8 * scale,
            offset: Offset(0, 4 * scale),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(vertical: 26 * scale),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'SUMMER SALES',
            style: GoogleFonts.outfit(
              fontSize: 24 * scale,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 1.0,
            ),
          ),
          SizedBox(height: 4 * scale),
          Text(
            'Up to 50% off',
            style: GoogleFonts.inter(
              fontSize: 14 * scale,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String title, String imageUrl, double scale) {
    return GestureDetector(
      onTap: () {
        if (title.toLowerCase() == 'clothes') {
          setState(() {
            _currentShopView = 'sub_clothes';
          });
        }
      },
      child: Container(
        height: 100 * scale,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8 * scale),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6 * scale,
              offset: Offset(0, 2 * scale),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8 * scale),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 24 * scale),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      title,
                      style: GoogleFonts.outfit(
                        fontSize: 18 * scale,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF222222),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Image.network(
                  imageUrl,
                  height: 100 * scale,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFFE0E0E0),
                      child: const Icon(Icons.image, color: Colors.grey),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubClothesView({required double scale}) {
    final List<String> subCategories = [
      'Tops',
      'Shirts & Blouses',
      'Cardigans & Sweaters',
      'Knitwear',
      'Blazers',
      'Outerwear',
      'Pants',
      'Jeans',
      'Shorts',
      'Skirts',
      'Dresses',
    ];

    return Container(
      color: const Color(0xFFF9F9F9),
      child: Column(
        children: [
          // AppBar Categories
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 4 * scale, vertical: 8 * scale),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios_new, color: const Color(0xFF222222), size: 18 * scale),
                  onPressed: () {
                    setState(() {
                      _currentShopView = 'main'; // Go back to main categories
                    });
                  },
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Categories',
                      style: GoogleFonts.outfit(
                        color: const Color(0xFF222222),
                        fontWeight: FontWeight.w700,
                        fontSize: 18 * scale,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search, color: const Color(0xFF222222), size: 24 * scale),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16 * scale, vertical: 16 * scale),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // VIEW ALL ITEMS button
                  SizedBox(
                    width: double.infinity,
                    height: 48 * scale,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDB3022),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24 * scale),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'VIEW ALL ITEMS',
                        style: GoogleFonts.inter(
                          fontSize: 14 * scale,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16 * scale),
                  Text(
                    'Choose category',
                    style: GoogleFonts.inter(
                      fontSize: 14 * scale,
                      color: const Color(0xFF9B9B9B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8 * scale),
                  
                  // Sub-category Items List
                  ...subCategories.map((subCat) => _buildSubCategoryRow(subCat, scale)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubCategoryRow(String title, double scale) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0x0A000000),
            width: 1,
          ),
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 8 * scale, vertical: 4 * scale),
        title: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 16 * scale,
            color: const Color(0xFF222222),
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: () {
          if (title.toLowerCase() == 'tops') {
            setState(() {
              _currentShopView = 'sub_tops';
            });
            _loadTopsProducts();
          }
        },
      ),
    );
  }

  Future<void> _loadTopsProducts() async {
    setState(() {
      _isTopsLoading = true;
    });
    try {
      final products = await _productService.getProductsByTag('TOPS');
      setState(() {
        _topsProducts = products;
        _isTopsLoading = false;
      });
    } catch (e) {
      setState(() {
        _isTopsLoading = false;
      });
      print('>>> Error loading tops products: $e');
    }
  }

  Widget _buildTopsView({required double scale}) {
    final List<String> tags = ['T-shirts', 'Crop tops', 'Sleeveless', 'Shirts'];

    return Container(
      color: const Color(0xFFF9F9F9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Custom AppBar
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 4 * scale, vertical: 8 * scale),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios_new, color: const Color(0xFF222222), size: 18 * scale),
                  onPressed: () {
                    setState(() {
                      _currentShopView = 'sub_clothes'; // Go back to Clothes subcategories
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.search, color: const Color(0xFF222222), size: 24 * scale),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          
          // Large Title
          Padding(
            padding: EdgeInsets.fromLTRB(16 * scale, 12 * scale, 16 * scale, 12 * scale),
            child: Text(
              "Women's tops",
              style: GoogleFonts.outfit(
                fontSize: 34 * scale,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF222222),
              ),
            ),
          ),

          // Horizontal Tags/Chips
          SizedBox(
            height: 36 * scale,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(left: 16 * scale),
              itemCount: tags.length,
              itemBuilder: (context, index) {
                final tag = tags[index];
                return Padding(
                  padding: EdgeInsets.only(right: 8 * scale),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF222222),
                      borderRadius: BorderRadius.circular(29 * scale),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16 * scale),
                    alignment: Alignment.center,
                    child: Text(
                      tag,
                      style: GoogleFonts.inter(
                        fontSize: 14 * scale,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 12 * scale),

          // Filters and Sorting Bar
          Container(
            color: const Color(0xFFF9F9F9),
            padding: EdgeInsets.symmetric(horizontal: 16 * scale, vertical: 8 * scale),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Filters
                Row(
                  children: [
                    Icon(Icons.filter_list, size: 18 * scale, color: const Color(0xFF222222)),
                    SizedBox(width: 6 * scale),
                    Text(
                      'Filters',
                      style: GoogleFonts.inter(
                        fontSize: 11 * scale,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF222222),
                      ),
                    ),
                  ],
                ),
                // Sorting
                Row(
                  children: [
                    Icon(Icons.swap_vert, size: 18 * scale, color: const Color(0xFF222222)),
                    SizedBox(width: 6 * scale),
                    Text(
                      'Price: lowest to high',
                      style: GoogleFonts.inter(
                        fontSize: 11 * scale,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF222222),
                      ),
                    ),
                  ],
                ),
                // Layout view switch icon
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isGridView = !_isGridView;
                    });
                  },
                  child: Icon(
                    _isGridView ? Icons.view_list : Icons.view_module,
                    size: 20 * scale,
                    color: const Color(0xFF222222),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8 * scale),

          // Product list
          Expanded(
            child: _isTopsLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFDB3022),
                    ),
                  )
                : _topsProducts.isEmpty
                    ? Center(
                        child: Text(
                          'Không tìm thấy sản phẩm nào',
                          style: GoogleFonts.inter(fontSize: 14 * scale, color: Colors.grey),
                        ),
                      )
                    : _isGridView
                        ? GridView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 16 * scale, vertical: 8 * scale),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16 * scale,
                              mainAxisSpacing: 26 * scale,
                              childAspectRatio: 0.59,
                            ),
                            itemCount: _topsProducts.length,
                            itemBuilder: (context, index) {
                              return LayoutBuilder(
                                builder: (context, constraints) {
                                  return _ProductCard(
                                    width: constraints.maxWidth,
                                    height: constraints.maxHeight,
                                    scale: scale,
                                    product: _topsProducts[index],
                                  );
                                },
                              );
                            },
                          )
                        : ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 16 * scale),
                            itemCount: _topsProducts.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: 24 * scale),
                                child: _buildTopsProductRowCard(_topsProducts[index], scale),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopsProductRowCard(Product product, double scale) {
    final photoW = 104 * scale;
    final photoH = 104 * scale;
    final String fullImageUrl = product.imageUrl != null
        ? (product.imageUrl!.startsWith('http')
            ? product.imageUrl!
            : '${AppConstants.baseUrl}${product.imageUrl}')
        : '';

    final bool isFavorited = product.productName == 'T-shirt';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 104 * scale,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Main Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8 * scale),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 6 * scale,
                    offset: Offset(0, 2 * scale),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Product Image
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8 * scale),
                      bottomLeft: Radius.circular(8 * scale),
                    ),
                    child: fullImageUrl.isNotEmpty
                        ? Image.network(
                            fullImageUrl,
                            width: photoW,
                            height: photoH,
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: photoW,
                                height: photoH,
                                color: const Color(0xFFC4C4C4),
                                child: const Icon(Icons.image, color: Colors.white),
                              );
                            },
                          )
                        : Container(
                            width: photoW,
                            height: photoH,
                            color: const Color(0xFFC4C4C4),
                          ),
                  ),
                  
                  // Product Info
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12 * scale, vertical: 8 * scale),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.productName,
                                style: GoogleFonts.outfit(
                                  fontSize: 16 * scale,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF222222),
                                ),
                              ),
                              SizedBox(height: 2 * scale),
                              Text(
                                product.brandName ?? '',
                                style: GoogleFonts.inter(
                                  fontSize: 11 * scale,
                                  color: const Color(0xFF9B9B9B),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          
                          // Rating and Review Count
                          Row(
                            children: [
                              ...List.generate(5, (i) {
                                final isFilled = i < (product.ratingAverage ?? 0).floor();
                                return Icon(
                                  Icons.star,
                                  size: 13 * scale,
                                  color: isFilled ? const Color(0xFFFFBA49) : const Color(0xFF9B9B9B),
                                );
                              }),
                              SizedBox(width: 4 * scale),
                              Text(
                                '(${product.reviewCount ?? 0})',
                                style: GoogleFonts.inter(
                                  fontSize: 10 * scale,
                                  color: const Color(0xFF9B9B9B),
                                ),
                              ),
                            ],
                          ),
                          
                          // Price
                          Text(
                            '${product.salePrice.round()}\$',
                            style: GoogleFonts.inter(
                              fontSize: 14 * scale,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF222222),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Favorite button floating on bottom-right corner
            Positioned(
              right: 0,
              bottom: -12 * scale,
              child: GestureDetector(
                onTap: () {
                  // Favorite action mockup
                },
                child: Container(
                  width: 36 * scale,
                  height: 36 * scale,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x1F000000),
                        blurRadius: 4 * scale,
                        offset: Offset(0, 4 * scale),
                      ),
                    ],
                  ),
                  child: Icon(
                    isFavorited ? Icons.favorite : Icons.favorite_border,
                    size: 16 * scale,
                    color: isFavorited ? const Color(0xFFDB3022) : const Color(0xFF9B9B9B),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileTab extends StatelessWidget {
  final double scale;
  const _ProfileTab({required this.scale});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;
    final initials = _getInitials(user?.name);

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24 * scale),
        child: Column(
          children: [
            SizedBox(height: 32 * scale),
            Container(
              width: 327 * scale,
              padding: EdgeInsets.all(24 * scale),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFDB3022).withOpacity(0.15),
                    const Color(0xFFDB3022).withOpacity(0.08),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24 * scale),
                border: Border.all(
                  color: const Color(0xFFDB3022).withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  _buildAvatar(user?.avatarUrl, initials, scale),
                  SizedBox(width: 20 * scale),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.name ?? 'Người dùng',
                          style: GoogleFonts.outfit(
                            color: const Color(0xFF222222),
                            fontWeight: FontWeight.w700,
                            fontSize: 20 * scale,
                          ),
                        ),
                        SizedBox(height: 4 * scale),
                        Text(
                          user?.email ?? '—',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF9B9B9B),
                            fontSize: 14 * scale,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24 * scale),
            _infoItem(Icons.cloud_outlined, 'Provider', user?.provider.toUpperCase() ?? 'LOCAL', scale: scale),
            SizedBox(height: 32 * scale),
            SizedBox(
              width: 327 * scale,
              child: OutlinedButton.icon(
                onPressed: () => _logout(context),
                icon: Icon(Icons.logout_rounded, size: 18 * scale),
                label: Text(
                  'Đăng xuất',
                  style: GoogleFonts.inter(fontSize: 14 * scale, fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFDB3022),
                  side: const BorderSide(color: Color(0xFFDB3022), width: 1.5),
                  padding: EdgeInsets.symmetric(vertical: 14 * scale),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16 * scale),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(String? avatarUrl, String initials, double scale) {
    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      return Container(
        width: 72 * scale,
        height: 72 * scale,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20 * scale),
          border: Border.all(
            color: const Color(0xFFDB3022).withOpacity(0.3),
            width: 2,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18 * scale),
          child: Image.network(
            avatarUrl,
            width: 72 * scale,
            height: 72 * scale,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _buildInitialsAvatar(initials, scale),
            loadingBuilder: (_, child, progress) {
              if (progress == null) return child;
              return _buildInitialsAvatar(initials, scale);
            },
          ),
        ),
      );
    }
    return _buildInitialsAvatar(initials, scale);
  }

  Widget _buildInitialsAvatar(String initials, double scale) {
    return Container(
      width: 72 * scale,
      height: 72 * scale,
      decoration: BoxDecoration(
        color: const Color(0xFFDB3022),
        borderRadius: BorderRadius.circular(20 * scale),
      ),
      child: Center(
        child: Text(
          initials,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 24 * scale,
          ),
        ),
      ),
    );
  }

  String _getInitials(String? name) {
    if (name?.isNotEmpty != true) return '?';
    return name!
        .split(' ')
        .map((e) => e.isNotEmpty ? e[0].toUpperCase() : '')
        .take(2)
        .join();
  }

  Widget _infoItem(IconData icon, String label, String value, {required double scale}) {
    return Container(
      width: 327 * scale,
      padding: EdgeInsets.symmetric(horizontal: 20 * scale, vertical: 16 * scale),
      decoration: BoxDecoration(
        color: const Color(0xFFDB3022).withOpacity(0.06),
        borderRadius: BorderRadius.circular(16 * scale),
        border: Border.all(
          color: const Color(0xFFDB3022).withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40 * scale,
            height: 40 * scale,
            decoration: BoxDecoration(
              color: const Color(0xFFDB3022),
              borderRadius: BorderRadius.circular(12 * scale),
            ),
            child: Icon(icon, color: Colors.white, size: 20 * scale),
          ),
          SizedBox(width: 16 * scale),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  color: const Color(0xFF9B9B9B),
                  fontSize: 13 * scale,
                ),
              ),
              SizedBox(height: 2 * scale),
              Text(
                value,
                style: GoogleFonts.inter(
                  color: const Color(0xFF222222),
                  fontSize: 15 * scale,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Đăng xuất?', style: TextStyle(color: Color(0xFF222222))),
        content: const Text(
          'Bạn có chắc muốn đăng xuất không?',
          style: TextStyle(color: Color(0xFF9B9B9B)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Hủy', style: TextStyle(color: Color(0xFF9B9B9B))),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Đăng xuất', style: TextStyle(color: Color(0xFFDB3022))),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await context.read<AuthProvider>().logout();
      if (!context.mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }
}


// ─────────────────────────────────────────────────────────────
// Big Banner (Supporting swipe carousel between Main 1 and Main 2 styles)
// ─────────────────────────────────────────────────────────────

class _BigBanner extends StatefulWidget {
  final double height;
  final double scale;
  const _BigBanner({super.key, required this.height, required this.scale});

  @override
  State<_BigBanner> createState() => _BigBannerState();
}

class _BigBannerState extends State<_BigBanner> {
  int _activePage = 0;
  final _pageController = PageController();

  final List<Map<String, String>> _bannerItems = [
    {
      'image': '${AppConstants.baseUrl}/images/banner1.jpg',
      'title': 'Street\nclothes',
    },
    {
      'image': '${AppConstants.baseUrl}/images/banner2.jpg',
      'title': 'Fashion\nsale',
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: widget.height,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (page) => setState(() => _activePage = page),
            itemCount: _bannerItems.length,
            itemBuilder: (context, index) {
              final item = _bannerItems[index];
              return Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    item['image']!,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(color: const Color(0xFFC4C4C4));
                    },
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0x7F000000)],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 15 * widget.scale,
                    bottom: 60 * widget.scale,
                    child: Text(
                      item['title']!,
                      style: GoogleFonts.outfit(
                        fontSize: 44 * widget.scale,
                        height: 1.0,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        shadows: [
                          const Shadow(
                            offset: Offset(0, 2),
                            blurRadius: 6.0,
                            color: Color(0x3F000000),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          // Check button
          Positioned(
            left: 15 * widget.scale,
            bottom: 12 * widget.scale,
            child: SizedBox(
              width: 140 * widget.scale,
              height: 36 * widget.scale,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDB3022),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25 * widget.scale),
                  ),
                  elevation: 4,
                  shadowColor: const Color(0xFFD32626).withOpacity(0.25),
                ),
                child: Text(
                  'Check',
                  style: GoogleFonts.inter(
                    fontSize: 14 * widget.scale,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          // Page indicators
          Positioned(
            right: 15 * widget.scale,
            bottom: 24 * widget.scale,
            child: Row(
              children: List.generate(
                _bannerItems.length,
                (index) => Container(
                  margin: EdgeInsets.only(left: 6 * widget.scale),
                  width: 8 * widget.scale,
                  height: 8 * widget.scale,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _activePage == index
                        ? const Color(0xFFDB3022)
                        : Colors.white.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Section Header
// ─────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final double scale;
  final String title;
  final String subtitle;
  final VoidCallback onViewAll;

  const _SectionHeader({
    required this.scale,
    required this.title,
    required this.subtitle,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(14 * scale, 24 * scale, 14 * scale, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 34 * scale,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF222222),
                  height: 1.0,
                ),
              ),
              GestureDetector(
                onTap: onViewAll,
                child: Text(
                  'View all',
                  style: GoogleFonts.inter(
                    fontSize: 11 * scale,
                    color: const Color(0xFF222222),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4 * scale),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 11 * scale,
              color: const Color(0xFF9B9B9B),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Product Card
// ─────────────────────────────────────────────────────────────

class _ProductCard extends StatelessWidget {
  final double width;
  final double height;
  final double scale;
  final Product product;

  const _ProductCard({
    required this.width,
    required this.height,
    required this.scale,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final photoH = height * 0.68;
    final topNew = 8 * scale;
    final leftNew = 10 * scale;
    final topRating = photoH + 5 * scale;
    final topFav = photoH - 18 * scale;
    final topBrand = photoH + 24 * scale;
    final topName = photoH + 39 * scale;
    final topPrice = photoH + 60 * scale;

    // Check discount
    final bool isOnSale = product.comparePrice != null && product.comparePrice! > product.salePrice;
    int discountPercent = 0;
    if (isOnSale) {
      discountPercent = (((product.comparePrice! - product.salePrice) / product.comparePrice!) * 100).round();
    }

    // Check if it has NEW tag
    final bool isNew = product.tags.any((t) => t.tagName.toUpperCase() == 'NEW');

    final String fullImageUrl = product.imageUrl != null
        ? (product.imageUrl!.startsWith('http')
            ? product.imageUrl!
            : '${AppConstants.baseUrl}${product.imageUrl}')
        : '';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: width,
        height: height,
        child: Stack(
          children: [
            // Product photo
            Positioned(
              left: 0,
              top: 0,
              width: width,
              height: photoH,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8 * scale),
                child: fullImageUrl.isNotEmpty
                    ? Image.network(
                        fullImageUrl,
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: const Color(0xFFC4C4C4),
                            child: const Icon(Icons.image, color: Colors.white),
                          );
                        },
                      )
                    : Container(
                        color: const Color(0xFFC4C4C4),
                      ),
              ),
            ),
            // Badge
            if (isOnSale)
              Positioned(
                left: leftNew,
                top: topNew,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8 * scale, vertical: 4 * scale),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDB3022),
                    borderRadius: BorderRadius.circular(29 * scale),
                  ),
                  child: Center(
                    child: Text(
                      '-$discountPercent%',
                      style: GoogleFonts.inter(
                        fontSize: 11 * scale,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        height: 1.0,
                      ),
                    ),
                  ),
                ),
              )
            else if (isNew)
              Positioned(
                left: leftNew,
                top: topNew,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8 * scale, vertical: 4 * scale),
                  decoration: BoxDecoration(
                    color: const Color(0xFF222222),
                    borderRadius: BorderRadius.circular(29 * scale),
                  ),
                  child: Center(
                    child: Text(
                      'NEW',
                      style: GoogleFonts.inter(
                        fontSize: 11 * scale,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        height: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
            // Rating
            Positioned(
              left: 0,
              top: topRating,
              child: Row(
                children: [
                  ...List.generate(5, (i) {
                    final isFilled = i < (product.ratingAverage ?? 0).floor();
                    return Icon(
                      Icons.star,
                      size: 13 * scale,
                      color: isFilled ? const Color(0xFFFFBA49) : const Color(0xFF9B9B9B),
                    );
                  }),
                  SizedBox(width: 4 * scale),
                  Text(
                    '(${product.reviewCount ?? 0})',
                    style: GoogleFonts.inter(
                      fontSize: 10 * scale,
                      color: const Color(0xFF9B9B9B),
                    ),
                  ),
                ],
              ),
            ),
            // Favorite
            Positioned(
              right: 0,
              top: topFav,
              child: GestureDetector(
                onTap: () {
                  // Favorite Action
                },
                child: Container(
                  width: 36 * scale,
                  height: 36 * scale,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x14000000),
                        blurRadius: 4 * scale,
                        offset: Offset(0, 4 * scale),
                      ),
                    ],
                  ),
                  child: Icon(Icons.favorite_border, size: 16 * scale, color: const Color(0xFF9B9B9B)),
                ),
              ),
            ),
            // Brand
            Positioned(
              left: 1 * scale,
              top: topBrand,
              child: Text(
                product.brandName ?? '',
                style: GoogleFonts.inter(
                  fontSize: 11 * scale,
                  color: const Color(0xFF9B9B9B),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            // Name
            Positioned(
              left: 1 * scale,
              top: topName,
              child: Text(
                product.productName,
                style: GoogleFonts.outfit(
                  fontSize: 16 * scale,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF222222),
                ),
              ),
            ),
            // Price
            Positioned(
              left: 1 * scale,
              top: topPrice,
              child: isOnSale
                  ? Row(
                      children: [
                        Text(
                          '${product.comparePrice!.round()}\$',
                          style: GoogleFonts.inter(
                            fontSize: 14 * scale,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF9B9B9B),
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        SizedBox(width: 8 * scale),
                        Text(
                          '${product.salePrice.round()}\$',
                          style: GoogleFonts.inter(
                            fontSize: 14 * scale,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFDB3022),
                          ),
                        ),
                      ],
                    )
                  : Text(
                      '${product.salePrice.round()}\$',
                      style: GoogleFonts.inter(
                        fontSize: 14 * scale,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF222222),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Bottom Tab Bar
// ─────────────────────────────────────────────────────────────

class _BottomBar extends StatelessWidget {
  final double scale;
  final int selectedIndex;
  final ValueChanged<int> onTap;
  const _BottomBar({
    required this.scale,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12 * scale),
          topRight: Radius.circular(12 * scale),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0x0F000000),
            blurRadius: 20 * scale,
            offset: Offset(0, -4 * scale),
          ),
        ],
      ),
      padding: EdgeInsets.only(top: 8 * scale),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16 * scale),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _tabItem(Icons.home, 'Home', index: 0),
                  _tabItem(Icons.shopping_cart_outlined, 'Shop', index: 1),
                  _tabItem(Icons.shopping_bag_outlined, 'Bag', index: 2),
                  _tabItem(Icons.favorite_border, 'Favorites', index: 3),
                  _tabItem(Icons.person_outline, 'Profile', index: 4),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 4 * scale, bottom: 2 * scale),
              child: Container(
                width: 134 * scale,
                height: 5 * scale,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(100 * scale),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabItem(IconData icon, String label, {required int index}) {
    final isActive = selectedIndex == index;
    final color = isActive ? const Color(0xFFDB3022) : const Color(0xFF9B9B9B);
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24 * scale, color: color),
          SizedBox(height: 2 * scale),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10 * scale,
              color: color,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}
