import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderProductItem {
  final String title;
  final String brand;
  final String color;
  final String size;
  final int units;
  final int price;
  final String imageUrl;

  OrderProductItem({
    required this.title,
    required this.brand,
    required this.color,
    required this.size,
    required this.units,
    required this.price,
    required this.imageUrl,
  });
}

class OrderItemData {
  final String orderNo;
  final String date;
  final String trackingNumber;
  final int quantity;
  final int totalAmount;
  final String status; // 'Delivered', 'Processing', 'Cancelled'
  final String shippingAddress;
  final String paymentMethodCardNumber;
  final String paymentMethodType;
  final String deliveryMethod;
  final String discount;
  final List<OrderProductItem> items;

  OrderItemData({
    required this.orderNo,
    required this.date,
    required this.trackingNumber,
    required this.quantity,
    required this.totalAmount,
    required this.status,
    required this.shippingAddress,
    required this.paymentMethodCardNumber,
    required this.paymentMethodType,
    required this.deliveryMethod,
    required this.discount,
    required this.items,
  });
}

class MyOrdersScreen extends StatefulWidget {
  final VoidCallback? onBack;
  final ValueChanged<OrderItemData>? onOrderDetails;

  const MyOrdersScreen({super.key, this.onBack, this.onOrderDetails});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  String _selectedTab = 'Delivered';

