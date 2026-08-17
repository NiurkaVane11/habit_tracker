import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/habit.dart';
import '../providers/habit_provider.dart';

class HabitTile extends StatelessWidget {
  final Habit habit;

  const HabitTile({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HabitProvider>();
    final completado = provider.estaCompletadoHoy(habit.id);
    final racha = provider.calcularRacha(habit.id);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        leading: Text(habit.icono, style: const TextStyle(fontSize: 28)),
        title: Text(
          habit.nombre,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: racha > 0
            ? Text('🔥 $racha días seguidos')
            : const Text('Empieza hoy'),
        trailing: Checkbox(
          value: completado,
          onChanged: (_) {
            context.read<HabitProvider>().toggleCheckHoy(habit.id);
          },
        ),
        onLongPress: () {
          _confirmarEliminar(context);
        },
      ),
    );
  }

  void _confirmarEliminar(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('¿Eliminar hábito?'),
        content: Text('Se borrará "${habit.nombre}" y todo su progreso.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              context.read<HabitProvider>().eliminarHabito(habit.id);
              Navigator.pop(ctx);
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
