import 'package:hive/hive.dart';

part 'habit.g.dart';

@HiveType(typeId: 0)
class Habit extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String nombre;

  @HiveField(2)
  String icono; // emoji, ej: "💧" o "🏃"

  @HiveField(3)
  DateTime fechaCreacion;

  Habit({
    required this.id,
    required this.nombre,
    required this.icono,
    required this.fechaCreacion,
  });
}
