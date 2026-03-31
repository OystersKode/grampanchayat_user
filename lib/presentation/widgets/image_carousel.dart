import 'package:flutter/material.dart';

class ImageCarousel extends StatelessWidget {
  final List<String> images;

  const ImageCarousel({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) return const SizedBox.shrink();
    
    if (images.length == 1) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(images[0], fit: BoxFit.cover, width: double.infinity, height: 200),
      );
    }

    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(images[index], fit: BoxFit.cover, width: 300),
            ),
          );
        },
      ),
    );
  }
}
