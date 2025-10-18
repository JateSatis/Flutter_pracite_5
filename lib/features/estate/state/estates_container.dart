import 'package:flutter/material.dart';
import '../../../shared/models/estate.dart';
import '../screens/estates_list_screen.dart';
import '../screens/estate_info_screen.dart';
import '../screens/estate_form_screen.dart';

enum EstateScreen { list, info, form }

class EstatesContainer extends StatefulWidget {
  final List<Estate> estates;
  final void Function(Estate) onAddEstate;
  final void Function(int) onLikeEstate;
  final void Function(int) onDeleteEstate;

  const EstatesContainer({
    super.key,
    required this.estates,
    required this.onAddEstate,
    required this.onLikeEstate,
    required this.onDeleteEstate,
  });

  @override
  State<EstatesContainer> createState() => _EstatesContainerState();
}

class _EstatesContainerState extends State<EstatesContainer> {
  EstateScreen _currentScreen = EstateScreen.list;
  Estate? _selectedEstate;

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

  void _showList() => setState(() => _currentScreen = EstateScreen.list);
  void _showInfo(Estate estate) {
    _selectedEstate = estate;
    setState(() => _currentScreen = EstateScreen.info);
  }

  void _showForm() => setState(() => _currentScreen = EstateScreen.form);

  void _setFilters(String? title, int? min, int? max) {
    setState(() {
      _filterTitle = title;
      _filterMinPrice = min;
      _filterMaxPrice = max;
    });
  }

  void _clearFilters() {
    _setFilters(null, null, null);
  }

  @override
  Widget build(BuildContext context) {
    switch (_currentScreen) {
      case EstateScreen.list:
        return EstatesListScreen(
          estates: _filteredEstates,
          onAddEstate: widget.onAddEstate,
          onLikeEstate: widget.onLikeEstate,
          onDeleteEstate: widget.onDeleteEstate,
          onShowInfo: _showInfo,
          onShowForm: _showForm,
          onSetFilters: _setFilters,
          onClearFilters: _clearFilters,
          hasActiveFilters: _filterTitle != null || _filterMinPrice != null || _filterMaxPrice != null,
        );

      case EstateScreen.info:
        return EstateInfoScreen(
          estate: _selectedEstate!,
          onLikeEstate: widget.onLikeEstate,
          onDeleteEstate: widget.onDeleteEstate,
          onBack: _showList,
        );

      case EstateScreen.form:
        return EstateFormScreen(
          onAddEstate: (estate) {
            widget.onAddEstate(estate);
            _showList();
          },
          onBack: _showList,
        );
    }
  }
}