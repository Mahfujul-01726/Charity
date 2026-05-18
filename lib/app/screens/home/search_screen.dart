import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import '../../core/theme/app_colors.dart';
import '../../data/mock_data.dart';
import '../../widgets/three_d_background.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredCategories = [];
  List<Map<String, dynamic>> _filteredCampaigns = [];
  bool _isSearching = false;

  // Advanced search features
  final Set<String> _selectedFilters = {};
  String _sortBy = 'relevance'; // relevance, recent, popular
  bool _showAdvancedSearch = false;
  List<String> _searchHistory = [];
  late FocusNode _searchFocusNode;

  // Typewriter Effect Logic
  final List<String> _hints = [
    "Search 'Donate Blood'...",
    "Search 'Winter Campaigns'...",
    "Search 'NGOs near me'...",
    "Search 'Education'...",
    "Search 'Medical Aid'...",
  ];
  int _currentHintIndex = 0;
  String _displayedHint = "";
  Timer? _typewriterTimer;
  int _charIndex = 0;
  bool _isDeleting = false;

  final List<String> _quickTags = [
    "Blood",
    "Winter",
    "Food",
    "Medical",
    "Education",
    "Money",
    "Clothes",
  ];

  final List<String> _filterOptions = [
    "Categories",
    "Campaigns",
    "Urgent",
    "Near Me",
  ];

  final List<String> _recentSearches = [
    "Orphanage Support",
    "Flood Relief",
    "Old Books",
  ];

  @override
  void initState() {
    super.initState();
    // Start with empty results, waiting for user input
    _filteredCategories = [];
    _filteredCampaigns = [];
    _searchFocusNode = FocusNode();
    _startTypewriter();
    _loadSearchHistory();
  }

  Future<void> _loadSearchHistory() async {
    // Load from shared preferences or database
    // For now, using initial recent searches
    _searchHistory = List.from(_recentSearches);
  }

  void _startTypewriter() {
    _typewriterTimer = Timer.periodic(const Duration(milliseconds: 100), (
      timer,
    ) {
      if (!mounted) return;

      setState(() {
        final currentFullHint = _hints[_currentHintIndex];

        if (!_isDeleting) {
          if (_charIndex < currentFullHint.length) {
            _charIndex++;
            _displayedHint = currentFullHint.substring(0, _charIndex);
          } else {
            // Finished typing, wait a bit then delete
            _isDeleting = true;
            timer.cancel();
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) _startTypewriter();
            });
          }
        } else {
          if (_charIndex > 0) {
            _charIndex--;
            _displayedHint = currentFullHint.substring(0, _charIndex);
          } else {
            // Finished deleting, move to next hint
            _isDeleting = false;
            _currentHintIndex = (_currentHintIndex + 1) % _hints.length;
          }
        }
      });
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;
      if (query.isEmpty) {
        _filteredCategories = [];
        _filteredCampaigns = [];
      } else {
        // Filter categories
        _filteredCategories = categories.where((category) {
          final title = category['title'].toString().toLowerCase();
          final subtitle = category['subtitle'].toString().toLowerCase();
          final matchesQuery =
              title.contains(query.toLowerCase()) ||
              subtitle.contains(query.toLowerCase());

          // Apply filters if any selected
          if (_selectedFilters.contains('Categories')) {
            return matchesQuery;
          }
          return matchesQuery;
        }).toList();

        // Filter campaigns
        _filteredCampaigns = campaigns.where((campaign) {
          final title = campaign['title'].toString().toLowerCase();
          final subtitle = campaign['subtitle'].toString().toLowerCase();
          final matchesQuery =
              title.contains(query.toLowerCase()) ||
              subtitle.contains(query.toLowerCase());

          // Apply filters if any selected
          if (_selectedFilters.contains('Campaigns')) {
            return matchesQuery;
          }
          return matchesQuery;
        }).toList();

        // Apply sorting
        _applySorting();

        // Add to search history
        if (!_searchHistory.contains(query)) {
          _searchHistory.insert(0, query);
          if (_searchHistory.length > 10) {
            _searchHistory.removeLast();
          }
        }
      }
    });
  }

  void _applySorting() {
    if (_sortBy == 'recent') {
      // Sort by recent (reverse order)
      _filteredCampaigns.sort(
        (a, b) => b['timestamp']?.compareTo(a['timestamp'] ?? 0) ?? 0,
      );
    } else if (_sortBy == 'popular') {
      // Sort by popularity/views
      _filteredCampaigns.sort(
        (a, b) => (b['views'] ?? 0).compareTo(a['views'] ?? 0),
      );
    }
    // 'relevance' uses default order from search
  }

  void _toggleFilter(String filter) {
    setState(() {
      if (_selectedFilters.contains(filter)) {
        _selectedFilters.remove(filter);
      } else {
        _selectedFilters.add(filter);
      }
      // Reapply search with new filters
      _onSearchChanged(_searchController.text);
    });
  }

  void _changeSortBy(String newSort) {
    setState(() {
      _sortBy = newSort;
      _applySorting();
    });
  }

  void _toggleAdvancedSearch() {
    setState(() {
      _showAdvancedSearch = !_showAdvancedSearch;
    });
  }

  void _clearSearchHistory() {
    setState(() {
      _searchHistory.clear();
    });
  }

  void _onTagTap(String tag) {
    _searchController.text = tag;
    _onSearchChanged(tag);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _typewriterTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      resizeToAvoidBottomInset: false, // Prevent background shift
      body: ThreeDBackground(
        isDark: isDark,
        child: SafeArea(
          child: Column(
            children: [
              _buildCreativeHeader(context, isDark),

              // Advanced Search Toggle & Filters
              if (_isSearching) _buildAdvancedSearchBar(isDark),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // INITIAL STATE: Quick Tags & Recent
                      if (!_isSearching) ...[
                        const SizedBox(height: 20),
                        _buildSectionTitle('Quick Search'),
                        const SizedBox(height: 15),
                        _buildQuickTags(isDark),
                        const SizedBox(height: 30),
                        if (_searchHistory.isNotEmpty) ...[
                          _buildSectionTitle('Search History'),
                          const SizedBox(height: 15),
                          _buildSearchHistory(isDark),
                          const SizedBox(height: 30),
                        ],
                        _buildSectionTitle('Recent Searches'),
                        const SizedBox(height: 15),
                        _buildRecentSearches(isDark),
                      ],

                      // SEARCH RESULTS
                      if (_isSearching) ...[
                        const SizedBox(height: 20),
                        if (_filteredCategories.isEmpty &&
                            _filteredCampaigns.isEmpty)
                          _buildNoResults(),

                        if (_filteredCategories.isNotEmpty) ...[
                          _buildSectionTitle(
                            'Categories Found (${_filteredCategories.length})',
                          ),
                          const SizedBox(height: 15),
                          _buildCategoryGrid(isDark),
                          const SizedBox(height: 25),
                        ],

                        if (_filteredCampaigns.isNotEmpty) ...[
                          _buildSectionTitle(
                            'Campaigns Found (${_filteredCampaigns.length})',
                          ),
                          const SizedBox(height: 15),
                          _buildCampaignList(isDark),
                        ],
                      ],
                      const SizedBox(height: 40), // Bottom padding
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white.withOpacity(0.9),
        shadows: [
          Shadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickTags(bool isDark) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _quickTags.map((tag) {
        return GestureDetector(
          onTap: () => _onTagTap(tag),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Text(
              tag,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRecentSearches(bool isDark) {
    return Column(
      children: _recentSearches.map((search) {
        return GestureDetector(
          onTap: () => _onTagTap(search),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.history_rounded,
                  color: Colors.white.withOpacity(0.5),
                  size: 20,
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    search,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 16,
                    ),
                  ),
                ),
                Icon(
                  Icons.north_west_rounded,
                  color: Colors.white.withOpacity(0.3),
                  size: 16,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Column(
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 60,
              color: Colors.white.withOpacity(0.5),
            ),
            const SizedBox(height: 15),
            Text(
              'No results found',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Try searching for something else',
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreativeHeader(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Container(
              height: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [AppColors.purple, AppColors.pink],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.purple.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.darkBackground.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 15),
                      Icon(
                        Icons.search_rounded,
                        color: Colors.white.withOpacity(0.8),
                        size: 24,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          focusNode: _searchFocusNode,
                          onChanged: _onSearchChanged,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            hintText: _displayedHint,
                            hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 16,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      if (_searchController.text.isNotEmpty)
                        IconButton(
                          icon: const Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            _onSearchChanged('');
                          },
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Icon(
                            Icons.mic_none_rounded,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedSearchBar(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          // Sort & Filter Toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.sort_rounded,
                      color: Colors.white.withOpacity(0.7),
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    DropdownButton<String>(
                      value: _sortBy,
                      dropdownColor: AppColors.darkBackground,
                      underline: const SizedBox(),
                      items: ['relevance', 'recent', 'popular'].map((sort) {
                        return DropdownMenuItem(
                          value: sort,
                          child: Text(
                            sort.toUpperCase(),
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) _changeSortBy(value);
                      },
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: _toggleAdvancedSearch,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _showAdvancedSearch
                        ? AppColors.purple.withOpacity(0.3)
                        : Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _showAdvancedSearch
                          ? AppColors.purple.withOpacity(0.5)
                          : Colors.white.withOpacity(0.1),
                    ),
                  ),
                  child: Icon(
                    _showAdvancedSearch
                        ? Icons.tune_rounded
                        : Icons.tune_outlined,
                    color: _showAdvancedSearch
                        ? AppColors.purple
                        : Colors.white.withOpacity(0.7),
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          // Filter Chips
          if (_showAdvancedSearch) ...[
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filterOptions.map((filter) {
                  final isSelected = _selectedFilters.contains(filter);
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => _toggleFilter(filter),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.purple.withOpacity(0.3)
                              : Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.purple.withOpacity(0.5)
                                : Colors.white.withOpacity(0.1),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isSelected)
                              Padding(
                                padding: const EdgeInsets.only(right: 6),
                                child: Icon(
                                  Icons.check_rounded,
                                  size: 14,
                                  color: AppColors.purple,
                                ),
                              ),
                            Text(
                              filter,
                              style: TextStyle(
                                color: isSelected
                                    ? AppColors.purple
                                    : Colors.white.withOpacity(0.7),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchHistory(bool isDark) {
    return Column(
      children: [
        ..._searchHistory.take(5).map((search) {
          return GestureDetector(
            onTap: () => _onTagTap(search),
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search_rounded,
                    color: Colors.white.withOpacity(0.4),
                    size: 16,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      search,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.north_west_rounded,
                    color: Colors.white.withOpacity(0.3),
                    size: 14,
                  ),
                ],
              ),
            ),
          );
        }),
        if (_searchHistory.isNotEmpty)
          GestureDetector(
            onTap: _clearSearchHistory,
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Clear History',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCategoryGrid(bool isDark) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.9,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
      ),
      itemCount: _filteredCategories.length,
      itemBuilder: (context, index) {
        final category = _filteredCategories[index];
        return GestureDetector(
          onTap: category['onTap'],
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkCard
                  : Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (category['color'] as Color).withOpacity(0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: (category['color'] as Color).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    category['icon'],
                    color: category['color'],
                    size: 26,
                  ),
                ),
                Flexible(
                  child: Text(
                    category['title'],
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                Flexible(
                  child: Text(
                    category['subtitle'],
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCampaignList(bool isDark) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _filteredCampaigns.length,
      itemBuilder: (context, index) {
        final campaign = _filteredCampaigns[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  campaign['imageUrl'],
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 90,
                    height: 90,
                    color: Colors.grey[800],
                    child: const Icon(
                      Icons.image_not_supported,
                      color: Colors.white54,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.purple.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Campaign',
                        style: TextStyle(
                          color: AppColors.purple,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      campaign['title'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      campaign['subtitle'],
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 13,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white.withOpacity(0.3),
                size: 16,
              ),
              const SizedBox(width: 8),
            ],
          ),
        );
      },
    );
  }
}
