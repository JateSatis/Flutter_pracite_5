// lib/features/estate/screens/estates_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:practice_5_project/shared/cubits/estate_cubit.dart';
import '../../../shared/models/estate.dart';
import '../../../shared/widgets/estate_item.dart';

class EstatesListScreen extends StatefulWidget {
  const EstatesListScreen({super.key});

  @override
  State<EstatesListScreen> createState() => _EstatesListScreenState();
}

class _EstatesListScreenState extends State<EstatesListScreen> {
  String? _filterTitle;
  int? _filterMinPrice;
  int? _filterMaxPrice;
  double? _filterMinRating;

  List<Estate> _filterEstates(List<Estate> estates) {
    return estates.where((estate) {
      if (_filterTitle != null && _filterTitle!.isNotEmpty) {
        if (!estate.title.toLowerCase().contains(_filterTitle!.toLowerCase())) {
          return false;
        }
      }
      if (_filterMinPrice != null && estate.price < _filterMinPrice!) return false;
      if (_filterMaxPrice != null && estate.price > _filterMaxPrice!) return false;
      if (_filterMinRating != null) {
        final rating = estate.reviewsAmount > 0
            ? estate.totalStars / estate.reviewsAmount
            : 0.0;
        if (rating < _filterMinRating!) return false;
      }
      return true;
    }).toList();
  }

  void _clearFilters() {
    setState(() {
      _filterTitle = null;
      _filterMinPrice = null;
      _filterMaxPrice = null;
      _filterMinRating = null;
    });
  }

  void _navigateToEstateInfo(Estate estate) {
    context.push('/estate/${estate.id}');
  }

  void _navigateToEstateForm() {
    context.push('/estate/add');
  }

  void _navigateToFilterScreen() async {
    final result = await context.push<Map<String, dynamic>>('/estate/filters', extra: {
      'title': _filterTitle,
      'minPrice': _filterMinPrice,
      'maxPrice': _filterMaxPrice,
      'minRating': _filterMinRating,
    });
    if (result != null) {
      setState(() {
        _filterTitle = result['title'] as String?;
        _filterMinPrice = result['minPrice'] as int?;
        _filterMaxPrice = result['maxPrice'] as int?;
        _filterMinRating = result['minRating'] as double?;
      });
    }
  }

  bool get _hasActiveFilters =>
      _filterTitle != null ||
      _filterMinPrice != null ||
      _filterMaxPrice != null ||
      _filterMinRating != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Недвижимость'),
        actions: [
          if (_hasActiveFilters)
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.white),
              onPressed: _clearFilters,
            ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _navigateToFilterScreen,
          ),
        ],
      ),
      body: BlocBuilder<EstateCubit, List<Estate>>(
        builder: (context, estates) {
          final filtered = _filterEstates(estates);
          return filtered.isEmpty
              ? const Center(child: Text('Нет объектов'))
              : ListView.builder(
            padding: const EdgeInsets.only(top: 8),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final estate = filtered[index];
              return GestureDetector(
                onTap: () => _navigateToEstateInfo(estate),
                child: EstateItem(estate: estate),
              );
            },
          );
        },
      ),
    );
  }
}