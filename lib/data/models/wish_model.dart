enum WishType { birthday, festival, newArrival }

class Wish {
  final String title;
  final String description;
  final String imageUrl;
  final WishType type;
  final String? likes;

  Wish({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.type,
    this.likes,
  });
}
