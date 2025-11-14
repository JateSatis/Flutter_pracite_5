import 'package:flutter/material.dart';
import '../../../shared/models/estate.dart';
import '../../../shared/widgets/estate_item.dart';
import 'estate_info_screen.dart';
import 'estate_form_screen.dart';
import 'estate_filter_screen.dart';

class EstatesListScreen extends StatefulWidget {
  final List<Estate> estates;
  final void Function(int) onLikeEstate;
  final void Function(int) onDeleteEstate;
  final void Function(Estate) onAddEstate;

  const EstatesListScreen({
    super.key,
    required this.estates,
    required this.onLikeEstate,
    required this.onDeleteEstate,
    required this.onAddEstate,
  });

  @override
  State<EstatesListScreen> createState() => _EstatesListScreenState();
}

class _EstatesListScreenState extends State<EstatesListScreen> {
  String? _filterTitle;
  int? _filterMinPrice;
  int? _filterMaxPrice;

  List<Estate> get _filteredEstates {
    return widget.estates.where((estate) {
      if (_filterTitle != null && _filterTitle!.isNotEmpty) {
        if (!estate.title.toLowerCase().contains(_filterTitle!.toLowerCase())) {
          return false;
        }
      }
      if (_filterMinPrice != null && estate.price < _filterMinPrice!) return false;
      if (_filterMaxPrice != null && estate.price > _filterMaxPrice!) return false;
      return true;
    }).toList();
  }

  void _clearFilters() {
    setState(() {
      _filterTitle = null;
      _filterMinPrice = null;
      _filterMaxPrice = null;
    });
  }

  void _navigateToEstateInfo(Estate estate) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EstateInfoScreen(
          estate: estate,
          onLikeEstate: widget.onLikeEstate,
          onDeleteEstate: widget.onDeleteEstate,
        ),
      ),
    );
  }

  void _navigateToEstateForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EstateFormScreen(
          onAddEstate: (estate) {
            widget.onAddEstate(estate);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _navigateToFilterScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EstateFilterScreen(
          initialTitle: _filterTitle,
          initialMinPrice: _filterMinPrice,
          initialMaxPrice: _filterMaxPrice,
        ),
      ),
    );
    if (result != null && mounted) {
      if (result is Map) {
        setState(() {
          _filterTitle = result['title'] as String?;
          _filterMinPrice = result['minPrice'] as int?;
          _filterMaxPrice = result['maxPrice'] as int?;
        });
      }
    }
  }

  bool get _hasActiveFilters =>
      _filterTitle != null || _filterMinPrice != null || _filterMaxPrice != null;

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
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToEstateForm,
        child: const Icon(Icons.add),
      ),
      body: _filteredEstates.isEmpty
          ? const Center(child: Text('Нет объектов'))
          : ListView.builder(
        padding: const EdgeInsets.only(top: 8),
        itemCount: _filteredEstates.length,
        itemBuilder: (context, index) {
          final estate = _filteredEstates[index];
          return GestureDetector(
            onTap: () => _navigateToEstateInfo(estate),
            child: EstateItem(
              estate: estate,
              onLikeEstate: widget.onLikeEstate,
              onDeleteEstate: widget.onDeleteEstate,
            ),
          );
        },
      ),
    );
  }
}