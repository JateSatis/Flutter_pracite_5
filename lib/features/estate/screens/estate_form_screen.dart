// lib/features/estate/screens/estate_form_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:practice_5_project/shared/cubits/estate_cubit.dart';
import 'package:practice_5_project/shared/cubits/auth_cubit.dart';
import '../../../shared/models/estate.dart';

class EstateFormScreen extends StatefulWidget {
  const EstateFormScreen({super.key});

  @override
  State<EstateFormScreen> createState() => _EstateFormScreenState();
}

class _EstateFormScreenState extends State<EstateFormScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _urlController = TextEditingController();
  final _latitudeController = TextEditingController(text: '55.7558');
  final _longitudeController = TextEditingController(text: '37.6173');

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _urlController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    final title = _titleController.text.trim();
    final desc = _descController.text.trim();
    final priceText = _priceController.text.trim();
    final url = _urlController.text.trim();
    final latitudeText = _latitudeController.text.trim();
    final longitudeText = _longitudeController.text.trim();

    if (title.isEmpty ||
        desc.isEmpty ||
        priceText.isEmpty ||
        url.isEmpty ||
        latitudeText.isEmpty ||
        longitudeText.isEmpty) {
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

    final latitude = double.tryParse(latitudeText);
    final longitude = double.tryParse(longitudeText);
    if (latitude == null || longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Неверные координаты')),
      );
      return;
    }

    final currentUser = context.read<AuthCubit>().currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Необходимо войти в аккаунт')),
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
      latitude: latitude,
      longitude: longitude,
      ownerId: currentUser.id,
    );

    context.read<EstateCubit>().addEstate(newEstate);
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
            const SizedBox(height: 12),
            TextField(
              controller: _latitudeController,
              decoration: const InputDecoration(labelText: 'Широта *'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _longitudeController,
              decoration: const InputDecoration(labelText: 'Долгота *'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
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