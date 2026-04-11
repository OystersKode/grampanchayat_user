import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../data/models/news_model.dart';
import '../../../data/repositories/app_repository.dart';
import '../../../core/config/app_config.dart';
import '../../../core/services/settings_service.dart';
import '../../../core/localization/app_translations.dart';
import '../../widgets/app_error_widget.dart';
import '../../widgets/announcement_card.dart';
import '../../widgets/sidebar.dart';
import '../news_details/news_details_screen.dart';
import '../../../routes/app_routes.dart';

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
  int _selectedFilterIndex = 0; // 0: Today, 1: Yesterday, 2: Before
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  String? _error;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _loadInitialNews();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
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
      final dateRange = _searchQuery.isEmpty ? _getFilterDateRange() : (start: null, end: null);
      final result = await AppRepository.instance.getNews(
        startDate: dateRange.start,
        endDate: dateRange.end,
        forceRefresh: forceRefresh,
        limit: _searchQuery.isEmpty ? 10 : 50,
      );

      if (mounted) {
        setState(() {
          _newsItems.addAll(result.news);
          _lastDoc = result.lastDoc;
          _isLoading = false;
          _hasMore = result.news.length == (_searchQuery.isEmpty ? 10 : 50);
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
      final dateRange = _searchQuery.isEmpty ? _getFilterDateRange() : (start: null, end: null);
      final result = await AppRepository.instance.getNews(
        startDate: dateRange.start,
        endDate: dateRange.end,
        startAfter: _lastDoc,
        limit: _searchQuery.isEmpty ? 10 : 50,
      );

      if (mounted) {
        setState(() {
          _newsItems.addAll(result.news);
          _lastDoc = result.lastDoc;
          _isMoreLoading = false;
          _hasMore = result.news.length == (_searchQuery.isEmpty ? 10 : 50);
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

  ({DateTime? start, DateTime? end}) _getFilterDateRange() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    if (_selectedFilterIndex == 0) {
      // Today
      return (
        start: today,
        end: today.add(const Duration(hours: 23, minutes: 59, seconds: 59))
      );
    } else if (_selectedFilterIndex == 1) {
      // Yesterday
      final yesterday = today.subtract(const Duration(days: 1));
      return (
        start: yesterday,
        end: yesterday.add(const Duration(hours: 23, minutes: 59, seconds: 59))
      );
    } else {
      // Before (Everything before yesterday)
      final yesterdayStart = today.subtract(const Duration(days: 1));
      return (
        start: null,
        end: yesterdayStart.subtract(const Duration(seconds: 1))
      );
    }
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
        title: Text(
          'app_title'.tr(context),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          ListenableBuilder(
            listenable: SettingsService.instance,
            builder: (context, _) {
              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('announcements')
                    .orderBy('created_at', descending: true)
                    .limit(1)
                    .snapshots(),
                builder: (context, snapshot) {
                  bool hasNew = false;
                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    final latestId = snapshot.data!.docs.first.id;
                    hasNew = latestId != SettingsService.instance.lastReadAnnouncementId;
                  }

                  return Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications_none, color: Colors.white),
                        onPressed: () {
                          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                            SettingsService.instance.setLastReadAnnouncementId(snapshot.data!.docs.first.id);
                          }
                          Navigator.pushNamed(context, AppRoutes.announcements);
                        },
                      ),
                      if (hasNew)
                        Positioned(
                          right: 12,
                          top: 12,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 10,
                              minHeight: 10,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: ListenableBuilder(
              listenable: SettingsService.instance,
              builder: (context, _) {
                return TextButton(
                  onPressed: () {
                    SettingsService.instance.toggleLanguage();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.1),
                    side: BorderSide(color: Colors.white.withOpacity(0.2)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  child: Text(
                    SettingsService.instance.languageCode == 'en' ? 'ಕನ್ನಡ' : 'EN',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                );
              },
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
                  Text(
                    'official_updates'.tr(context),
                    style: const TextStyle(
                      fontSize: 12,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF653D1E),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'latest_village_announcements'.tr(context),
                    style: const TextStyle(
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
                  TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.toLowerCase();
                      });
                      if (_debounce?.isActive ?? false) _debounce?.cancel();
                      _debounce = Timer(const Duration(milliseconds: 500), () {
                        if (mounted) {
                          _loadInitialNews();
                        }
                      });
                    },
                    onSubmitted: (value) {
                      _loadInitialNews();
                    },
                    decoration: InputDecoration(
                      hintText: 'search_news'.tr(context),
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF5E0006)),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: Color(0xFF5E0006)),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = "";
                                });
                                _loadInitialNews(forceRefresh: true);
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF5E0006), width: 1),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip('today'.tr(context), 0),
                        const SizedBox(width: 8),
                        _buildFilterChip('yesterday'.tr(context), 1),
                        const SizedBox(width: 8),
                        _buildFilterChip('before'.tr(context), 2),
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

    final filteredItems = _newsItems.where((item) {
      if (_searchQuery.isEmpty) return true;
      return item.title.toLowerCase().contains(_searchQuery) ||
          item.description.toLowerCase().contains(_searchQuery) ||
          item.category.toLowerCase().contains(_searchQuery) ||
          item.location.toLowerCase().contains(_searchQuery);
    }).toList();

    if (filteredItems.isEmpty) {
      return Padding(
        key: const ValueKey('empty'),
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text(
            _searchQuery.isEmpty
                ? 'no_announcements'.tr(context)
                : 'No matching announcements found.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Column(
      key: ValueKey('content_$_selectedFilterIndex'),
      children: filteredItems.map((item) {
        final String imageUrl = item.headerImageUrl.isNotEmpty
            ? item.headerImageUrl
            : (item.images.isNotEmpty ? item.images.first : '');
        return AnnouncementCard(
          contentId: item.id,
          category: item.category,
          categoryColor: item.categoryColor,
          title: item.title,
          description: item.description,
          location: item.location,
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
