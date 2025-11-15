// lib/features/estate/screens/estates_list_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/models/estate.dart';
import '../../../shared/widgets/estate_item.dart';
import '../../../app_dependencies.dart';

class EstatesListScreen extends StatelessWidget {
  const EstatesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final model = DependenciesProvider.of(context);
    final estates = model.estates;

    return _EstatesListBody(estates: estates);
  }
}

class _EstatesListBody extends StatefulWidget {
  final List<Estate> estates;

  const _EstatesListBody({required this.estates});

  @override
  State<_EstatesListBody> createState() => __EstatesListBodyState();
}

class __EstatesListBodyState extends State<_EstatesListBody> {
  String? _filterTitle;
  int? _filterMinPrice;
  int? _filterMaxPrice;

  List<Estate> get _filteredEstates {
    return widget.estates.where((estate) {
      if (_filterTitle != null && _filterTitle!.isNotEmpty && !estate.title.toLowerCase().contains(_filterTitle!.toLowerCase())) return false;
      if (_filterMinPrice != null && estate.price < _filterMinPrice!) return false;
      if (_filterMaxPrice != null && estate.price > _filterMaxPrice!) return false;
      return true;
    }).toList();
  }

  void _clearFilters() => setState(() => _filterTitle = _filterMinPrice = _filterMaxPrice = null);
  void _navigateToEstateInfo(Estate estate) => context.push('/estate/${estate.id}');
  void _navigateToEstateForm() => context.push('/estate/add');

  void _navigateToFilterScreen() async {
    final result = await context.push<Map<String, dynamic>>('/estate/filters', extra: {
      'title': _filterTitle,
      'minPrice': _filterMinPrice,
      'maxPrice': _filterMaxPrice,
    });
    if (result != null) {
      setState(() {
        _filterTitle = result['title'] as String?;
        _filterMinPrice = result['minPrice'] as int?;
        _filterMaxPrice = result['maxPrice'] as int?;
      });
    }
  }

  bool get _hasActiveFilters => _filterTitle != null || _filterMinPrice != null || _filterMaxPrice != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Недвижимость'),
        actions: [
          if (_hasActiveFilters) IconButton(icon: const Icon(Icons.clear, color: Colors.white), onPressed: _clearFilters),
          IconButton(icon: const Icon(Icons.filter_list), onPressed: _navigateToFilterScreen),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: _navigateToEstateForm, child: const Icon(Icons.add)),
      body: _filteredEstates.isEmpty
          ? const Center(child: Text('Нет объектов'))
          : ListView.builder(
        padding: const EdgeInsets.only(top: 8),
        itemCount: _filteredEstates.length,
        itemBuilder: (context, index) {
          final estate = _filteredEstates[index];
          return GestureDetector(
            onTap: () => _navigateToEstateInfo(estate),
            child: EstateItem(estate: estate),
          );
        },
      ),
    );
  }
}