  // Mock data representing realistic orders
  final List<OrderItemData> _allOrders = [
    OrderItemData(
      orderNo: 'Order №1947034',
      date: '05-12-2019',
      trackingNumber: 'IW3475453455',
      quantity: 3,
      totalAmount: 133,
      status: 'Delivered',
      shippingAddress: '3 Newbridge Court ,Chino Hills, CA 91709, United States',
      paymentMethodCardNumber: '**** **** **** 3947',
      paymentMethodType: 'Mastercard',
      deliveryMethod: 'FedEx, 3 days, 15\$',
      discount: '10%, Personal promo code',
      items: [
        OrderProductItem(
          title: 'Pullover',
          brand: 'Mango',
          color: 'Gray',
          size: 'L',
          units: 1,
          price: 51,
          imageUrl: '/images/top1.jpg',
        ),
        OrderProductItem(
          title: 'Pullover',
          brand: 'Mango',
          color: 'Gray',
          size: 'L',
          units: 1,
          price: 51,
          imageUrl: '/images/top2.jpg',
        ),
        OrderProductItem(
          title: 'Pullover',
          brand: 'Mango',
          color: 'Gray',
          size: 'L',
          units: 1,
          price: 51,
          imageUrl: '/images/top3.jpg',
        ),
      ],
    ),
    OrderItemData(
      orderNo: 'Order №1947035',
      date: '05-12-2019',
      trackingNumber: 'IW3475453455',
      quantity: 3,
      totalAmount: 112,
      status: 'Delivered',
      shippingAddress: '3 Newbridge Court ,Chino Hills, CA 91709, United States',
      paymentMethodCardNumber: '**** **** **** 3947',
      paymentMethodType: 'Mastercard',
      deliveryMethod: 'FedEx, 3 days, 15\$',
      discount: '10%, Personal promo code',
      items: [
        OrderProductItem(
          title: 'Pullover',
          brand: 'Mango',
          color: 'Gray',
          size: 'L',
          units: 1,
          price: 51,
          imageUrl: '/images/top1.jpg',
        ),
      ],
    ),
    OrderItemData(
      orderNo: 'Order №1947036',
      date: '05-12-2019',
      trackingNumber: 'IW3475453455',
      quantity: 3,
      totalAmount: 112,
      status: 'Delivered',
      shippingAddress: '3 Newbridge Court ,Chino Hills, CA 91709, United States',
      paymentMethodCardNumber: '**** **** **** 3947',
      paymentMethodType: 'Mastercard',
      deliveryMethod: 'FedEx, 3 days, 15\$',
      discount: '10%, Personal promo code',
      items: [
        OrderProductItem(
          title: 'Pullover',
          brand: 'Mango',
          color: 'Gray',
          size: 'L',
          units: 1,
          price: 51,
          imageUrl: '/images/top1.jpg',
        ),
      ],
    ),
    OrderItemData(
      orderNo: 'Order №1947040',
      date: '06-06-2026',
      trackingNumber: 'IW3475453501',
      quantity: 1,
      totalAmount: 45,
      status: 'Processing',
      shippingAddress: '123 Maple Street, Sunnyvale, CA 94086, United States',
      paymentMethodCardNumber: '**** **** **** 1234',
      paymentMethodType: 'Visa',
      deliveryMethod: 'DHL, 2 days, 10\$',
      discount: 'None',
      items: [
        OrderProductItem(
          title: 'Evening Dress',
          brand: 'Dorothy Perkins',
          color: 'Red',
          size: 'M',
          units: 1,
          price: 45,
          imageUrl: '/images/product1.jpg',
        ),
      ],
    ),
    OrderItemData(
      orderNo: 'Order №1947042',
      date: '06-06-2026',
      trackingNumber: 'IW3475453520',
      quantity: 4,
      totalAmount: 198,
      status: 'Processing',
      shippingAddress: '456 Oak Avenue, San Jose, CA 95112, United States',
      paymentMethodCardNumber: '**** **** **** 5678',
      paymentMethodType: 'Visa',
      deliveryMethod: 'FedEx, 3 days, 15\$',
      discount: '15%, Summer Sale',
      items: [
        OrderProductItem(
          title: 'Sport Dress',
          brand: 'Sitlly',
          color: 'Blue',
          size: 'S',
          units: 2,
          price: 99,
          imageUrl: '/images/product2.jpg',
        ),
      ],
    ),
    OrderItemData(
      orderNo: 'Order №1947010',
      date: '15-11-2019',
      trackingNumber: 'IW3475453200',
      quantity: 2,
      totalAmount: 54,
      status: 'Cancelled',
      shippingAddress: '789 Pine Road, Seattle, WA 98101, United States',
      paymentMethodCardNumber: '**** **** **** 9012',
      paymentMethodType: 'Mastercard',
      deliveryMethod: 'USPS, 5 days, 5\$',
      discount: 'None',
      items: [
        OrderProductItem(
          title: 'Oversize T-Shirt',
          brand: 'GUCCI',
          color: 'White',
          size: 'XL',
          units: 1,
          price: 54,
          imageUrl: '/images/product3.jpg',
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final scale = (MediaQuery.of(context).size.width / 375).clamp(0.5, 1.5);

    // Filter orders based on the selected tab
    final filteredOrders = _allOrders.where((order) => order.status == _selectedTab).toList();

    return Container(
      color: const Color(0xFFF9F9F9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Custom header bar (Back arrow and Search icon)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4 * scale, vertical: 8 * scale),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    color: const Color(0xFF222222),
                    size: 18 * scale,
                  ),
                  onPressed: () {
                    if (widget.onBack != null) {
                      widget.onBack!();
                    } else {
                      Navigator.maybePop(context);
                    }
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.search,
                    color: const Color(0xFF222222),
                    size: 24 * scale,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),

          // Large Title "My Orders"
          Padding(
            padding: EdgeInsets.only(left: 16 * scale, right: 16 * scale, bottom: 20 * scale),
            child: Text(
              'My Orders',
              style: GoogleFonts.outfit(
                fontSize: 34 * scale,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF222222),
              ),
            ),
          ),

          // Tab Filters Row (Delivered, Processing, Cancelled)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16 * scale),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTabButton('Delivered', scale),
                _buildTabButton('Processing', scale),
                _buildTabButton('Cancelled', scale),
              ],
            ),
          ),
          
          SizedBox(height: 24 * scale),

