import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../utils/app_theme.dart';
import '../utils/constants.dart';
import 'rating_reviews_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String _selectedSize = 'Size';
  String _selectedColor = 'Color';
  bool _isFavorited = false;
  final List<String> _sizes = ['XS', 'S', 'M', 'L', 'XL'];
  final List<String> _colors = ['Black', 'White', 'Red', 'Blue', 'Beige'];

  final ProductService _productService = ProductService();
  List<Product> _relatedProducts = [];
  bool _isRelatedLoading = true;

  @override
  void initState() {
    super.initState();
    // Default selected values if matching available items
    if (_colors.contains(widget.product.note)) {
      _selectedColor = widget.product.note!;
    }
    _loadRelatedProducts();
  }

  Future<void> _loadRelatedProducts() async {
    setState(() {
      _isRelatedLoading = true;
    });
    try {
      List<Product> products = [];
      if (widget.product.tags.isNotEmpty) {
        products = await _productService.getProductsByTag(widget.product.tags.first.tagName);
      }
      if (products.isEmpty || products.length <= 1) {
        products = await _productService.getNewProducts();
      }
      // Filter out current product
      products = products.where((p) => p.id != widget.product.id).toList();
      setState(() {
        _relatedProducts = products;
        _isRelatedLoading = false;
      });
    } catch (e) {
      setState(() {
        _isRelatedLoading = false;
      });
      print('>>> Error loading related products: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final scale = (MediaQuery.of(context).size.width / 375).clamp(0.5, 1.5);
    final isNew = widget.product.tags.any((t) => t.tagName.toUpperCase() == 'NEW');
    final isOnSale = widget.product.comparePrice != null &&
        widget.product.comparePrice! > widget.product.salePrice;

    final String fullImageUrl = widget.product.imageUrl != null
        ? (widget.product.imageUrl!.startsWith('http')
            ? widget.product.imageUrl!
            : '${AppConstants.baseUrl}${widget.product.imageUrl}')
        : '';

    // Create a list of mock gallery images using the main image
    final List<String> galleryImages = [
      fullImageUrl,
      fullImageUrl, // Repeat or use fallback/mock details to match user design image
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: const Color(0xFF222222), size: 20 * scale),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.product.productName,
          style: GoogleFonts.outfit(
            color: const Color(0xFF222222),
            fontWeight: FontWeight.w700,
            fontSize: 18 * scale,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.share_outlined, color: const Color(0xFF222222), size: 22 * scale),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Chia sẻ sản phẩm thành công!')),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Gallery Carousel
                    SizedBox(
                      height: 413 * scale,
                      child: galleryImages[0].isNotEmpty
                          ? PageView.builder(
                              controller: PageController(viewportFraction: 0.74, keepPage: true),
                              padEnds: false,
                              itemCount: galleryImages.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.only(
                                    left: index == 0 ? 0 : 4 * scale,
                                    right: 4 * scale,
                                  ),
                                  child: Image.network(
                                    galleryImages[index],
                                    fit: BoxFit.cover,
                                    alignment: Alignment.center,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: const Color(0xFFE0E0E0),
                                        child: const Icon(Icons.image, color: Colors.grey, size: 50),
                                      );
                                    },
                                  ),
                                );
                              },
                            )
                          : Container(
                              color: const Color(0xFFE0E0E0),
                              child: Center(
                                child: Icon(Icons.image, color: Colors.grey, size: 50 * scale),
                              ),
                            ),
                    ),
                    SizedBox(height: 12 * scale),

                    // Selector Dropdowns Row
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16 * scale),
                      child: Row(
                        children: [
                          // Size Selector Dropdown Button
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _showSizeBottomSheet(context),
                              child: Container(
                                height: 40 * scale,
                                padding: EdgeInsets.symmetric(horizontal: 12 * scale),
                                decoration: BoxDecoration(
                                  border: Border.all(color: const Color(0xFFE0E0E0)),
                                  borderRadius: BorderRadius.circular(8 * scale),
                                  color: Colors.white,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _selectedSize == 'Size' ? 'Size' : _selectedSize,
                                      style: GoogleFonts.inter(
                                        fontSize: 14 * scale,
                                        color: const Color(0xFF222222),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const Icon(Icons.keyboard_arrow_down, color: Color(0xFF222222)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12 * scale),

                          // Color Selector Dropdown Button
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _showColorBottomSheet(context),
                              child: Container(
                                height: 40 * scale,
                                padding: EdgeInsets.symmetric(horizontal: 12 * scale),
                                decoration: BoxDecoration(
                                  border: Border.all(color: const Color(0xFFE0E0E0)),
                                  borderRadius: BorderRadius.circular(8 * scale),
                                  color: Colors.white,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _selectedColor == 'Color' ? 'Color' : _selectedColor,
                                      style: GoogleFonts.inter(
                                        fontSize: 14 * scale,
                                        color: const Color(0xFF222222),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const Icon(Icons.keyboard_arrow_down, color: Color(0xFF222222)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12 * scale),

                          // Favorite Button
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isFavorited = !_isFavorited;
                              });
                            },
                            child: Container(
                              width: 36 * scale,
                              height: 36 * scale,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 4 * scale,
                                    offset: Offset(0, 4 * scale),
                                  ),
                                ],
                              ),
                              child: Icon(
                                _isFavorited ? Icons.favorite : Icons.favorite_border,
                                color: _isFavorited ? const Color(0xFFDB3022) : const Color(0xFF9B9B9B),
                                size: 20 * scale,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 22 * scale),

                    // Info Section: Brand, Price, Rating, Description
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16 * scale),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Brand and Name
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.product.brandName ?? 'Generic',
                                      style: GoogleFonts.outfit(
                                        fontSize: 24 * scale,
                                        fontWeight: FontWeight.w800,
                                        color: const Color(0xFF222222),
                                      ),
                                    ),
                                    SizedBox(height: 4 * scale),
                                    Text(
                                      widget.product.productName,
                                      style: GoogleFonts.inter(
                                        fontSize: 13 * scale,
                                        color: const Color(0xFF9B9B9B),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Price
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  if (isOnSale) ...[
                                    Text(
                                      '\$${widget.product.comparePrice!.toStringAsFixed(2)}',
                                      style: GoogleFonts.inter(
                                        fontSize: 16 * scale,
                                        color: const Color(0xFF9B9B9B),
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                    SizedBox(height: 2 * scale),
                                    Text(
                                      '\$${widget.product.salePrice.toStringAsFixed(2)}',
                                      style: GoogleFonts.inter(
                                        fontSize: 22 * scale,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFFDB3022),
                                      ),
                                    ),
                                  ] else ...[
                                    Text(
                                      '\$${widget.product.salePrice.toStringAsFixed(2)}',
                                      style: GoogleFonts.inter(
                                        fontSize: 22 * scale,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF222222),
                                      ),
                                    ),
                                  ]
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 8 * scale),

                          // Rating Stars
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RatingReviewsScreen(
                                    productName: widget.product.productName,
                                  ),
                                ),
                              );
                            },
                            behavior: HitTestBehavior.opaque,
                            child: Row(
                              children: [
                                ...List.generate(5, (i) {
                                  final isFilled = i < (widget.product.ratingAverage ?? 5.0).floor();
                                  return Icon(
                                    Icons.star,
                                    size: 14 * scale,
                                    color: isFilled ? const Color(0xFFFFBA49) : const Color(0xFF9B9B9B),
                                  );
                                }),
                                SizedBox(width: 4 * scale),
                                Text(
                                  '(${widget.product.reviewCount ?? 10})',
                                  style: GoogleFonts.inter(
                                    fontSize: 11 * scale,
                                    color: const Color(0xFF9B9B9B),
                                  ),
                                ),
                                SizedBox(width: 4 * scale),
                                Icon(
                                  Icons.chevron_right,
                                  size: 14 * scale,
                                  color: const Color(0xFF9B9B9B),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16 * scale),

                          // Product Description
                          Text(
                            widget.product.productDescription.isNotEmpty
                                ? widget.product.productDescription
                                : widget.product.shortDescription,
                            style: GoogleFonts.inter(
                              fontSize: 14 * scale,
                              color: const Color(0xFF222222),
                              height: 1.45,
                            ),
                          ),
                          SizedBox(height: 24 * scale),

                          // Divider
                          const Divider(height: 1, color: Color(0xFFF0F0F0)),

                          // Shipping info row
                          _buildClickableRow(
                            title: 'Shipping info',
                            scale: scale,
                            onTap: () {
                              _showBottomSheetInfo(
                                context,
                                'Shipping info',
                                'Miễn phí giao hàng tiêu chuẩn cho đơn hàng từ 500.000đ.\nThời gian giao hàng dự kiến từ 2-4 ngày làm việc.',
                              );
                            },
                          ),

                          const Divider(height: 1, color: Color(0xFFF0F0F0)),

                          // Support row
                          _buildClickableRow(
                            title: 'Support',
                            scale: scale,
                            onTap: () {
                              _showBottomSheetInfo(
                                context,
                                'Support',
                                'Hỗ trợ khách hàng 24/7.\nHotline: 1900 xxxx\nEmail: support@authapp.com',
                              );
                            },
                          ),

                          const Divider(height: 1, color: Color(0xFFF0F0F0)),
                          SizedBox(height: 24 * scale),

                          // You can also like this section header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'You can also like this',
                                style: GoogleFonts.outfit(
                                  fontSize: 18 * scale,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF222222),
                                ),
                              ),
                              if (!_isRelatedLoading)
                                Text(
                                  '${_relatedProducts.length} items',
                                  style: GoogleFonts.inter(
                                    fontSize: 11 * scale,
                                    color: const Color(0xFF9B9B9B),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 12 * scale),

                          // Horizontal scroll of related products
                          _isRelatedLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xFFDB3022),
                                  ),
                                )
                              : _relatedProducts.isEmpty
                                  ? Padding(
                                      padding: EdgeInsets.symmetric(vertical: 8 * scale),
                                      child: Text(
                                        'Không có sản phẩm gợi ý nào',
                                        style: GoogleFonts.inter(
                                          color: Colors.grey,
                                          fontSize: 14 * scale,
                                        ),
                                      ),
                                    )
                                  : SizedBox(
                                      height: 260 * scale,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: _relatedProducts.length,
                                        itemBuilder: (context, index) {
                                          final p = _relatedProducts[index];
                                          return Padding(
                                            padding: EdgeInsets.only(right: 16 * scale),
                                            child: _RelatedProductCard(
                                              product: p,
                                              scale: scale,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                          SizedBox(height: 32 * scale),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Fixed Bottom Add To Cart Button
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16 * scale, vertical: 16 * scale),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10 * scale,
                    offset: Offset(0, -4 * scale),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: double.infinity,
                  height: 48 * scale,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_selectedSize == 'Size') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Vui lòng chọn kích thước (Size)'),
                            backgroundColor: AppTheme.error,
                          ),
                        );
                        return;
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Đã thêm ${widget.product.productName} (Size $_selectedSize) vào giỏ hàng!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDB3022),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24 * scale),
                      ),
                      elevation: 4,
                      shadowColor: const Color(0xFFD32626).withOpacity(0.25),
                    ),
                    child: Text(
                      'ADD TO CART',
                      style: GoogleFonts.inter(
                        fontSize: 14 * scale,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSizeBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            final scale = (MediaQuery.of(context).size.width / 375).clamp(0.5, 1.5);
            return Padding(
              padding: EdgeInsets.fromLTRB(16 * scale, 12 * scale, 16 * scale, 16 * scale),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag Handle
                  Center(
                    child: Container(
                      width: 60 * scale,
                      height: 6 * scale,
                      decoration: BoxDecoration(
                        color: const Color(0xFFC4C4C4),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                  SizedBox(height: 16 * scale),

                  // Title
                  Center(
                    child: Text(
                      'Select size',
                      style: GoogleFonts.outfit(
                        fontSize: 18 * scale,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF222222),
                      ),
                    ),
                  ),
                  SizedBox(height: 24 * scale),

                  // Size Buttons Grid (Wrap)
                  Wrap(
                    spacing: 12 * scale,
                    runSpacing: 12 * scale,
                    children: _sizes.map((size) {
                      final isSelected = _selectedSize == size;
                      return GestureDetector(
                        onTap: () {
                          setModalState(() {
                            _selectedSize = size;
                          });
                          setState(() {
                            _selectedSize = size;
                          });
                        },
                        child: Container(
                          width: (100 * scale).clamp(60.0, 150.0),
                          height: 40 * scale,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: isSelected ? const Color(0xFFDB3022) : const Color(0xFFE0E0E0),
                              width: isSelected ? 1.5 : 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8 * scale),
                          ),
                          child: Center(
                            child: Text(
                              size,
                              style: GoogleFonts.inter(
                                fontSize: 14 * scale,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                color: isSelected ? const Color(0xFFDB3022) : const Color(0xFF222222),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 24 * scale),

                  const Divider(height: 1, color: Color(0xFFF0F0F0)),

                  // Size info row
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      _showBottomSheetInfo(
                        context,
                        'Size info',
                        'Bảng quy đổi kích thước chuẩn:\n- XS: Ngực 80-84cm, Eo 62-66cm\n- S: Ngực 84-88cm, Eo 66-70cm\n- M: Ngực 88-92cm, Eo 70-74cm\n- L: Ngực 92-96cm, Eo 74-78cm\n- XL: Ngực 96-100cm, Eo 78-82cm',
                      );
                    },
                    child: Container(
                      height: 48 * scale,
                      padding: EdgeInsets.symmetric(vertical: 12 * scale),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Size info',
                            style: GoogleFonts.inter(
                              fontSize: 16 * scale,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF222222),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: const Color(0xFF222222),
                            size: 20 * scale,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(height: 1, color: Color(0xFFF0F0F0)),
                  SizedBox(height: 24 * scale),

                  // Add To Cart Button
                  SizedBox(
                    width: double.infinity,
                    height: 48 * scale,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        if (_selectedSize == 'Size') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Vui lòng chọn kích thước (Size)'),
                              backgroundColor: AppTheme.error,
                            ),
                          );
                          return;
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Đã thêm ${widget.product.productName} (Size $_selectedSize) vào giỏ hàng!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDB3022),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24 * scale),
                        ),
                        elevation: 4,
                        shadowColor: const Color(0xFFD32626).withValues(alpha: 0.25),
                      ),
                      child: Text(
                        'ADD TO CART',
                        style: GoogleFonts.inter(
                          fontSize: 14 * scale,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showColorBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            final scale = (MediaQuery.of(context).size.width / 375).clamp(0.5, 1.5);
            return Padding(
              padding: EdgeInsets.fromLTRB(16 * scale, 12 * scale, 16 * scale, 16 * scale),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag Handle
                  Center(
                    child: Container(
                      width: 60 * scale,
                      height: 6 * scale,
                      decoration: BoxDecoration(
                        color: const Color(0xFFC4C4C4),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                  SizedBox(height: 16 * scale),

                  // Title
                  Center(
                    child: Text(
                      'Select color',
                      style: GoogleFonts.outfit(
                        fontSize: 18 * scale,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF222222),
                      ),
                    ),
                  ),
                  SizedBox(height: 24 * scale),

                  // Color Buttons Grid (Wrap)
                  Wrap(
                    spacing: 12 * scale,
                    runSpacing: 12 * scale,
                    children: _colors.map((color) {
                      final isSelected = _selectedColor == color;
                      return GestureDetector(
                        onTap: () {
                          setModalState(() {
                            _selectedColor = color;
                          });
                          setState(() {
                            _selectedColor = color;
                          });
                        },
                        child: Container(
                          width: (100 * scale).clamp(60.0, 150.0),
                          height: 40 * scale,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: isSelected ? const Color(0xFFDB3022) : const Color(0xFFE0E0E0),
                              width: isSelected ? 1.5 : 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8 * scale),
                          ),
                          child: Center(
                            child: Text(
                              color,
                              style: GoogleFonts.inter(
                                fontSize: 14 * scale,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                color: isSelected ? const Color(0xFFDB3022) : const Color(0xFF222222),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 24 * scale),

                  const Divider(height: 1, color: Color(0xFFF0F0F0)),

                  // Color info row
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      _showBottomSheetInfo(
                        context,
                        'Color info',
                        'Thông tin về màu sắc sản phẩm:\n- Các sản phẩm đều được nhuộm bằng công nghệ giữ màu tiên tiến, không ra màu khi giặt.\n- Độ lệch màu sắc thực tế so với ảnh chụp có thể khoảng 3-5% do điều kiện ánh sáng hiển thị màn hình thiết bị khác nhau.',
                      );
                    },
                    child: Container(
                      height: 48 * scale,
                      padding: EdgeInsets.symmetric(vertical: 12 * scale),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Color info',
                            style: GoogleFonts.inter(
                              fontSize: 16 * scale,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF222222),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: const Color(0xFF222222),
                            size: 20 * scale,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(height: 1, color: Color(0xFFF0F0F0)),
                  SizedBox(height: 24 * scale),

                  // Add To Cart Button
                  SizedBox(
                    width: double.infinity,
                    height: 48 * scale,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        if (_selectedColor == 'Color') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Vui lòng chọn màu sắc (Color)'),
                              backgroundColor: AppTheme.error,
                            ),
                          );
                          return;
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Đã thêm ${widget.product.productName} (Color $_selectedColor) vào giỏ hàng!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDB3022),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24 * scale),
                        ),
                        elevation: 4,
                        shadowColor: const Color(0xFFD32626).withValues(alpha: 0.25),
                      ),
                      child: Text(
                        'ADD TO CART',
                        style: GoogleFonts.inter(
                          fontSize: 14 * scale,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildClickableRow({
    required String title,
    required double scale,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 48 * scale,
        padding: EdgeInsets.symmetric(vertical: 12 * scale),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 16 * scale,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF222222),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: const Color(0xFF222222),
              size: 20 * scale,
            ),
          ],
        ),
      ),
    );
  }

  void _showBottomSheetInfo(BuildContext context, String title, String content) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final scale = (MediaQuery.of(context).size.width / 375).clamp(0.5, 1.5);
        return Padding(
          padding: EdgeInsets.all(24.0 * scale),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 60 * scale,
                  height: 6 * scale,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              SizedBox(height: 24 * scale),
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 20 * scale,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF222222),
                ),
              ),
              SizedBox(height: 16 * scale),
              Text(
                content,
                style: GoogleFonts.inter(
                  fontSize: 14 * scale,
                  color: const Color(0xFF222222),
                  height: 1.5,
                ),
              ),
              SizedBox(height: 24 * scale),
            ],
          ),
        );
      },
    );
  }
}

