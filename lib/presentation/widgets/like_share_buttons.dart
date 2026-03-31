import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';

class LikeShareButtons extends StatelessWidget {
  const LikeShareButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.button,
            foregroundColor: Colors.white,
          ),
          onPressed: () {},
          icon: const Icon(Icons.favorite_border),
          label: const Text("Like"),
        ),
        const SizedBox(width: 12),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.button,
            foregroundColor: Colors.white,
          ),
          onPressed: () {},
          icon: const Icon(Icons.share),
          label: const Text("Share"),
        ),
      ],
    );
  }
}
