import 'package:flutter/material.dart';
import '../../../shared/models/estate.dart';

class EstateFormScreen extends StatefulWidget {
  final void Function(Estate) onAddEstate;
  final VoidCallback onBack;

  const EstateFormScreen({
    super.key,
    required this.onAddEstate,
    required this.onBack,
  });

  @override
  State<EstateFormScreen> createState() => _EstateFormScreenState();
}

class _EstateFormScreenState extends State<EstateFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить объект'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Название'),
                validator: (value) => value == null || value.isEmpty ? 'Обязательно' : null,
              ),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Описание'),
                validator: (value) => value == null || value.isEmpty ? 'Обязательно' : null,
              ),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Цена (₽/мес)'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Обязательно';
                  if (int.tryParse(value) == null) return 'Только число';
                  return null;
                },
              ),
              TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(labelText: 'Ссылка на изображение'),
                validator: (value) => value == null || value.isEmpty ? 'Обязательно' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final estate = Estate(
                      id: DateTime.now().millisecondsSinceEpoch,
                      title: _titleController.text,
                      description: _descController.text,
                      price: int.parse(_priceController.text),
                      imageUrl: _imageController.text,
                      isLiked: false,
                    );
                    widget.onAddEstate(estate);
                    widget.onBack();
                  }
                },
                child: const Text('Добавить'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}