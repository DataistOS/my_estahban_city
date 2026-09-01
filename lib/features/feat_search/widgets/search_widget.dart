// lib/features/feat_search/widgets/search_widget.dart

import '../services/search_history_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class SearchWidget extends StatefulWidget {
  final ValueChanged<String> onSearch;
  final VoidCallback onScanPressed;

  const SearchWidget({
    super.key,
    required this.onSearch,
    required this.onScanPressed,
  });

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController _searchController = TextEditingController();
  final SearchHistoryService _searchHistoryService = SearchHistoryService();

  Timer? _debounceTimer;

  String _lastSavedQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchTextChanged);
  }

  void _onSearchTextChanged() {
    final query = _searchController.text.trim();

    widget.onSearch(query);

    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }

    if (query.isNotEmpty) {
      _debounceTimer = Timer(const Duration(milliseconds: 500), () {
        if (query != _lastSavedQuery) {
          _searchHistoryService.saveSearchQuery(query);
          _lastSavedQuery = query;
          if (kDebugMode) {
            print('Search query saved: $query');
          }
        }
      });
    } else {
      _lastSavedQuery = '';
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          labelText: 'جستجوی محصول...',
          labelStyle: const TextStyle(fontFamily: 'Vazir'),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            icon: const Icon(Icons.camera_alt, color: Color(0xFF333333)),
            onPressed: () {
              widget.onScanPressed();
            },
          ),
        ),
      ),
    );
  }
}
