# Verification - News Screen Update

I have implemented the requested changes for the News screen.

## Changes Verified

### 1. Removal of Day-wise Filters
- The `_selectedFilterIndex` state has been removed.
- The `_getFilterDateRange` helper function has been removed.
- The `ChoiceChip` widgets for "Today", "Yesterday", and "Before" have been removed from the UI.
- The UI now shows "Official Updates" and "Latest Village Announcements" followed directly by the search bar and the news list.

### 2. Lazy Loading (8-item Batches)
- **Initial Load**: `_loadInitialNews` now calls `AppRepository.getNews` with `limit: 8`.
- **Pagination**: `_onScroll` triggers `_loadMoreNews` when the user scrolls near the bottom (within 200 pixels).
- **Subsequent Batches**: `_loadMoreNews` fetches 8 items at a time using the `startAfter` token.
- **Has More Logic**: `_hasMore` is correctly set based on whether the returned list length equals the limit (8).

### 3. Repository Consistency
- No changes were required in `AppRepository` as it already supported `limit` and `startAfter`.

## Code Review Snippets

### Initial Load
```dart
      final result = await AppRepository.instance.getNews(
        forceRefresh: forceRefresh,
        limit: 8,
      );
```

### Load More
```dart
      final result = await AppRepository.instance.getNews(
        startAfter: _lastDoc,
        limit: 8,
      );
```

### Scroll Listener
```dart
  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (!_isMoreLoading && _hasMore && !_isLoading) {
        _loadMoreNews();
      }
    }
  }
```
