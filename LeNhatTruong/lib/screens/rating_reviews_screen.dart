import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      'name': 'Helene Moore',
      'avatar': 'HM',
      'rating': 4,
      'date': 'June 5, 2019',
      'content': 'The dress is great! Very classy and comfortable. It fit perfectly! I\'m 5\'7" and 130 pounds. I am a 34B chest. This dress would be too long for those who are shorter but could be hemmed. I wouldn\'t recommend it for those big chested as I am smaller chested and it fit me perfectly. The underarms were not too wide and the dress was made well.',
      'helpful': true,
      'hasPhoto': false,
    },
    {
      'name': 'Kate Doe',
      'avatar': 'KD',
      'rating': 5,
      'date': 'June 1, 2019',
      'content': 'Perfect dress, highly recommend! The quality is amazing for this price. Fits like a glove. The material is so soft and thick enough that it\'s not see-through.',
      'helpful': false,
      'hasPhoto': true,
    },
    {
      'name': 'Alice Johnson',
      'avatar': 'AJ',
      'rating': 5,
      'date': 'May 20, 2019',
      'content': 'Absolutely love this! Got so many compliments at the party. It is very elegant and fits perfectly according to the size chart.',
      'helpful': true,
      'hasPhoto': false,
    },
    {
      'name': 'John Smith',
      'avatar': 'JS',
      'rating': 3,
      'date': 'May 15, 2019',
      'content': 'Nice material, but it runs a bit small. I would suggest ordering one size up. The color is slightly darker than the photo.',
      'helpful': false,
      'hasPhoto': false,
    }
  ];

  @override
  Widget build(BuildContext context) {
    final scale = (MediaQuery.of(context).size.width / 375).clamp(0.5, 1.5);

    // Filter reviews
    final filteredReviews = _withPhotoOnly
        ? _reviews.where((r) => r['hasPhoto'] == true).toList()
        : _reviews;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F9F9),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: const Color(0xFF222222), size: 20 * scale),
          onPressed: () => Navigator.pop(context),
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
                // Title
                Text(
                  'Rating&Reviews',
                  style: GoogleFonts.outfit(
                    fontSize: 34 * scale,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF222222),
                  ),
                ),
                SizedBox(height: 24 * scale),

                // Statistics Summary Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Big Average Rating
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '4.3',
                          style: GoogleFonts.outfit(
                            fontSize: 44 * scale,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF222222),
                            height: 1.0,
                          ),
                        ),
                        SizedBox(height: 8 * scale),
                        Text(
                          '23 ratings',
                          style: GoogleFonts.inter(
                            fontSize: 12 * scale,
                            color: const Color(0xFF9B9B9B),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 32 * scale),

                    // Star Breakdown Bar Chart
                    Expanded(
                      child: Column(
                        children: [
                          _buildBreakdownRow(5, 12, 12 / 23, scale),
                          SizedBox(height: 4 * scale),
                          _buildBreakdownRow(4, 5, 5 / 23, scale),
                          SizedBox(height: 4 * scale),
                          _buildBreakdownRow(3, 4, 4 / 23, scale),
                          SizedBox(height: 4 * scale),
                          _buildBreakdownRow(2, 2, 2 / 23, scale),
                          SizedBox(height: 4 * scale),
                          _buildBreakdownRow(1, 0, 0 / 23, scale),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32 * scale),

                // Header list reviews & checkbox
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
                            activeColor: const Color(0xFFDB3022),
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
                SizedBox(height: 80 * scale), // Space for FAB
              ],
            ),
          ),

          // Floating Write a Review Button on bottom right
          Positioned(
            right: 16 * scale,
            bottom: 24 * scale,
            child: FloatingActionButton.extended(
              onPressed: () {
                _showWriteReviewDialog(context, scale);
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

  Widget _buildBreakdownRow(int starCount, int ratingCount, double fraction, double scale) {
    return Row(
      children: [
        // Stars
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            5,
            (index) => Icon(
              Icons.star,
              size: 12 * scale,
              color: index < starCount ? const Color(0xFFFFBA49) : Colors.transparent,
            ),
          ),
        ),
        SizedBox(width: 8 * scale),

        // Progress Bar Chart
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4 * scale),
            child: Container(
              height: 8 * scale,
              color: Colors.transparent,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    color: Colors.transparent,
                  ),
                  FractionallySizedBox(
                    widthFactor: fraction,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFDB3022),
                        borderRadius: BorderRadius.circular(4 * scale),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 8 * scale),

        // Rating Count Label
        SizedBox(
          width: 20 * scale,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              '$ratingCount',
              style: GoogleFonts.inter(
                fontSize: 11 * scale,
                color: const Color(0xFF222222),
              ),
            ),
          ),
        ),
      ],
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

              // Rating and Date Row
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

              // Bottom row with mock pictures (if any) and helpful feedback
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
              color: const Color(0xFFDB3022).withOpacity(0.15),
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
            child: Center(
              child: Text(
                review['avatar'],
                style: GoogleFonts.inter(
                  fontSize: 14 * scale,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFDB3022),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showWriteReviewDialog(BuildContext context, double scale) {
    int currentRating = 5;
    final textController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16 * scale),
              ),
              title: Text(
                'Write a review',
                style: GoogleFonts.outfit(
                  fontSize: 20 * scale,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF222222),
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Please rate this product:',
                    style: GoogleFonts.inter(
                      fontSize: 14 * scale,
                      color: const Color(0xFF9B9B9B),
                    ),
                  ),
                  SizedBox(height: 12 * scale),

                  // Interactive Stars selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      5,
                      (i) => GestureDetector(
                        onTap: () {
                          setDialogState(() {
                            currentRating = i + 1;
                          });
                        },
                        child: Icon(
                          Icons.star,
                          size: 32 * scale,
                          color: i < currentRating
                              ? const Color(0xFFFFBA49)
                              : const Color(0xFFE0E0E0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20 * scale),

                  // Review Text Field
                  TextField(
                    controller: textController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Share your feedback about the product...',
                      hintStyle: GoogleFonts.inter(color: const Color(0xFF9B9B9B), fontSize: 13 * scale),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8 * scale),
                        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8 * scale),
                        borderSide: const BorderSide(color: Color(0xFFDB3022)),
                      ),
                    ),
                    style: GoogleFonts.inter(fontSize: 14 * scale, color: const Color(0xFF222222)),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF9B9B9B),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (textController.text.trim().isEmpty) return;
                    setState(() {
                      _reviews.insert(0, {
                        'name': 'You',
                        'avatar': 'U',
                        'rating': currentRating,
                        'date': 'Today',
                        'content': textController.text.trim(),
                        'helpful': false,
                        'hasPhoto': false,
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
                      borderRadius: BorderRadius.circular(8 * scale),
                    ),
                  ),
                  child: Text(
                    'Submit',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
