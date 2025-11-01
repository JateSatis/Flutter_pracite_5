import 'package:flutter/material.dart';
import '../../../shared/models/estate.dart';
import '../../../shared/widgets/estate_item.dart';
import '../widgets/estate_filter_form.dart';

class EstatesListScreen extends StatelessWidget {
  final List<Estate> estates;
  final void Function(Estate) onAddEstate;
  final void Function(int) onLikeEstate;
  final void Function(Estate) onShowInfo;
  final void Function() onShowForm;
  final void Function(String?, int?, int?) onSetFilters;
  final void Function(int) onDeleteEstate;
  final void Function() onClearFilters;
  final bool hasActiveFilters;

  const EstatesListScreen({
    super.key,
    required this.estates,
    required this.onAddEstate,
    required this.onLikeEstate,
    required this.onDeleteEstate,
    required this.onShowInfo,
    required this.onShowForm,
    required this.onSetFilters,
    required this.onClearFilters,
    required this.hasActiveFilters,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Недвижимость')),
      floatingActionButton: FloatingActionButton(
        onPressed: onShowForm,
        child: const Icon(Icons.add),
      ),
      body: Stack(
        children: [
          ListView.builder(
            padding: const EdgeInsets.only(top: 8),
            itemCount: estates.length,
            itemBuilder: (context, index) {
              final estate = estates[index];
              return GestureDetector(
                onTap: () => onShowInfo(estate),
                child: EstateItem(
                  estate: estate,
                  onLikeEstate: onLikeEstate,
                  onDeleteEstate: onDeleteEstate,
                ),
              );
            },
          ),
          Positioned(
            top: 16,
            right: 16,
            child: hasActiveFilters
                ? Container(
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.8),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.clear, color: Colors.white),
                onPressed: onClearFilters,
              ),
            )
                : Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.filter_list, color: Colors.green),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Фильтры'),
                      content: SizedBox(
                        width: double.maxFinite,
                        child: EstateFilterForm(
                          onSaveFilters: (title, min, max) {
                            onSetFilters(title, min, max);
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}