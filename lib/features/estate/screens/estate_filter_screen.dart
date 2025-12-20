// lib/features/estate/screens/estate_filter_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EstateFilterScreen extends StatefulWidget {
  final String? initialTitle;
  final int? initialMinPrice;
  final int? initialMaxPrice;
  final double? initialMinRating;

  const EstateFilterScreen({
    super.key,
    this.initialTitle,
    this.initialMinPrice,
    this.initialMaxPrice,
    this.initialMinRating,
  });

  @override
  State<EstateFilterScreen> createState() => _EstateFilterScreenState();
}

class _EstateFilterScreenState extends State<EstateFilterScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _minPriceController;
  late final TextEditingController _maxPriceController;
  late final TextEditingController _minRatingController;
  int _selectedRating = 0;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle ?? '');
    _minPriceController = TextEditingController(text: widget.initialMinPrice?.toString() ?? '');
    _maxPriceController = TextEditingController(text: widget.initialMaxPrice?.toString() ?? '');
    _minRatingController = TextEditingController(
      text: widget.initialMinRating?.toString() ?? '',
    );
    _selectedRating = widget.initialMinRating?.round() ?? 0;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    _minRatingController.dispose();
    super.dispose();
  }

  void _onApply() {
    if (_formKey.currentState!.validate()) {
      final title = _titleController.text.trim().isNotEmpty
          ? _titleController.text.trim()
          : null;
      final min = _minPriceController.text.trim().isNotEmpty
          ? int.tryParse(_minPriceController.text.trim())
          : null;
      final max = _maxPriceController.text.trim().isNotEmpty
          ? int.tryParse(_maxPriceController.text.trim())
          : null;
      final minRating = _selectedRating > 0 ? _selectedRating.toDouble() : null;

      context.pop({
        'title': title,
        'minPrice': min,
        'maxPrice': max,
        'minRating': minRating,
      });
    }
  }

  void _onClear() {
    _titleController.clear();
    _minPriceController.clear();
    _maxPriceController.clear();
    _minRatingController.clear();
    _selectedRating = 0;
    setState(() {});
    _formKey.currentState!.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Фильтры'),
        actions: [
          TextButton(
            onPressed: _onClear,
            child: const Text('Сбросить', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Название'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _minPriceController,
                decoration: const InputDecoration(labelText: 'Мин. цена'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return null;
                  final num = int.tryParse(v);
                  if (num == null) return 'Введите число';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _maxPriceController,
                decoration: const InputDecoration(labelText: 'Макс. цена'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return null;
                  final num = int.tryParse(v);
                  if (num == null) return 'Введите число';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text('Минимальная оценка'),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < _selectedRating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 32,
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedRating = index + 1;
                      });
                    },
                  );
                }),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _onApply,
                child: const Text('Применить фильтры'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}