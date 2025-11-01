import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EstateFilterForm extends StatefulWidget {
  final void Function(String?, int?, int?) onSaveFilters;

  const EstateFilterForm({super.key, required this.onSaveFilters});

  @override
  State<EstateFilterForm> createState() => _EstateFilterFormState();
}

class _EstateFilterFormState extends State<EstateFilterForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _minPriceController = TextEditingController();
  final _maxPriceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              ClipOval(
                child: CachedNetworkImage(
                  imageUrl: 'https://avatars.mds.yandex.net/i?id=b634df1c5175106aa06a9c30554a0a16cfb78387-7543982-images-thumbs&n=13',
                  width: 32,
                  height: 32,
                  placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.title, color: Colors.grey),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Название'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              ClipOval(
                child: CachedNetworkImage(
                  imageUrl: 'https://avatars.mds.yandex.net/i?id=618784b6da15f8fbd9e83a50028103fa7a0372e7-11951579-images-thumbs&n=13',
                  width: 32,
                  height: 32,
                  placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.attach_money, color: Colors.grey),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: _minPriceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Мин. цена'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              ClipOval(
                child: CachedNetworkImage(
                  imageUrl: 'https://avatars.mds.yandex.net/i?id=35751d6275c5abc8aec2b434d1924da996a18b5a-5334002-images-thumbs&n=13',
                  width: 32,
                  height: 32,
                  placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.monetization_on, color: Colors.grey),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: _maxPriceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Макс. цена'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final title = _titleController.text.isEmpty ? null : _titleController.text;
                  final min = _minPriceController.text.isEmpty
                      ? null
                      : int.tryParse(_minPriceController.text);
                  final max = _maxPriceController.text.isEmpty
                      ? null
                      : int.tryParse(_maxPriceController.text);

                  widget.onSaveFilters(title, min, max);
                }
              },
              child: const Text('Применить'),
            ),
          ),
        ],
      ),
    );
  }
}