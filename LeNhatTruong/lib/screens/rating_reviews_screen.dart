import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:le_nhat_truong/utils/constants.dart';

class RatingReviewsScreen extends StatefulWidget {
  final String productName;

  const RatingReviewsScreen({super.key, required this.productName});

  @override
  State<RatingReviewsScreen> createState() => _RatingReviewsScreenState();
}

class _RatingReviewsScreenState extends State<RatingReviewsScreen> {
  bool _withPhotoOnly = false;

  final List<Map<String, dynamic>> _reviews = [
    {
      'name': 'Kim Shine',
      'avatar': 'KS',
      'avatarUrl': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150',
      'rating': 4,
      'date': 'August 13, 2019',
      'content': 'I loved this dress so much as soon as I tried it on I knew I had to buy it in another color. I am 5\'3 about 155lbs and I carry all my weight in my upper body. When I put it on I felt like it thinned me put and I got so many compliments.',
      'helpful': true,
      'hasPhoto': true,
      'photos': [
        '${AppConstants.baseUrl}/images/z7896061230721_41a4a0c12a5100357c251e95b46bf9ed.jpg',
        '${AppConstants.baseUrl}/images/z7896061244018_33d1f0a4cc39f828e69a0ff3725f7383.jpg',
        '${AppConstants.baseUrl}/images/z7896061272915_47399beb55c4afe59a7ae310a066eefe.jpg',
      ],
    },
    {
      'name': 'Matilda Brown',
      'avatar': 'MB',
      'avatarUrl': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
      'rating': 4,
      'date': 'August 14, 2019',
      'content': 'I loved this dress so much as soon as I tried it on I knew I had to buy it in another color. I am 5\'3 about 155lbs and I carry all my weight in my upper body. When I put it on I felt like it...',
      'helpful': false,
      'hasPhoto': false,
      'photos': <String>[],
    },
    {
      'name': 'Helene Moore',
      'avatar': 'HM',
      'avatarUrl': 'https://images.unsplash.com/photo-1508214751196-bcfd4ca60f91?w=150',
      'rating': 4,
      'date': 'June 5, 2019',
      'content': 'The dress is great! Very classy and comfortable. It fit perfectly! I\'m 5\'7" and 130 pounds. I am a 34B chest. This dress would be too long for those who are shorter but could be hemmed.',
      'helpful': true,
      'hasPhoto': false,
      'photos': <String>[],
    },
    {
      'name': 'Kate Doe',
      'avatar': 'KD',
      'avatarUrl': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
      'rating': 5,
      'date': 'June 1, 2019',
      'content': 'Perfect dress, highly recommend! The quality is amazing for this price. Fits like a glove. The material is so soft and thick enough that it\'s not see-through.',
      'helpful': false,
      'hasPhoto': false,
      'photos': <String>[],
    },
    {
      'name': 'Alice Johnson',
      'avatar': 'AJ',
      'avatarUrl': 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=150',
      'rating': 5,
      'date': 'May 20, 2019',
      'content': 'Absolutely love this! Got so many compliments at the party. It is very elegant and fits perfectly according to the size chart.',
      'helpful': true,
      'hasPhoto': false,
      'photos': <String>[],
    },
    {
      'name': 'John Smith',
      'avatar': 'JS',
      'avatarUrl': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
      'rating': 3,
      'date': 'May 15, 2019',
      'content': 'Nice material, but it runs a bit small. I would suggest ordering one size up. The color is slightly darker than the photo.',
      'helpful': false,
      'hasPhoto': false,
      'photos': <String>[],
    },
    {
      'name': 'Emily Davis',
      'avatar': 'ED',
      'avatarUrl': 'https://images.unsplash.com/photo-1544725176-7c40e5a71c5e?w=150',
      'rating': 5,
      'date': 'May 10, 2019',
      'content': 'This dress is so beautiful! The material is high quality and it feels so luxurious. Recommend to everyone!',
      'helpful': true,
      'hasPhoto': false,
      'photos': <String>[],
    },
    {
      'name': 'Michael Brown',
      'avatar': 'MB',
      'avatarUrl': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
      'rating': 4,
      'date': 'May 5, 2019',
      'content': 'Good product for the price. Fast shipping and good customer support. Will buy again.',
      'helpful': false,
      'hasPhoto': false,
      'photos': <String>[],
    }
  ];

