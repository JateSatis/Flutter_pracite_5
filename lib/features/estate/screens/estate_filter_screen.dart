import 'package:flutter/material.dart';

class EstateFilterScreen extends StatefulWidget {
  final String? initialTitle;
  final int? initialMinPrice;
  final int? initialMaxPrice;

  const EstateFilterScreen({
    super.key,
    this.initialTitle,
    this.initialMinPrice,
    this.initialMaxPrice,
  });

  @override
  State<EstateFilterScreen> createState() => _EstateFilterScreenState();
}

class _EstateFilterScreenState extends State<EstateFilterScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _minPriceController;
  late final TextEditingController _maxPriceController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle ?? '');
    _minPriceController = TextEditingController(text: widget.initialMinPrice?.toString() ?? '');
    _maxPriceController = TextEditingController(text: widget.initialMaxPrice?.toString() ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  void _onBack() {
    Navigator.pop(context);
  }

  void _onApply() {
    if (_formKey.currentState!.validate()) {
      final title = _titleController.text.trim().isNotEmpty ? _titleController.text.trim() : null;
      final min = _minPriceController.text.trim().isNotEmpty
          ? int.tryParse(_minPriceController.text.trim())
          : null;
      final max = _maxPriceController.text.trim().isNotEmpty
          ? int.tryParse(_maxPriceController.text.trim())
          : null;

      Navigator.pop(context, {
        'title': title,
        'minPrice': min,
        'maxPrice': max,
      });
    }
  }

  void _onClear() {
    _titleController.clear();
    _minPriceController.clear();
    _maxPriceController.clear();
    _formKey.currentState!.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Фильтры'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _onBack,
        ),
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