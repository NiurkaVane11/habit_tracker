import 'package:hive_flutter/hive_flutter.dart';

import '../models/habit.dart';
import '../models/habit_entry.dart';

class HiveService {
  static const String habitsBoxName = 'habits';
  static const String entriesBoxName = 'habit_entries';

  static Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(HabitAdapter());
    Hive.registerAdapter(HabitEntryAdapter());

    await Hive.openBox<Habit>(habitsBoxName);
    await Hive.openBox<HabitEntry>(entriesBoxName);
  }

  static Box<Habit> get habitsBox => Hive.box<Habit>(habitsBoxName);
  static Box<HabitEntry> get entriesBox => Hive.box<HabitEntry>(entriesBoxName);
}