  @override
  Widget build(BuildContext context) {
    final scale = (MediaQuery.of(context).size.width / 375).clamp(0.5, 1.5);

    // Filter reviews based on checkbox state
    final filteredReviews = _withPhotoOnly
        ? _reviews.where((r) => r['hasPhoto'] == true).toList()
        : _reviews;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F9F9),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: const Color(0xFF222222), size: 20 * scale),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Rating and reviews',
          style: GoogleFonts.outfit(
            fontSize: 18 * scale,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF222222),
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16 * scale),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16 * scale),

                // Header section: "X reviews" and "With photo" Checkbox
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${filteredReviews.length} reviews',
                      style: GoogleFonts.outfit(
                        fontSize: 24 * scale,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF222222),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _withPhotoOnly = !_withPhotoOnly;
                        });
                      },
                      child: Row(
                        children: [
                          Checkbox(
                            value: _withPhotoOnly,
                            onChanged: (val) {
                              setState(() {
                                _withPhotoOnly = val ?? false;
                              });
                            },
                            activeColor: const Color(0xFF222222),
                            checkColor: Colors.white,
                            side: const BorderSide(color: Color(0xFF222222), width: 1.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          Text(
                            'With photo',
                            style: GoogleFonts.inter(
                              fontSize: 14 * scale,
                              color: const Color(0xFF222222),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16 * scale),

                // Reviews List
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredReviews.length,
                  itemBuilder: (context, index) {
                    final review = filteredReviews[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 24 * scale),
                      child: _buildReviewCard(review, scale),
                    );
                  },
                ),
                SizedBox(height: 80 * scale), // Space for Floating Action Button
              ],
            ),
          ),

          // Floating "Write a review" Button
          Positioned(
            right: 16 * scale,
            bottom: 24 * scale,
            child: FloatingActionButton.extended(
              onPressed: () {
                _showWriteReviewBottomSheet(context, scale);
              },
              backgroundColor: const Color(0xFFDB3022),
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25 * scale),
              ),
              icon: Icon(Icons.edit, color: Colors.white, size: 18 * scale),
              label: Text(
                'Write a review',
                style: GoogleFonts.inter(
                  fontSize: 14 * scale,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review, double scale) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Main Container Card
        Container(
          margin: EdgeInsets.only(left: 20 * scale, top: 10 * scale),
          padding: EdgeInsets.fromLTRB(24 * scale, 24 * scale, 24 * scale, 16 * scale),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8 * scale),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8 * scale,
                offset: Offset(0, 4 * scale),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Reviewer Name
              Text(
                review['name'],
                style: GoogleFonts.inter(
                  fontSize: 14 * scale,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF222222),
                ),
              ),
              SizedBox(height: 4 * scale),

              // Rating stars and Date Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: List.generate(
                      5,
                      (i) => Icon(
                        Icons.star,
                        size: 14 * scale,
                        color: i < review['rating']
                            ? const Color(0xFFFFBA49)
                            : const Color(0xFFE0E0E0),
                      ),
                    ),
                  ),
                  Text(
                    review['date'],
                    style: GoogleFonts.inter(
                      fontSize: 11 * scale,
                      color: const Color(0xFF9B9B9B),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12 * scale),

              // Review Content Text
              Text(
                review['content'],
                style: GoogleFonts.inter(
                  fontSize: 14 * scale,
                  color: const Color(0xFF222222),
                  height: 1.4,
                ),
              ),
              SizedBox(height: 16 * scale),

              // Horizontal Scrollable Photos List (if any)
              if (review['hasPhoto'] == true && review['photos'] != null && (review['photos'] as List).isNotEmpty) ...[
                SizedBox(
                  height: 104 * scale,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: (review['photos'] as List).length,
                    itemBuilder: (context, idx) {
                      final photoUrl = review['photos'][idx];
                      return Padding(
                        padding: EdgeInsets.only(right: 12 * scale),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8 * scale),
                          child: Image.network(
                            photoUrl,
                            width: 104 * scale,
                            height: 104 * scale,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 104 * scale,
                                height: 104 * scale,
                                color: const Color(0xFFE0E0E0),
                                child: const Icon(Icons.image, color: Colors.grey),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 16 * scale),
              ],

              // Helpful feedback row
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        review['helpful'] = !review['helpful'];
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          'Helpful',
                          style: GoogleFonts.inter(
                            fontSize: 11 * scale,
                            color: review['helpful'] ? const Color(0xFFDB3022) : const Color(0xFF9B9B9B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 4 * scale),
                        Icon(
                          Icons.thumb_up,
                          size: 13 * scale,
                          color: review['helpful'] ? const Color(0xFFDB3022) : const Color(0xFF9B9B9B),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // User Avatar floating on left border
        Positioned(
          left: 0,
          top: 0,
          child: Container(
            width: 40 * scale,
            height: 40 * scale,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 4 * scale,
                  offset: Offset(0, 2 * scale),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20 * scale),
              child: review['avatarUrl'] != null && (review['avatarUrl'] as String).startsWith('http')
                  ? Image.network(
                      review['avatarUrl'],
                      width: 40 * scale,
                      height: 40 * scale,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => _buildInitialsAvatar(review, scale),
                    )
                  : _buildInitialsAvatar(review, scale),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInitialsAvatar(Map<String, dynamic> review, double scale) {
    return Container(
      color: const Color(0xFFDB3022).withOpacity(0.15),
      child: Center(
        child: Text(
          review['avatar'] ?? 'U',
          style: GoogleFonts.inter(
            fontSize: 14 * scale,
            fontWeight: FontWeight.w700,
            color: const Color(0xFFDB3022),
          ),
        ),
      ),
    );
  }

  void _showWriteReviewBottomSheet(BuildContext context, double scale) {
    int currentRating = 5;
    final textController = TextEditingController();
    final List<String> pickedPhotos = [];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setBottomSheetState) {
            return Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF9F9F9),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: AnimatedPadding(
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeOut,
                padding: EdgeInsets.only(
                  left: 16 * scale,
                  right: 16 * scale,
                  top: 8 * scale,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 24 * scale,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Centered grey drag handle
                      Center(
                        child: Container(
                          width: 60 * scale,
                          height: 6 * scale,
                          decoration: BoxDecoration(
                            color: const Color(0xFFC4C4C4),
                            borderRadius: BorderRadius.circular(3 * scale),
                          ),
                        ),
                      ),
                      SizedBox(height: 24 * scale),

                      // Title
                      Center(
                        child: Text(
                          'What is you rate?',
                          style: GoogleFonts.outfit(
                            fontSize: 20 * scale,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF222222),
                          ),
                        ),
                      ),
                      SizedBox(height: 16 * scale),

                      // Stars selector
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          5,
                          (i) => GestureDetector(
                            onTap: () {
                              setBottomSheetState(() {
                                currentRating = i + 1;
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6 * scale),
                              child: Icon(
                                i < currentRating ? Icons.star : Icons.star_border,
                                size: 36 * scale,
                                color: i < currentRating
                                    ? const Color(0xFFFFBA49)
                                    : const Color(0xFF9B9B9B),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24 * scale),

                      // Description
                      Center(
                        child: Text(
                          'Please share your opinion\nabout the product',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 18 * scale,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF222222),
                            height: 1.2,
                          ),
                        ),
                      ),
                      SizedBox(height: 16 * scale),

                      // Text Field Container
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4 * scale),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 8 * scale,
                              offset: Offset(0, 4 * scale),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16 * scale, vertical: 8 * scale),
                        child: TextField(
                          controller: textController,
                          maxLines: 5,
                          decoration: InputDecoration(
                            hintText: 'Your review',
                            hintStyle: GoogleFonts.inter(
                              color: const Color(0xFF9B9B9B),
                              fontSize: 14 * scale,
                            ),
                            border: InputBorder.none,
                          ),
                          style: GoogleFonts.inter(
                            fontSize: 14 * scale,
                            color: const Color(0xFF222222),
                          ),
                        ),
                      ),
                      SizedBox(height: 24 * scale),

                      // Image picker row
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                final mockPhotos = [
                                  '${AppConstants.baseUrl}/images/z7896061230721_41a4a0c12a5100357c251e95b46bf9ed.jpg',
                                  '${AppConstants.baseUrl}/images/z7896061244018_33d1f0a4cc39f828e69a0ff3725f7383.jpg',
                                  '${AppConstants.baseUrl}/images/z7896061272915_47399beb55c4afe59a7ae310a066eefe.jpg',
                                ];
                                if (pickedPhotos.length < mockPhotos.length) {
                                  setBottomSheetState(() {
                                    pickedPhotos.add(mockPhotos[pickedPhotos.length]);
                                  });
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Đã đạt giới hạn 3 ảnh mẫu cho review!'),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                width: 104 * scale,
                                height: 104 * scale,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8 * scale),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 4 * scale,
                                      offset: Offset(0, 2 * scale),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 44 * scale,
                                      height: 44 * scale,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFDB3022),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                        size: 22 * scale,
                                      ),
                                    ),
                                    SizedBox(height: 8 * scale),
                                    Text(
                                      'Add your photos',
                                      style: GoogleFonts.inter(
                                        fontSize: 11 * scale,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF222222),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 12 * scale),
                            ...pickedPhotos.asMap().entries.map((entry) {
                              final idx = entry.key;
                              final photoUrl = entry.value;
                              return Padding(
                                padding: EdgeInsets.only(right: 12 * scale),
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8 * scale),
                                      child: Image.network(
                                        photoUrl,
                                        width: 104 * scale,
                                        height: 104 * scale,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      right: -4 * scale,
                                      top: -4 * scale,
                                      child: GestureDetector(
                                        onTap: () {
                                          setBottomSheetState(() {
                                            pickedPhotos.removeAt(idx);
                                          });
                                        },
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            color: Color(0xFFDB3022),
                                            shape: BoxShape.circle,
                                          ),
                                          padding: EdgeInsets.all(2 * scale),
                                          child: Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 14 * scale,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                      SizedBox(height: 32 * scale),

                      // SEND REVIEW button
                      SizedBox(
                        width: double.infinity,
                        height: 48 * scale,
                        child: ElevatedButton(
                          onPressed: () {
                            if (textController.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Vui lòng nhập nhận xét của bạn!'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                            setState(() {
                              _reviews.insert(0, {
                                'name': 'You',
                                'avatar': 'U',
                                'avatarUrl': 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150',
                                'rating': currentRating,
                                'date': 'Today',
                                'content': textController.text.trim(),
                                'helpful': false,
                                'hasPhoto': pickedPhotos.isNotEmpty,
                                'photos': List<String>.from(pickedPhotos),
                              });
                            });
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Cảm ơn bạn đã gửi đánh giá!'),
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
                            shadowColor: const Color(0xFFDB3022).withOpacity(0.4),
                          ),
                          child: Text(
                            'SEND REVIEW',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14 * scale,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
