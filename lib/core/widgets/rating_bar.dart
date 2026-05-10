import 'package:flutter/material.dart';

class RatingBar extends StatelessWidget {
  final int rating;
  final int maxRating;
  final double size;
  final Color color;
  final Color unratedColor;
  final ValueChanged<int>? onRatingChanged;

  const RatingBar({
    super.key,
    required this.rating,
    this.maxRating = 5,
    this.size = 24,
    this.color = Colors.amber,
    this.unratedColor = Colors.grey,
    this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxRating, (index) {
        return GestureDetector(
          onTap: onRatingChanged != null ? () => onRatingChanged!(index + 1) : null,
          child: Icon(
            index < rating ? Icons.star : Icons.star_border,
            color: index < rating ? color : unratedColor,
            size: size,
          ),
        );
      }),
    );
  }
}