          // Scrollable Order List
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: filteredOrders.isEmpty
                  ? Center(
                      key: ValueKey('empty_$_selectedTab'),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_bag_outlined,
                            size: 48 * scale,
                            color: const Color(0xFF9B9B9B),
                          ),
                          SizedBox(height: 12 * scale),
                          Text(
                            'No orders found',
                            style: GoogleFonts.inter(
                              fontSize: 15 * scale,
                              color: const Color(0xFF9B9B9B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      key: ValueKey('list_$_selectedTab'),
                      padding: EdgeInsets.symmetric(horizontal: 16 * scale),
                      itemCount: filteredOrders.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 24 * scale),
                          child: _buildOrderCard(filteredOrders[index], scale),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String tabTitle, double scale) {
    final isSelected = _selectedTab == tabTitle;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = tabTitle;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: 20 * scale,
          vertical: 8 * scale,
        ),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF222222) : Colors.transparent,
          borderRadius: BorderRadius.circular(24 * scale),
        ),
        child: Text(
          tabTitle,
          style: GoogleFonts.inter(
            fontSize: 14 * scale,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF222222),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(OrderItemData order, double scale) {
    // Determine the text color for the order status
    Color statusColor;
    switch (order.status) {
      case 'Delivered':
        statusColor = const Color(0xFF2AA95C); // Green
        break;
      case 'Processing':
        statusColor = const Color(0xFFFFBA49); // Orange/Yellow
        break;
      case 'Cancelled':
        statusColor = const Color(0xFFDB3022); // Red
        break;
      default:
        statusColor = const Color(0xFF9B9B9B);
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8 * scale),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10 * scale,
            offset: Offset(0, 4 * scale),
          ),
        ],
      ),
      padding: EdgeInsets.all(18 * scale),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: Order Number & Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.orderNo,
                style: GoogleFonts.inter(
                  fontSize: 16 * scale,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF222222),
                ),
              ),
              Text(
                order.date,
                style: GoogleFonts.inter(
                  fontSize: 14 * scale,
                  color: const Color(0xFF9B9B9B),
                ),
              ),
            ],
          ),
          
          SizedBox(height: 12 * scale),

          // Tracking number row
          Row(
            children: [
              Text(
                'Tracking number: ',
                style: GoogleFonts.inter(
                  fontSize: 14 * scale,
                  color: const Color(0xFF9B9B9B),
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                order.trackingNumber,
                style: GoogleFonts.inter(
                  fontSize: 14 * scale,
                  color: const Color(0xFF222222),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          SizedBox(height: 10 * scale),

          // Quantity and Total Amount row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Quantity: ',
                    style: GoogleFonts.inter(
                      fontSize: 14 * scale,
                      color: const Color(0xFF9B9B9B),
                    ),
                  ),
                  Text(
                    '${order.quantity}',
                    style: GoogleFonts.inter(
                      fontSize: 14 * scale,
                      color: const Color(0xFF222222),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Total Amount: ',
                    style: GoogleFonts.inter(
                      fontSize: 14 * scale,
                      color: const Color(0xFF9B9B9B),
                    ),
                  ),
                  Text(
                    '${order.totalAmount}\$',
                    style: GoogleFonts.inter(
                      fontSize: 14 * scale,
                      color: const Color(0xFF222222),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 16 * scale),

          // Bottom row: Details button & Status text
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Details Button
              SizedBox(
                height: 36 * scale,
                child: OutlinedButton(
                  onPressed: () {
                    if (widget.onOrderDetails != null) {
                      widget.onOrderDetails!(order);
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF222222),
                    side: const BorderSide(color: Color(0xFF222222), width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24 * scale),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 24 * scale),
                  ),
                  child: Text(
                    'Details',
                    style: GoogleFonts.inter(
                      fontSize: 14 * scale,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              
              // Status text
              Text(
                order.status,
                style: GoogleFonts.inter(
                  fontSize: 14 * scale,
                  fontWeight: FontWeight.w600,
                  color: statusColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
