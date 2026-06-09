package com.example.authapp.controller;

import com.example.authapp.entity.Review;
import com.example.authapp.security.CustomUserDetails;
import com.example.authapp.service.ReviewService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/api/reviews")
@RequiredArgsConstructor
public class ReviewController {

    private final ReviewService reviewService;

    @GetMapping("/product/{productId}/summary")
    public ResponseEntity<Map<String, Object>> getProductRatingSummary(@PathVariable UUID productId) {
        return ResponseEntity.ok(reviewService.getRatingSummaryForProduct(productId));
    }

    @GetMapping("/product/{productId}")
    public ResponseEntity<List<Review>> getProductReviews(@PathVariable UUID productId) {
        return ResponseEntity.ok(reviewService.getReviewsForProduct(productId));
    }

    @PostMapping("/product/{productId}")
    public ResponseEntity<Review> createProductReview(
            @PathVariable UUID productId,
            @AuthenticationPrincipal CustomUserDetails userDetails,
            @RequestBody Review review
    ) {
        if (userDetails == null) {
            return ResponseEntity.status(401).build();
        }
        return ResponseEntity.ok(reviewService.createReview(productId, userDetails.getUser(), review));
    }
}
