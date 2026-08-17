import 'package:hive/hive.dart';

part 'habit_entry.g.dart';

@HiveType(typeId: 1)
class HabitEntry extends HiveObject {
  @HiveField(0)
  String habitId;

  @HiveField(1)
  DateTime fecha; // solo año-mes-día, sin hora

  @HiveField(2)
  bool completado;

  HabitEntry({
    required this.habitId,
    required this.fecha,
    required this.completado,
  });
}
