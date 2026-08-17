import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../models/habit.dart';
import '../models/habit_entry.dart';
import '../services/hive_service.dart';

class HabitProvider extends ChangeNotifier {
  final _uuid = const Uuid();

  List<Habit> get habits => HiveService.habitsBox.values.toList();

  // Normaliza una fecha a solo año-mes-día (sin hora), para comparar bien
  DateTime _soloFecha(DateTime fecha) {
    return DateTime(fecha.year, fecha.month, fecha.day);
  }

  void agregarHabito(String nombre, String icono) {
    final habit = Habit(
      id: _uuid.v4(),
      nombre: nombre,
      icono: icono,
      fechaCreacion: DateTime.now(),
    );
    HiveService.habitsBox.put(habit.id, habit);
    notifyListeners();
  }

  void eliminarHabito(String habitId) {
    HiveService.habitsBox.delete(habitId);
    // Borra también todas sus entradas
    final entradas = HiveService.entriesBox.values
        .where((e) => e.habitId == habitId)
        .toList();
    for (var entrada in entradas) {
      entrada.delete();
    }
    notifyListeners();
  }

  // Busca si ya existe una entrada para ese hábito en una fecha dada
  HabitEntry? _buscarEntrada(String habitId, DateTime fecha) {
    final fechaNormalizada = _soloFecha(fecha);
    try {
      return HiveService.entriesBox.values.firstWhere(
        (e) => e.habitId == habitId && _soloFecha(e.fecha) == fechaNormalizada,
      );
    } catch (_) {
      return null;
    }
  }

  bool estaCompletadoHoy(String habitId) {
    final entrada = _buscarEntrada(habitId, DateTime.now());
    return entrada?.completado ?? false;
  }

  // Marca/desmarca el check del día de hoy
  void toggleCheckHoy(String habitId) {
    final hoy = DateTime.now();
    final entradaExistente = _buscarEntrada(habitId, hoy);

    if (entradaExistente != null) {
      entradaExistente.completado = !entradaExistente.completado;
      entradaExistente.save();
    } else {
      final nuevaEntrada = HabitEntry(
        habitId: habitId,
        fecha: _soloFecha(hoy),
        completado: true,
      );
      HiveService.entriesBox.add(nuevaEntrada);
    }
    notifyListeners();
  }

  // Calcula la racha actual (días consecutivos completados hasta hoy)
  int calcularRacha(String habitId) {
    final entradas = HiveService.entriesBox.values
        .where((e) => e.habitId == habitId && e.completado)
        .toList();

    if (entradas.isEmpty) return 0;

    entradas.sort((a, b) => b.fecha.compareTo(a.fecha));

    int racha = 0;
    DateTime fechaEsperada = _soloFecha(DateTime.now());

    for (var entrada in entradas) {
      final fechaEntrada = _soloFecha(entrada.fecha);
      if (fechaEntrada == fechaEsperada) {
        racha++;
        fechaEsperada = fechaEsperada.subtract(const Duration(days: 1));
      } else if (fechaEntrada.isBefore(fechaEsperada)) {
        break;
      }
    }
    return racha;
  }

  List<HabitEntry> entradasDeHabito(String habitId) {
    return HiveService.entriesBox.values
        .where((e) => e.habitId == habitId)
        .toList();
  }
}
