import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../data/models/news_model.dart';
import '../../../data/repositories/app_repository.dart';
import '../../../core/config/app_config.dart';
import '../../widgets/app_error_widget.dart';
import '../../widgets/announcement_card.dart';
import '../../widgets/sidebar.dart';
import '../news_details/news_details_screen.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final List<News> _newsItems = [];
  bool _isLoading = false;
  bool _isMoreLoading = false;
  bool _hasMore = true;
  DocumentSnapshot? _lastDoc;
  int _selectedFilterIndex = 0; // 0: Today, 1: Yesterday, 2: Day Before
  final ScrollController _scrollController = ScrollController();
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadInitialNews();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (!_isMoreLoading && _hasMore && !_isLoading) {
        _loadMoreNews();
      }
    }
  }

  Future<void> _loadInitialNews({bool forceRefresh = false}) async {
    setState(() {
      _isLoading = true;
      _error = null;
      _newsItems.clear();
      _lastDoc = null;
      _hasMore = true;
    });

    try {
      final dateRange = _getFilterDateRange();
      final result = await AppRepository.instance.getNews(
        startDate: dateRange.start,
        endDate: dateRange.end,
        forceRefresh: forceRefresh,
        limit: 10,
      );

      if (mounted) {
        setState(() {
          _newsItems.addAll(result.news);
          _lastDoc = result.lastDoc;
          _isLoading = false;
          _hasMore = result.news.length == 10;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadMoreNews() async {
    if (_isMoreLoading || !_hasMore) return;

    setState(() {
      _isMoreLoading = true;
    });

    try {
      final dateRange = _getFilterDateRange();
      final result = await AppRepository.instance.getNews(
        startDate: dateRange.start,
        endDate: dateRange.end,
        startAfter: _lastDoc,
        limit: 10,
      );

      if (mounted) {
        setState(() {
          _newsItems.addAll(result.news);
          _lastDoc = result.lastDoc;
          _isMoreLoading = false;
          _hasMore = result.news.length == 10;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isMoreLoading = false;
        });
      }
    }
  }

  ({DateTime start, DateTime end}) _getFilterDateRange() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    DateTime filterDate;
    if (_selectedFilterIndex == 1) {
      filterDate = today.subtract(const Duration(days: 1));
    } else if (_selectedFilterIndex == 2) {
      filterDate = today.subtract(const Duration(days: 2));
    } else {
      filterDate = today;
    }

    return (
      start: filterDate,
      end: filterDate.add(const Duration(hours: 23, minutes: 59, seconds: 59))
    );
  }

  Future<void> _refreshNews() async {
    await _loadInitialNews(forceRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8EF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5E0006),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          'Kagwad Panchayat',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.1),
                side: BorderSide(color: Colors.white.withOpacity(0.2)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              child: const Text(
                'EN/ಕನ್ನಡ',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: const AppSidebar(),
      body: RefreshIndicator(
        onRefresh: _refreshNews,
        color: const Color(0xFFBC0006),
        backgroundColor: Colors.white,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const Text(
                    'OFFICIAL UPDATES',
                    style: TextStyle(
                      fontSize: 12,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF653D1E),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Latest Village\nAnnouncements',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF370002),
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 4,
                    width: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFFBC0006),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip('Today', 0),
                        const SizedBox(width: 8),
                        _buildFilterChip('Yesterday', 1),
                        const SizedBox(width: 8),
                        _buildFilterChip('Day Before', 2),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ]),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverToBoxAdapter(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _buildMainContent(),
                ),
              ),
            ),
            if (_isMoreLoading)
              const SliverPadding(
                padding: EdgeInsets.symmetric(vertical: 20),
                sliver: SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    if (_isLoading) {
      return const Padding(
        key: ValueKey('loading'),
        padding: EdgeInsets.symmetric(vertical: 48),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return AppErrorWidget(
        key: const ValueKey('error'),
        error: _error,
        onRetry: () => _loadInitialNews(forceRefresh: true),
      );
    }

    if (_newsItems.isEmpty) {
      return const Padding(
        key: ValueKey('empty'),
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text(
            'No announcements available.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Column(
      key: ValueKey('content_$_selectedFilterIndex'),
      children: _newsItems.map((item) {
        final String imageUrl = item.headerImageUrl.isNotEmpty
            ? item.headerImageUrl
            : (item.images.isNotEmpty ? item.images.first : '');
        return AnnouncementCard(
          contentId: item.id,
          category: item.category,
          title: item.title,
          description: item.description,
          imageUrl: imageUrl,
          likes: item.likeCount.toString(),
          initialIsLiked: item.isLiked,
          shareUrl: '${AppConfig.shareBaseUrl}/news/${item.id}',
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewsDetailsScreen(news: item),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildFilterChip(String label, int index) {
    final isSelected = _selectedFilterIndex == index;
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : const Color(0xFF653D1E),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedFilterIndex = index;
            _loadInitialNews();
          });
        }
      },
      selectedColor: const Color(0xFF5E0006),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? const Color(0xFF5E0006) : const Color(0xFFE5D1B5),
        ),
      ),
      showCheckmark: false,
    );
  }
}
