import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/habit_provider.dart';

class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({super.key});

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final _nombreController = TextEditingController();
  String _iconoSeleccionado = '✅';

  final List<String> _iconosDisponibles = [
    '✅',
    '💧',
    '🏃',
    '📚',
    '🧘',
    '🥗',
    '😴',
    '💊',
    '🎯',
    '✍️',
  ];

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo hábito')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nombreController,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Nombre del hábito',
                hintText: 'Ej: Tomar agua',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Elige un ícono',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _iconosDisponibles.map((icono) {
                final seleccionado = icono == _iconoSeleccionado;
                return ChoiceChip(
                  label: Text(icono, style: const TextStyle(fontSize: 20)),
                  selected: seleccionado,
                  onSelected: (_) {
                    setState(() => _iconoSeleccionado = icono);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  if (_nombreController.text.trim().isEmpty) return;
                  context.read<HabitProvider>().agregarHabito(
                    _nombreController.text.trim(),
                    _iconoSeleccionado,
                  );
                  Navigator.pop(context);
                },
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text('Guardar hábito'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
