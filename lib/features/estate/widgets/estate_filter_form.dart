import 'package:flutter/material.dart';

class EstateFilterForm extends StatefulWidget {
  final void Function(String?, int?, int?) onSave;

  const EstateFilterForm({super.key, required this.onSave});

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
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Название'),
          ),
          TextFormField(
            controller: _minPriceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Мин. цена'),
          ),
          TextFormField(
            controller: _maxPriceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Макс. цена'),
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

                  widget.onSave(title, min, max);
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