class _RelatedProductCard extends StatelessWidget {
  final Product product;
  final double scale;

  const _RelatedProductCard({required this.product, required this.scale});

  @override
  Widget build(BuildContext context) {
    final cardW = 150 * scale;
    final cardH = 260 * scale;
    final photoH = cardH * 0.68;
    final topNew = 8 * scale;
    final leftNew = 10 * scale;
    final topRating = photoH + 5 * scale;
    final topFav = photoH - 18 * scale;
    final topBrand = photoH + 24 * scale;
    final topName = photoH + 39 * scale;
    final topPrice = photoH + 60 * scale;

    final bool isOnSale = product.comparePrice != null && product.comparePrice! > product.salePrice;
    int discountPercent = 0;
    if (isOnSale) {
      discountPercent = (((product.comparePrice! - product.salePrice) / product.comparePrice!) * 100).round();
    }

    final bool isNew = product.tags.any((t) => t.tagName.toUpperCase() == 'NEW');

    final String fullImageUrl = product.imageUrl != null
        ? (product.imageUrl!.startsWith('http')
            ? product.imageUrl!
            : '${AppConstants.baseUrl}${product.imageUrl}')
        : '';

    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: cardW,
        height: cardH,
        child: Stack(
          children: [
            // Product photo
            Positioned(
              left: 0,
              top: 0,
              width: cardW,
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
