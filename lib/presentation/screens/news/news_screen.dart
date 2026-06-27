import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../data/models/news_model.dart';
import '../../../data/repositories/app_repository.dart';
import '../../../core/config/app_config.dart';
import '../../../core/services/settings_service.dart';
import '../../../core/services/translation_service.dart';
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
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  String _translatedQuery = "";
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
      // If searching, we fetch a larger batch (e.g., 50 items) to ensure 
      // the client-side filter has enough data to show relevant results.
      final int fetchLimit = _searchQuery.isEmpty ? 8 : 50;

      final result = await AppRepository.instance.getNews(
        forceRefresh: forceRefresh,
        limit: fetchLimit,
      );

      if (mounted) {
        setState(() {
          _newsItems.addAll(result.news);
          _lastDoc = result.lastDoc;
          _isLoading = false;
          _hasMore = result.news.length == fetchLimit;
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
      final int fetchLimit = _searchQuery.isEmpty ? 8 : 50;
      
      final result = await AppRepository.instance.getNews(
        startAfter: _lastDoc,
        limit: fetchLimit,
      );

      if (mounted) {
        setState(() {
          _newsItems.addAll(result.news);
          _lastDoc = result.lastDoc;
          _isMoreLoading = false;
          _hasMore = result.news.length == fetchLimit;
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
        title: ListenableBuilder(
          listenable: SettingsService.instance,
          builder: (context, _) {
            return Text(
              'app_title'.tr(context),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            );
          },
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
      body: ListenableBuilder(
        listenable: SettingsService.instance,
        builder: (context, _) {
          return RefreshIndicator(
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
                          _debounce = Timer(const Duration(milliseconds: 500), () async {
                            if (mounted && _searchQuery.isNotEmpty) {
                              // Detect language and translate for cross-language search
                              final bool isKannada = RegExp(r'[\u0C80-\u0CFF]').hasMatch(_searchQuery);
                              final targetLang = isKannada ? 'en' : 'kn';
                              
                              try {
                                final translated = await TranslationService.instance.translate(_searchQuery, targetLang);
                                if (mounted && translated != _searchQuery) {
                                  setState(() {
                                    _translatedQuery = translated.toLowerCase();
                                  });
                                }
                              } catch (e) {
                                debugPrint('Search translation error: $e');
                              }
                              
                              _loadInitialNews();
                            } else if (_searchQuery.isEmpty) {
                              setState(() {
                                _translatedQuery = "";
                              });
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
                                      _translatedQuery = "";
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
          );
        },
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

    final String query = _searchQuery.toLowerCase().trim();
    final String translatedQuery = _translatedQuery.toLowerCase().trim();
    List<News> filteredItems;

    if (query.isEmpty) {
      filteredItems = List.from(_newsItems);
    } else {
      final queryWords = query.split(RegExp(r'\s+'));
      final translatedWords = translatedQuery.isNotEmpty 
          ? translatedQuery.split(RegExp(r'\s+')) 
          : <String>[];
      
      final Map<String, ({News item, int score})> scoredMap = {};

      for (final item in _newsItems) {
        int score = 0;
        final title = item.title.toLowerCase();
        final description = item.description.toLowerCase();

        // 1. Exact phrase match (High Priority)
        if (title.contains(query)) score += 100;
        if (translatedQuery.isNotEmpty && title.contains(translatedQuery)) score += 80;

        // 2. Word matches
        for (final word in queryWords) {
          if (word.length < 2) continue;
          if (title.contains(word)) score += 30;
          if (description.contains(word)) score += 15;
        }

        // 3. Translated word matches
        for (final word in translatedWords) {
          if (word.length < 2) continue;
          if (title.contains(word)) score += 20;
          if (description.contains(word)) score += 10;
        }

        if (score > 0) {
          scoredMap[item.id] = (item: item, score: score);
        }
      }

      final List<({News item, int score})> scoredList = scoredMap.values.toList();
      scoredList.sort((a, b) => b.score.compareTo(a.score));
      filteredItems = scoredList.map((s) => s.item).toList();
    }

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
      key: const ValueKey('content'),
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
          date: item.date,
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
}
