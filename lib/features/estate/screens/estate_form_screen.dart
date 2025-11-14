// lib/features/estate/screens/estate_form_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/models/estate.dart';

class EstateFormScreen extends StatefulWidget {
  final void Function(Estate) onAddEstate;

  const EstateFormScreen({super.key, required this.onAddEstate});

  @override
  State<EstateFormScreen> createState() => _EstateFormScreenState();
}

class _EstateFormScreenState extends State<EstateFormScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _urlController = TextEditingController();

  void _onSubmit() {
    final title = _titleController.text.trim();
    final desc = _descController.text.trim();
    final priceText = _priceController.text.trim();
    final url = _urlController.text.trim();

    if (title.isEmpty || desc.isEmpty || priceText.isEmpty || url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Заполните все поля')),
      );
      return;
    }

    final price = int.tryParse(priceText);
    if (price == null || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Цена должна быть положительным числом')),
      );
      return;
    }

    final newEstate = Estate(
      id: DateTime.now().millisecondsSinceEpoch,
      title: title,
      description: desc,
      price: price,
      imageUrl: url,
      isLiked: false,
    );

    widget.onAddEstate(newEstate);
    if (context.canPop()) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Добавить объект')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Название *'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(labelText: 'Описание *'),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Цена (₽/мес) *'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(labelText: 'URL изображения *'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _onSubmit,
              child: const Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
}