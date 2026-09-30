# Habit Tracker

App móvil en **Flutter** para crear hábitos, marcarlos cada día y seguir tu progreso.

## Funcionalidades
- Crear hábitos con nombre e ícono
- Marcar el hábito como cumplido cada día
- **Racha** de días seguidos 🔥
- Detalle de cada hábito con **gráfico semanal** y calendario de progreso
- Datos guardados en el dispositivo (funciona sin internet)

## Tecnologías
Flutter · Dart · Provider (estado) · Hive (almacenamiento local) · fl_chart (gráficos)

## Estructura
```
lib/
  models/     Habit y HabitEntry (modelos Hive)
  providers/  HabitProvider: lógica y cálculo de rachas
  screens/    Inicio, nuevo hábito y detalle
  services/   Inicialización de Hive
  widgets/    HabitTile
```

## Ejecutar
```bash
flutter pub get
flutter run
```
