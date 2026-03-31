import '../models/news_model.dart';

class AppRepository {
  List<News> getNews() {
    return [
      News(
        title: "Village Water Project",
        description: "New water tank installed in village.",
        images: [
          "https://via.placeholder.com/300",
          "https://via.placeholder.com/300"
        ],
        category: "Development",
        date: "30 Mar 2026",
      ),
      News(
        title: "Gram Sabha Meeting",
        description: "Meeting scheduled on Sunday.",
        images: [],
        category: "Announcement",
        date: "29 Mar 2026",
      ),
    ];
  }
}
